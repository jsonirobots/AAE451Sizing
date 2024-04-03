function inputs = AircraftParameters()
%% PERFORMANCE PARAMETERS

PerformanceInputs.TW   = 0.234;                                % thrust-to-weight ratio
PerformanceInputs.WS   = 840000/6200;                         % wing loading [lbs/ft^2]
PerformanceInputs.V    = 430;                                 % cruise velocity [knots]
PerformanceInputs.M    = 0.78;                                % cruise velocity [Mach]. This needs to be changed to match V at desired altitude.  Can automate this calculation with the AtmosphereFunction
PerformanceInputs.Vlt  = 266.985;                                 % loiter velocity [knots]
PerformanceInputs.nmax = 1;                                   % maximum load factor
PerformanceInputs.hc   = 31000;                               % cruise altitude [ft]
PerformanceInputs.hlt  = 25000;                               % loiter altitude [ft]

%% GEOMETRY PARAMETERS
GeometryInputs.AR          = 8.6;            % wing aspect ratio
GeometryInputs.WingSweep   = 32.5;           % wing sweep (LE) [deg]
GeometryInputs.thick2chord = 0.3967;         % wing thickness-to-chord ratio
GeometryInputs.TR          = 0.4286;          % wing taper ratio
GeometryInputs.Cht         = 1.00;         % Horizontal-tail volume coefficient (based on Raymer Ch.6 Table 6.4)
GeometryInputs.Cvt         = 0.08;         % Vertical-tail volume coefficient (based on Raymer Ch.6 Table 6.4)
GeometryInputs.H_loc       = 0.45;         % Location of H-tail as a fraction of fuselage length
GeometryInputs.H_loc       = 0.45;         % Location of V-tail as a fraction of fuselage length
GeometryInputs.le          = 212.6/12;       % engine length [ft]
GeometryInputs.de          = 115.6/12;     % engine diameter [ft]

%% CONFIGURATION PARAMETERS
LayoutInputs.lf = 275+7/12;                      % length of fuselage [ft]
LayoutInputs.df = 26;                     % diameter of fuselage [ft]

%% AERODYNAMIC PARAMETERS
AeroInputs.Clmax   = 1.2;                  % maximum lift coefficient

%% PROPULSION PARAMETERS
PropulsionInputs.num_eng    = 6;           % number of engines
PropulsionInputs.C          = 0.5;         % Jet specific fuel consumption [1/hr] 
PropulsionInputs.lapse      = 0.25;           % lapse rate of engines at cruise

inputs.PerformanceInputs = PerformanceInputs;
inputs.GeometryInputs    = GeometryInputs;
inputs.LayoutInputs      = LayoutInputs;
inputs.AeroInputs        = AeroInputs;
inputs.PropulsionInputs  = PropulsionInputs;
