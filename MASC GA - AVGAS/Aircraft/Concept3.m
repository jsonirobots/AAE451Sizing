function inputs = AircraftParameters()
%% PERFORMANCE PARAMETERS

PerformanceInputs.TW         = 0.35;     % thrust-to-weight ratio
PerformanceInputs.WS         = 145;      % wing loading [lbs/ft^2]
PerformanceInputs.V          = 433.391;  % cruise velocity [knots]
PerformanceInputs.M          = 0.8;      % cruise velocity [Mach]. This needs to be changed to match V at desired altitude.  Can automate this calculation with the AtmosphereFunction
PerformanceInputs.Mmax       = 0.82;     % maximum mach speed [Mach]
PerformanceInputs.Vlt        = 266.985;  % loiter velocity [knots]
PerformanceInputs.nmax       = 3;        % maximum load factor
PerformanceInputs.nmin       = -1.5;     % minimum load factor
PerformanceInputs.hc         = 31000;    % cruise altitude [ft]
PerformanceInputs.hlt        = 25000;    % loiter altitude [ft]
PerformanceInputs.climbAngle = 2;

%% GEOMETRY PARAMETERS
GeometryInputs.b             = 262;      % wing aspect ratio
GeometryInputs.WingSweep     = 32.5;     % wing sweep (LE) [deg]
GeometryInputs.thick2chord   = 0.3967;   % wing thickness-to-chord ratio
GeometryInputs.TR            = 0.4286;   % wing taper ratio
GeometryInputs.Cht           = 1.00;     % Horizontal-tail volume coefficient (based on Raymer Ch.6 Table 6.4)
GeometryInputs.Cvt           = 0.08;     % Vertical-tail volume coefficient (based on Raymer Ch.6 Table 6.4)
GeometryInputs.H_loc         = 0.45;     % Location of H-tail as a fraction of fuselage length
GeometryInputs.H_loc         = 0.45;     % Location of V-tail as a fraction of fuselage length
GeometryInputs.le            = 224/12;   % engine length [ft]
GeometryInputs.de            = 163.7/12; % engine diameter [ft]

%% CONFIGURATION PARAMETERS
LayoutInputs.lf              = 250;      % length of fuselage [ft]
LayoutInputs.df              = 26;       % diameter of fuselage [ft]

%% AERODYNAMIC PARAMETERS
AeroInputs.CLmax             = 1.6;      % maximum lift coefficient
AeroInputs.CLmin             = -0.5;     % minimum lift coefficient
AeroInputs.CLalpha           = 2*pi;     % lift coefficient slope [1/rad]

%% PROPULSION PARAMETERS
PropulsionInputs.num_eng   = 6;          % number of engines
PropulsionInputs.C         = 0.5;        % Jet specific fuel consumption [1/hr] 
PropulsionInputs.lapse     = 0.25;       % lapse rate of engines at cruise

inputs.PerformanceInputs   = PerformanceInputs;
inputs.GeometryInputs      = GeometryInputs;
inputs.LayoutInputs        = LayoutInputs;
inputs.AeroInputs          = AeroInputs;
inputs.PropulsionInputs    = PropulsionInputs;
