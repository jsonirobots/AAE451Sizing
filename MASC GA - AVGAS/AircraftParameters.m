function inputs = AircraftParameters()
%% PERFORMANCE PARAMETERS

PerformanceInputs.TW   = 0.26;                                % thrust-to-weight ratio
PerformanceInputs.WS   = 840000/6200;                         % wing loading [lbs/ft^2]
PerformanceInputs.V    = 450;                                 % cruise velocity [knots]
PerformanceInputs.M    = 0.77;                                % cruise velocity [Mach]. This needs to be changed to match V at desired altitude.  Can automate this calculation with the AtmosphereFunction
PerformanceInputs.Vlt  = 300;                                 % loiter velocity [knots]
PerformanceInputs.nmax = 2;                                   % maximum load factor
PerformanceInputs.hc   = 33000;                               % cruise altitude [ft]
PerformanceInputs.hlt  = 10000;                               % loiter altitude [ft]

%% GEOMETRY PARAMETERS
GeometryInputs.AR          = 8;            % wing aspect ratio
GeometryInputs.WingSweep   = 25;           % wing sweep (LE) [deg]
GeometryInputs.thick2chord = 0.15;         % wing thickness-to-chord ratio
GeometryInputs.TR          = 0.3;          % wing taper ratio
GeometryInputs.Cht         = 1.00;         % Horizontal-tail volume coefficient (based on Raymer Ch.6 Table 6.4)
GeometryInputs.Cvt         = 0.08;         % Vertical-tail volume coefficient (based on Raymer Ch.6 Table 6.4)
GeometryInputs.H_loc       = 0.45;         % Location of H-tail as a fraction of fuselage length
GeometryInputs.H_loc       = 0.45;         % Location of H-tail as a fraction of fuselage length
GeometryInputs.le          = 224/12;       % engine length [ft]
GeometryInputs.de          = 163.7/12;     % engine diameter [ft]

%% CONFIGURATION PARAMETERS
LayoutInputs.lf = 55;                      % length of fuselage [ft]
LayoutInputs.df = 5.9;                     % diameter of fuselage [ft]

%% AERODYNAMIC PARAMETERS
AeroInputs.Clmax   = 1.6;                  % maximum lift coefficient

%% PROPULSION PARAMETERS
PropulsionInputs.num_eng    = 4;           % number of engines
PropulsionInputs.C          = 0.5;         % Jet specific fuel consumption [1/hr] 
PropulsionInputs.lapse      = 1;           % lapse rate of engines at cruise

inputs.PerformanceInputs = PerformanceInputs;
inputs.GeometryInputs    = GeometryInputs;
inputs.LayoutInputs      = LayoutInputs;
inputs.AeroInputs        = AeroInputs;
inputs.PropulsionInputs  = PropulsionInputs;
