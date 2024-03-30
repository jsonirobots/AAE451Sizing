%% AAE 251 Fall 2022
%  ISA #1
%  AtmosphereModel (class)
%  Authors: Jatin Soni

%% Class Definition
classdef AtmosphereModel
    % AtmosphereModel A class to create a model of an atmosphere.
    %   This class uses provided parameters to establish lapse rates for
    %   different regions of an atmosphere. Equations from Anderson are then
    %   used to derive symoblic equations for Temperate, Pressure, Density, 
    %   and the Speed of Sound as a function of height.

%% Properties Definition
    properties
        specific_gas_constant = -1;      % J / (kg * K) 
        molecular_weight = -1;           % kg/mol

        gravitational_constant = -1;     % m * s^-2
        specific_heats_ratio = -1;       % heats ratio, 1.4 for Earth's air (only used for speed of sound calcs)

        heights_temperatures = []; % nx2 matrix, height and temp for each significant altitude. Col1 - height, Col2 - temp
        surface_pressure = -1;     % Pa
        surface_density = -1;      % Kg * m^-3

        lapse_rates = [];          % Auto calculated from height and temp data
    end
    
    % this property are kept private since the user won't need to access
    % them
    properties (Access=private)
        universal_gas_constant = 8.3145; % J / (mol * K) or kJ / (kmol * K)
    end

%% Methods Definition    
    methods
        function model = AtmosphereModel(height_temperature_matrix)
            % Constructor Method for Atmosphere Model class. Requires input
            % of a nx2 matrix, which represents the heights and
            % temperatures of the atmosphere where different layers start
            % and end. Earth example: [ [0 288.16] ; [11e3 216.78] ; [25e3 216.66] ; [47.4e3 282.66] ]

            % Error handling if input matrix is too small
            if(height(height_temperature_matrix) < 2  ||  width(height_temperature_matrix) < 2)
                error("Height-Temperature Matrix has insufficient data. Must be a nx2 matrix, with n >= 2.");
            end

            model.heights_temperatures = height_temperature_matrix;
            deltas = diff(model.heights_temperatures);  % creates a n-1 x 2 matrix of the difference of each row
            model.lapse_rates = deltas(:,2) ./ deltas(:,1); % gets lapse rate for each region by dividing the deltas in T and h
            clear deltas;   % delete temporary variable to save memory
        end

        function temperatureEquation = getTemperature(model)
            % Temperature model function. Uses equations from Anderson to
            % create a piecewise function for temperature through the
            % altitude range. The returned equation will be needed for the
            % pressure, density, and speed of sound functions.

            syms temperatureEquation(h);
            temperatureEquation(h) = 0;
            temps = model.heights_temperatures(:,2);
            heights = model.heights_temperatures(:,1);
            
            for region = 1:(height(temps)-1)
                temperatureEquation(h) = piecewise(heights(region) <= h <= heights(region+1),...
                    temps(region) + model.lapse_rates(region) * (h - heights(region)),...
                    temperatureEquation);
            end
            clear temps heights;    % delete temporary variable to save memory
        end

        function pressureEquation = getPressure(model,temperatureEquation)
            % Since the equations for pressure and density are very
            % similar, the actual math has been placed inside a single
            % function, and this function serves as a proxy to run that
            % function and pass a parameter to ensure pressure calculations
            % are done (using surface pressure).

            % error handling if gravity, gas constants, and surface
            % pressure aren't defined yet.
            if(model.gravitational_constant == -1 || model.surface_pressure == -1)
                error("Pressure models require a gravitation constant and surface pressure to be defined. "+...
                    "Use "+inputname(1)+".gravitational_constant = (number) and/or "+...
                    inputname(1)+".surface_pressure = (number).");
            elseif(model.specific_gas_constant == -1 && model.molecular_weight == -1)
                error("Pressure models require gas constant information to be defined."+...
                    " Use "+inputname(1)+".specific_gas_constant = (number) or "...
                    +inputname(1)+".molecular_weight = (number).");
            end
            pressureEquation = getPorD(model,temperatureEquation,"Pressure");
        end

        function densityEquation = getDensity(model,temperatureEquation)
            % Since the equations for pressure and density are very
            % similar, the actual math has been placed inside a single
            % function, and this function serves as a proxy to run that
            % function and pass a parameter to ensure density calculations
            % are done (using surface density).

            % error handling if gravity, gas constants, and surface
            % density aren't defined yet.
            if(model.gravitational_constant == -1 || model.surface_density == -1)
                error("Density models require a gravitation constant and surface density to be defined. "+...
                    "Use "+inputname(1)+".gravitational_constant = (number) and/or "+...
                    inputname(1)+".surface_density = (number).");
            elseif(model.specific_gas_constant == -1 && model.molecular_weight == -1)
                error("Density models require gas constant information to be defined."+...
                    " Use "+inputname(1)+".specific_gas_constant = (number) or "...
                    +inputname(1)+".molecular_weight = (number).");
            end
            densityEquation = getPorD(model,temperatureEquation,"Density");
        end

        function soundEquation = getSound(model,temperatureEquation)
            % Uses equations from Anderson to compute the speed of sound at
            % different alittudes. Uses the temperature piecewise found
            % from the temperature function. 

            % Error handling if gravity and specific heats ratio isn't
            % defined yet.
            if(model.specific_heats_ratio == -1)
                error("Speed of sound models require molecular weight and specific heats ratio to be defined. "+...
                    "Use "+inputname(1)+".specific_heats_ratio = (number) and "+...
                    "Use "+inputname(1)+".molecular_weight = (number).");
            end

            syms soundEquation(h);
            if(model.molecular_weight ~= -1)
                model.specific_gas_constant = model.universal_gas_constant / model.molecular_weight;
            end
            soundEquation(h) = sqrt(model.specific_heats_ratio*model.specific_gas_constant...
                *temperatureEquation);
 
            clear temps heights;
        end

        function quantityEquation = getPorD(model,temperatureEquation,quantity)
            % Main function that calculates the piecewise equations for
            % pressure and density. Uses equations from Andersion for these
            % calculations. The proxy functions above do the error
            % handling, so none is required here. 

            if(model.molecular_weight ~= -1)
                model.specific_gas_constant = model.universal_gas_constant / model.molecular_weight;
            end
            syms quantityEquation(h)
            quantityEquation(h) = 0;
            temps = model.heights_temperatures(:,2);
            heights = model.heights_temperatures(:,1);

            for region = 1:(height(temps)-1)
                if(region == 1)
                    if(quantity=="Pressure")
                        quantityInitial = model.surface_pressure;
                    else
                        quantityInitial = model.surface_density;
                    end
                else
                    quantityInitial = quantityEquation(heights(region));
                end
                
                if(abs(model.lapse_rates(region)) < 1e-4)
                    isothermal_change = exp(-(model.gravitational_constant/(model.specific_gas_constant*temperatureEquation))*(h - heights(region)));
                    quantityRegion = quantityInitial * isothermal_change;
                else
                    expConstant = model.gravitational_constant/(model.lapse_rates(region)*model.specific_gas_constant);
                    if(quantity=="Density")
                        expConstant = expConstant+1;
                    end
                    quantityRegion = quantityInitial * (temperatureEquation/temps(region))^-(expConstant);
                end
                
                quantityEquation(h) = piecewise(heights(region) <= h <= heights(region+1),...
                    quantityRegion, quantityEquation);
         
            end          
            clear temps heights quantityInitial quantityRegion expConstant isothermal_change;
        end  

        function plotEqn(model,eqn,range)
            subplot(2,2,1);
            fplot(eqn,range);
            view([90 -90]);
            grid on
            ylabel("Temperature (K)");
            xlabel("Altitude (m)");
            title("Temperature vs. Altitude");

        end
    end
end