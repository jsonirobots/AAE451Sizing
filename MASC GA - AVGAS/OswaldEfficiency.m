% Function that estimates the Oswald Efficiency Factor
% Simplest approach presented in Raymer Ch.12 Section 12.6.
% Recommended to modify for more accuracy between different designs.
function e0 = OswaldEfficiency(inputs)

%% Inputs
TR     = inputs.GeometryInputs.TR;               % wing taper ratio
df     = inputs.LayoutInputs.df;                 % fuselage diameter [ft]
AR     = inputs.GeometryOutput.AR;               % wing aspect  ratio
Lambda = inputs.GeometryInputs.WingSweep*pi/180; % wing sweep [rad]
b      = inputs.GeometryInputs.b;                % wing span [ft]
Cdo    = inputs.Aero.Cdo;                        % Parasite drag coefficient

%%
%%
e0unswept = 1.78*(1-0.045.*AR.^0.68)-0.64;
e0sweept = 4.61*(1-0.045.*AR.^0.68)*(cos(Lambda))^0.15-3.1;

if Lambda<0
    fprintf("Value for wing sweep is not supported\n")
elseif Lambda>(pi/6)
    e0 = e0sweept;
else
    e0 = (1-Lambda*6/pi)*e0unswept + Lambda*6/pi*e0sweept;
end

e0=e0unswept;
end
