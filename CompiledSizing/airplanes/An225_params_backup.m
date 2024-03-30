%% aircraft description: An-225
an225.planeName = "An-225";

% missions' design parameters (must have max payload case first)
an225.payloads = [440925 0]; % lb, payload vector
an225.ranges = [2159 8.3e3]; % nmi, range vector
an225.paxNums = [0 0]; % number of passengers

% known design weights (applies to existing aircraft only)
an225.knownWs = [1410958 628317 660e3]; % MTOW, We, max Wf

% crew and passenger parameters
an225.crewW_ea = 300; % lb, weight of each crew member
an225.crewNum = 4; % number of crew members
an225.crewW = an225.crewW_ea*an225.crewNum; % lb, total crew weight

an225.paxW_ea = 250; % lb, weight of each passenger

% performance parameters
an225.TWR = 0.234; % lbf/lb, thrust to weight ratio
an225.Mmax = 0.79; % max mach number
an225.serviceCeiling = 36e3; % ft, required service ceiling (climb rate = 100 ft/min)
an225.engine_alpha = 47.7/229.8; % lapse rate for engine = T/T_sl

% aerodynamic data
an225.S = 9740; % ft^2, wing area
an225.span = 290; % ft, wingspan
an225.AR = an225.span^2/an225.S; % aspect ratio
an225.WS = 1410958/an225.S; % lb/ft^2, wing loading
an225.lambdaLE = 32; % deg, leading edge sweep angle
an225.Swet = an225.S*4.4; % ft^2

% cruise parameters
an225.cruiseC = 0.546; % lb/lbf/hr, TSFC cruise
an225.cruiseV = 453; % kts, cruise speed
an225.cruiseAltitude = 30e3; % ft

% loiter parameters
an225.loiterT = 0.75; % hr
an225.loiterC = 0.345; % lb/lbf/hr, TSFC loiter
an225.loiterV = 250; % kts, loiter speed
an225.loiterAltitude = 16e3; % ft