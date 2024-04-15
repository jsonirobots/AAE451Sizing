function inputs = AircraftParameters()
%% PERFORMANCE PARAMETERS

PerformanceInputs.TW          = 0.35;                                           % thrust-to-weight ratio
PerformanceInputs.WS          = 145;                                            % wing loading [lbs/ft^2]
PerformanceInputs.V           = 433.391;                                        % cruise velocity [knots]
PerformanceInputs.M           = 0.8;                                            % cruise velocity [Mach]. This needs to be changed to match V at desired altitude.  Can automate this calculation with the AtmosphereFunction
PerformanceInputs.Mmax        = 0.82;                                           % maximum mach speed [Mach]
PerformanceInputs.Vlt         = 266.985;                                        % loiter velocity [knots]
PerformanceInputs.nmax        = 3;                                              % maximum load factor
PerformanceInputs.nmin        = -1.5;                                           % minimum load factor
PerformanceInputs.hc          = 31000;                                          % cruise altitude [ft]
PerformanceInputs.hlt         = 25000;                                          % loiter altitude [ft]
PerformanceInputs.climbAngle  = 2;                                              % climb angle [degrees]
PerformanceInputs.fieldLength = 9000;                                           % field length [ft]

%% GEOMETRY PARAMETERS
GeometryInputs.b              = 262;                                            % wing aspect ratio
GeometryInputs.WingSweep      = 32.5;                                           % wing sweep (LE) [deg]
GeometryInputs.thick2chord    = 0.3967;                                         % wing thickness-to-chord ratio
GeometryInputs.TR             = 0.4286;                                         % wing taper ratio
GeometryInputs.Cht            = 1.00;                                           % Horizontal-tail volume coefficient (based on Raymer Ch.6 Table 6.4)
GeometryInputs.Cvt            = 0.08;                                           % Vertical-tail volume coefficient (based on Raymer Ch.6 Table 6.4)
GeometryInputs.H_loc          = 0.45;                                           % Location of H-tail as a fraction of fuselage length
GeometryInputs.H_loc          = 0.45;                                           % Location of V-tail as a fraction of fuselage length
GeometryInputs.le             = 224/12;                                         % engine length [ft]
GeometryInputs.de             = 163.7/12;                                       % engine diameter [ft]

%% CONFIGURATION PARAMETERS
LayoutInputs.lf               = 250;                                            % length of fuselage [ft]
LayoutInputs.df               = 26;                                             % diameter of fuselage [ft]

%% AERODYNAMIC PARAMETERS
AeroInputs.CLmax              = 2.8;                                            % maximum lift coefficient
AeroInputs.CLmaxcruise        = 1.5;                                            % maximum lift coefficient at cruise configuration
AeroInputs.CLmin              = -1;                                             % minimum lift coefficient
AeroInputs.CLalpha            = 2*pi;                                           % lift coefficient slope [1/rad]

%% PROPULSION PARAMETERS
PropulsionInputs.num_eng      = 6;                                              % number of engines
PropulsionInputs.C            = 0.5;                                            % Jet specific fuel consumption [1/hr] 
PropulsionInputs.lapse        = 0.25;                                           % lapse rate of engines at cruise

%% PAYLOAD PARAMETERS
PayloadInputs.crewnum         = 8;                                              % number of crew members (pilots)
PayloadInputs.paxweight       = 200;                                            % passenger weight (including luggage) [lbs]
PayloadInputs.crewweight      = 300;                                            % crew member weight (including luggage) [lbs]
PayloadInputs.crewpayload     = PayloadInputs.crewweight*PayloadInputs.crewnum; % weight of crew members [lbs]

%% DESIGN MISSION PARAMETERS
Missions.Design.R             = 2500;                                           % aircraft range [nmi]
Missions.Design.loiter_time   = 0.5;                                            % loiter time [hours]
Missions.Design.pax           = 0;                                              % number of passengers   
Missions.Design.loadweight    = 430000;                                         % weight of load carried in mission
Missions.Design.paxpayload    = PayloadInputs.paxweight.*Missions.Design.pax;   % weight of passengers (including luggage) [lbs]
Missions.Design.w_payload     = PayloadInputs.crewweight + Missions.Design.paxpayload + Missions.Design.loadweight;

%% MEDIUM PAYLOAD MISSION PARAMETERS
Missions.Medium.R             = 5000 ;                                          % aircraft range [nmi]
Missions.Medium.loiter_time   = 0.5;                                            % loiter time [hours]
Missions.Medium.pax           = 0;                                              % number of passengers   
Missions.Medium.loadweight    = 295000;                                         % weight of load carried in mission
Missions.Medium.paxpayload    = PayloadInputs.paxweight.*Missions.Medium.pax;   % weight of passengers (including luggage) [lbs]
Missions.Medium.w_payload     = PayloadInputs.crewweight + Missions.Medium.paxpayload + Missions.Medium.loadweight;

%% FERRY MISSION PARAMETERS
Missions.Ferry.R              = 8000;                                           % aircraft range [nmi]
Missions.Ferry.loiter_time    = 0.5;                                            % loiter time [hours]
Missions.Ferry.pax            = 0;                                              % number of passengers   
Missions.Ferry.loadweight     = 0;                                              % weight of load carried in mission
Missions.Ferry.paxpayload     = PayloadInputs.paxweight.*Missions.Ferry.pax;    % weight of passengers (including luggage) [lbs]
Missions.Ferry.w_payload      = PayloadInputs.crewweight + Missions.Ferry.paxpayload + Missions.Ferry.loadweight;

inputs.PerformanceInputs      = PerformanceInputs;
inputs.GeometryInputs         = GeometryInputs;
inputs.LayoutInputs           = LayoutInputs;
inputs.AeroInputs             = AeroInputs;
inputs.PropulsionInputs       = PropulsionInputs;
inputs.Missions               = Missions;
inputs.PayloadInputs          = PayloadInputs;
