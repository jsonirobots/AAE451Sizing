% checkAn file has Swet related parameters, update other aircraft files
function [output,plane] = sizeAirplane(plane,W0_guess,printOutput)
%% preallocation of vectors/matrices
    %tic;
    %f = waitbar(0,"Sizing Plane");
    ranges = plane.ranges;
    payloads = plane.payloads;

    % pre-allocating output vectors
    W0s = zeros(numel(ranges),1);
    Wfs = W0s;
    Wfs_cruise = W0s;
    Wfracs = zeros(numel(ranges),7); % 7 is mission segments - 1, change if needed
    Rs = zeros(numel(ranges),1);

    errorTol = 1e-2;
    maxiters = 1e3;

    % this loop first sizes the aircraft for each mission, then determines
    % the heaviest TOW case, and constrains that as the aircraft.
    % Subsequent iterations use that aircraft MTOW to estimate max range
    % for each mission and improve the MTOW estimate. 6 iterations
    % currently converges MTOW to within 1 lb among all the missions. 
    for k=1:6 
       
        if(printOutput && k==1)
            fprintf("================\nRunning sizePlane for "+plane.planeName+" .......\n\n");
            fprintf("Payload | Range |   W0    |   We   |   Wf\n");
            fprintf("  (lbs) | (nmi) |  (lbs)  |  (lbs) |  (lbs)\n");
            fprintf("--------|-------|---------|--------|--------\n");
        end
    
        % iteration through max payload case gives an accurate empty weight,
        % then this weight must be used for any other mission profiles.
        % Aircraft parameter files have max payload case first, so j=1 iterates
        % the empty weight, and afterwards the We is fixed.
        for j=1:numel(ranges) % go through each payload/range profile
            paxNum = plane.paxNums(j);
    
            segments = 8; % num of mission segments + 1 for takeoff weight
            W = zeros(segments,1); % vector of aircraft weights
            F = zeros(segments,1); % vector of fuel weights
            %Wfrac = zeros(segments-1,1); % vector of weight fractions
            error = 10; % initialize error variable

%% Calculation parameters that don't change with mission
            % for first sizing iteration, define some aircraft parameters
            if(k==1)
                W(1) = W0_guess;
                % loads density and speed of sound function, altitude is the parameter
                if(~isfield(plane,'densityFunc') || ~isfield(plane,'soundFunc'))
                    [plane.densityFunc,plane.soundFunc] = getAtmos(); % sl/ft^3 and kts
                end
        
                % only need user to define cruise velocity plane kts or as a mach
                % number. the other one will be calculated using cruise altitude
                if(isfield(plane,'cruiseV') && ~isfield(plane,'cruiseM'))
                    %plane.cruiseM = plane.cruiseV / eval(subs(plane.soundFunc,ftTOm(plane.cruiseAltitude)));
                    plane.cruiseM = plane.cruiseV / plane.soundFunc(ftTOm(plane.cruiseAltitude));
                    if(plane.cruiseM > plane.Mmax)
                        warning("Specified cruise V/altitude is higher than max mach!");
                        %plane.cruiseV = plane.Mmax * eval(subs(plane.soundFunc,ftTOm(plane.cruiseAltitude)));
                        plane.cruiseV = plane.Mmax * plane.soundFunc(ftTOm(plane.cruiseAltitude));
                        plane.cruiseM = plane.Mmax;
                    end
                elseif(isfield(plane,'cruiseM') && ~isfield(plane,'cruiseV'))
                    %plane.cruiseV = plane.cruiseM * eval(subs(plane.soundFunc,ftTOm(plane.cruiseAltitude)));
                    plane.cruiseV = plane.cruiseM * plane.soundFunc(ftTOm(plane.cruiseAltitude));
                end
                
                WeW0_consts = [0.32 0.66 -0.13 0.3 0.06 -0.05 0.05]; % Raymer Table 6.1
            else % improving MTOW iterations
                W(1) = plane.W0max;           
            end
            plane = airplaneGeometery(plane,W(1)); % this function gets Swet and other info

            % Oswald efficiency factor for swept wings (Raymer eqn. 12.49)
            % lambdaLE is the sweep angle of the wing's LE relative to straight wing
            %plane.e = 4.61*(1-0.045*plane.AR^0.68)*(cosd(plane.lambdaLE))^0.15 - 3.1;
            %if(plane.lambdaLE <= 30)        
                e1 = 1.78*(1-0.045*plane.wing.AR^0.68) - 0.64; 
                plane.e=e1;
                %plane.e = interp1([0,30],[e1,plane.e],plane.lambdaLE);
            %end

            plane.Cd0 = 0.0035*plane.Swet/plane.wing.S; % Parasitic Drag Coeff, Raymer Table 12.3
            W0_old = W(1);
            iters = 1;
            Wfrac = [0.995 1.0065-.0325*plane.cruiseM 1 1 0.995 1 1];
  
%% Sizing iteration to find W0
            % main sizing iteration
            while(error > errorTol && iters < maxiters)    
                if(j==1)
                    WeW0 = emptyWeightFrac(WeW0_consts,W(1),plane);
                    We = WeW0*W(1);
                end           
                for i=2:segments
                    if(i==4)
                        if(k==1) % for sizing, find cruise weight fraction
                            [Wfrac(i-1),plane] = iterCruise(plane,W(i-1),ranges(j));
                        else % for improving MTOW, find max cruise range
                            Wfrac(i-1) = (W(i-1) - Wfs_cruise(j))/W(i-1);
                            Rj = iterCruise2(plane,W(i-1),Wfs_cruise(j));
                        end
                    elseif(i==5)
                        Wfrac(i-1) = loiter(plane,W(i-1)); % 
                    end
                            
                    W(i) = Wfrac(i-1)*W(i-1); % weight at end of segment
                    F(i) = W(i-1) - W(i); % weight of fuel used plane segment
                end  
                Fsum = 1.01*sum(F); % includes 1% trapped fuel
                W(1) = We + Fsum + payloads(j) + plane.crewW + plane.paxW_ea*paxNum;
                error = abs(W0_old - W(1));
                W0_old = W(1);
                iters=iters+1;  
            end
            %waitbar(j/numel(ranges),f,"Sizing Plane");
       
            if(printOutput)
                if(k~=1)
                    ranges(j) = Rj;
                end
                fprintf("%7.0f | %5.0f | %7.0f | %6.0f | %6.0f\n",payloads(j),ranges(j),W(1),We,Fsum);
            end
            W0s(j) = W(1);
            Wfs(j) = Fsum;
            Wfs_cruise(j) = F(4);
       
            Wfracs(j,:) = Wfrac;
            if(k~=1)
                Rs(j) = Rj;
            end
        end
        
        % for real planes with known weight data, we can compute and print
        % error values to verify the sizing tool's accuracy.
        if(isfield(plane,'knownWs'))
            W0err = (max(W0s)-plane.knownWs(1))/plane.knownWs(1)*100;
            Weerr = (We-plane.knownWs(2))/plane.knownWs(2)*100;
            Wferr = (max(Wfs)-plane.knownWs(3))/plane.knownWs(3)*100;
            if(printOutput)
                fprintf("\nError percents for real aircraft:\n");
                fprintf("W0: %2.2f%%, We: %2.2f%%, Wf: %2.2f%%\n",W0err,Weerr,Wferr);
            end
        end
        
        plane.W0max = max(W0s);
        plane.Wfmax = max(Wfs);
        plane.We = We;
        % max Wf_cruise is equal to leftover W0 + minimum cruise Wf
        Wfs_cruise = plane.W0max - W0s + Wfs_cruise;
        
    end

%% output data
    output.W0s = W0s;
    output.Wfs = Wfs;
    output.Wfracs = Wfracs;
    output.Rs = Rs;

    %close(f);
    %toc;
end

%% cruise functions, first one finds weight fraction, second one finds range
% cruise function, divides cruise into segments to find weight fraction
function [Wfrac_cruise,plane] = iterCruise(plane,Wstart,range)    
    brange = @(plane,R,LD) exp(-R*plane.cruiseC/plane.cruiseV/LD); % breguet range eqn, Raymer 6.11 
    %rho_cruise = eval(subs(plane.densityFunc,ftTOm(plane.cruiseAltitude)));
    rho_cruise = plane.densityFunc(ftTOm(plane.cruiseAltitude));
    qcruise = 0.5*rho_cruise*ktsTOfts(plane.cruiseV)^2;

    iters = 5; % this number can have a small effect on results
    Rseg = round(range/iters);
    Wseg = Wstart;
    for i=1:iters
        LDrat = LDcalc(plane,Wseg,qcruise,1); % don't need Cd value other than start of cruise
        
        Wrat = brange(plane,Rseg,LDrat); % gives end of segment to start weight ratio
        Wseg = Wrat*Wseg;
    end
    Wfrac_cruise = Wseg/Wstart;
    plane.cruiseq = qcruise;
end

% cruise function, divides cruise into segments to find total range
function Rcruise = iterCruise2(plane,Wstart,Wf_cruise)    
    brange = @(plane,Wfrac,LD) -log(Wfrac)/plane.cruiseC*plane.cruiseV*LD; % breguet range eqn, Raymer 6.11 
    %rho_cruise = eval(subs(plane.densityFunc,ftTOm(plane.cruiseAltitude)));
    %rho_cruise = plane.densityFunc(ftTOm(plane.cruiseAltitude));
    %qcruise = 0.5*rho_cruise*ktsTOfts(plane.cruiseV)^2;
    qcruise = plane.cruiseq;

    iters = 5; % this number can have a small effect on results
    Fseg = round(Wf_cruise/iters);
    Wseg = Wstart;
    Rseg = 0;
    for i=1:iters
        Wend = Wseg - Fseg;
        Wfrac = Wend/Wseg;
        %[LDrat,CD] = LDcalc(plane,Wseg,qcruise,1); % don't need Cd value other than start of cruise
        LDrat = LDcalc(plane,Wseg,qcruise,1);
        %if(i==1)
        %    plane.cruiseCD = CD;
        %end
        Rseg = Rseg + brange(plane,Wfrac,LDrat); % gives end of segment to start weight ratio
        Wseg = Wend;
    end
    Rcruise = Rseg;
end

%% loiter funuction
% loiter function, uses endurance eqn to find weight fraction
function Wfrac_loiter = loiter(plane,Wstart)
    %rho_loiter = eval(subs(plane.densityFunc,ftTOm(plane.loiterAltitude)));
    rho_loiter = plane.densityFunc(ftTOm(plane.loiterAltitude));
    q_loiter = 0.5*rho_loiter*ktsTOfts(plane.loiterV)^2;
    LDrat = LDcalc(plane,Wstart,q_loiter,1); % n = 1, level flight loiter

    Wfrac_loiter = exp(-plane.loiterT*plane.loiterC/LDrat); % endurance eqn, Raymer 6.14s
end

%% L/D function, used by cruise and loiter functions
% L/D ratio equation (Raymer 6.13), Wp is aircraft weight at beginning
% of current mission phase. "n" specifies level flight vs. turning/descent.
function [LDrat,CD] = LDcalc(plane,Wseg,q,n)
    WS = n*Wseg/plane.wing.S; % wing loading at start of current segment
    LDrat = (q*plane.Cd0/WS + WS/(q*pi*plane.wing.AR*plane.e))^-1;
   
    if nargout > 1
        CL = WS/q; % L = W*n, L = q*S*Cl => Cl = W*n/(q*S)
        CD = 1/LDrat * CL; % Cd = Cd/Cl * Cl
    end
end

%% Empty weight function, used by main sizing iteration
% empty weight fraction equation
function WeW0 = emptyWeightFrac(C,W0,plane)
WeW0 = C(1) + C(2)*W0^C(3) * plane.wing.AR^C(4) * plane.TWR^C(5) * ...
    plane.wing.WS^C(6) * plane.Mmax^C(7);
end

%% Conversion functions
% knots to ft/s conversion
function fts = ktsTOfts(kts)
    fts = 1.68781*kts;
end

% ft to m conversion
function m = ftTOm(ft)
 m = ft/3.28084;
end

%% Atmosphere function
% 1976 US Standard Atmosphere, outputs density and speed of sound function
% for more information, check AtmosphereModel file. This is a MATLAB class
% that can create functions with altitude as a parameter for temperature,
% pressure, density, and speed of sound. 
function [densityFunc,soundFunc] = getAtmos()
    % % temperature-altitude matrix. can be modified for ISA + x models
    % earthHT = [ [0 288.16] ; [11e3 216.78] ; [25e3 216.66] ; [47.4e3 282.66] ];
    % earth = AtmosphereModel(earthHT);
    % 
    % % starting constants
    % earth.surface_pressure = 1.01325e5; % Pa
    % earth.surface_density = 1.225; % kg/m^3
    % earth.gravitational_constant = 9.81; % m/s^2
    % earth.molecular_weight = 28.96e-3; % kg/mol
    % earth.specific_heats_ratio = 1.4;
    % 
    % earthTemp = earth.getTemperature(); % K
    % densityFunc = earth.getDensity(earthTemp)/515.379; % kg/m^3 to sl/ft^3
    % soundFunc = earth.getSound(earthTemp)*1.94384; % m/s to kts
    soundFunc = @(h) (12149*(3183751382132949581/27487790694400 - (6612703287653824726340819684193*h)/2535301200456458802993406410752)^(1/2))/6250;
    densityFunc = @(h) (53876069761024*(1 - (93517655680496325*h)/4152823259593862807552)^(1200658649957655/281474976710656))/22666608128462685;
end

%% Airplane Geometry Function
function plane = airplaneGeometery(plane,W0)
    Swet_aero = @(S) 2*1.02*S;

    plane.wing.S = W0/plane.wing.WS; % ft^2, wing planform area
    %plane.wing.b = sqrt(plane.wing.S * plane.wing.AR); % ft, wingspan
    plane.wing.AR = plane.wing.b^2 / plane.wing.S;
    plane.wing.MAC = ((1+plane.wing.TR+(plane.wing.TR^2))/(1+plane.wing.TR)^2)*...
        (plane.wing.S/plane.wing.b)*(4/3); % ft, mean aero chord of wing
    plane.wing.Swet = Swet_aero(plane.wing.S);

    finrat = plane.fuselage.length/plane.fuselage.dia; % fineness ratio
    plane.fuselage.Swet = pi*plane.fuselage.dia*plane.fuselage.length*...
        (1-2/finrat)^(2/3)*(1+1/finrat^2); % ft^2, fuselage wetted area

    Lht = plane.htail.loc*plane.fuselage.length; % ft, H-tail moment arm 
    plane.htail.S = plane.htail.C*plane.wing.MAC*plane.wing.S/Lht; % ft^2, H-tail surface area
    plane.htail.Swet = Swet_aero(plane.htail.S); % ft^2, H-tail wetted area

    Lvt = plane.vtail.loc*plane.fuselage.length; % ft, V-tail moment arm (for engines on wing)  
    plane.vtail.S = plane.vtail.C*plane.wing.b*plane.wing.S/Lvt; % ft^2, V-tail surface area 
    plane.vtail.Swet = Swet_aero(plane.vtail.S); % ft^2, V-tail wetted area         

    % for non after burning jet engines  (M < 2.5)
    % T/W0 * W0 = T (total)
    T_perengine = (plane.TWR * W0)/plane.engines.num; % lbf, thrust per engine
    plane.engines.len = 0.185 * T_perengine^0.4 * plane.cruiseM^0.2; % ft, length of engine
    plane.engines.dia = 0.033 * T_perengine^0.5 * exp(0.04 * plane.engines.BPR);% ft, dia of engine
      
    plane.engines.Swet = pi*plane.engines.dia*plane.engines.len*plane.engines.num; % ft^2, wetted area of engines

    plane.Swet = plane.wing.Swet + plane.fuselage.Swet + plane.htail.Swet + plane.vtail.Swet + plane.engines.Swet;
end
