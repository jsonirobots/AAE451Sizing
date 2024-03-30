%% aircraft description: An-225
an225.planeName = "An-225";

% missions' design parameters (must have max payload case first)
an225.payloads = [440924 220462 0]; % lb, payload vector
an225.ranges = [2429 5283 8.315e3]; % nmi, range vector
an225.paxNums = [0 0 0]; % number of passengers

% known design weights (applies to existing aircraft only)
an225.knownWs = [1410958 628317 661386]; % MTOW, We, max Wf

% crew and passenger parameters
an225.crewW_ea = 300; % lb, weight of each crew member
an225.crewNum = 4; % number of crew members
an225.crewW = an225.crewW_ea*an225.crewNum; % lb, total crew weight

an225.paxW_ea = 250; % lb, weight of each passenger

% performance parameters
an225.TWR = 0.234; % lbf/lb, thrust to weight ratio
an225.Mmax = 0.7983; % max mach number
an225.serviceCeiling = 36e3; % ft, required service ceiling (climb rate = 100 ft/min)
an225.engines.alpha = 47.7/229.8; % lapse rate for engine = T/T_sl
an225.maxRunwayLen = 9e3; % ft

% airplane info (calculated Swet)
an225.wing.WS = 135.8; % lb/ft^2, wing loading
%an225.wing.AR = 6; % wing aspect ratio
an225.wing.b = 290; % ft, wingspan
an225.wing.TR = 0.2; % wing taper ratio
an225.wing.CLmax = 2.8; % maximum lift coefficient
an225.wing.lambdaLE = 32; % deg, leading edge sweep angle
an225.fuselage.length = 270; % ft, fuselage length
an225.fuselage.dia = 30; % ft, fuselage diameter

an225.htail.loc = 0.8547; % location of htail as fraction of fuselage length from nose
an225.vtail.loc = 0.8974; % location of vtail as fraction of fuselage length from nose

an225.htail.C = 1.0; % htail volume coefficient
an225.vtail.C = 0.09; % vtail volume coefficient

% engines info
an225.engines.num = 6;
an225.engines.BPR = 5.7;

% cruise parameters
an225.cruiseC = 0.57; % lb/lbf/hr, TSFC cruise
an225.cruiseV = 458; % kts, cruise speed
an225.cruiseAltitude = 36e3; % ft

% loiter parameters
an225.loiterT = 0.75; % hr
an225.loiterC = 0.35; % lb/lbf/hr, TSFC loiter
an225.loiterV = 250; % kts, loiter speed
an225.loiterAltitude = 16e3; % ft

% aerodynamic data (specified Swet)
% an225.S = 9740; % ft^2, wing area
% an225.span = 290; % ft, wingspan
% an225.AR = an225.span^2/an225.S; % aspect ratio
% an225.WS = an225.knownWs(1)/an225.S; % lb/ft^2, wing loading
% an225.lambdaLE = 32; % deg, leading edge sweep angle
% an225.Swet = an225.S*5; % ft^2