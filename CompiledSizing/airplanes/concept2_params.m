%% aircraft description: An-225
con2.planeName = "Concept 2";

% missions' design parameters (must have max payload case first)
con2.payloads = [430e3 295e3 0]; % lb, payload vector
con2.ranges = [2.5e3 5e3 8e3]; % nmi, range vector
con2.paxNums = [0 0 0]; % number of passengers

% known design weights (applies to existing aircraft only)
%con2.knownWs = [1410958 628317 660e3]; % MTOW, We, max Wf

% crew and passenger parameters
con2.crewW_ea = 300; % lb, weight of each crew member
con2.crewNum = 4; % number of crew members
con2.crewW = con2.crewW_ea*con2.crewNum; % lb, total crew weight

con2.paxW_ea = 250; % lb, weight of each passenger

% performance parameters
con2.TWR = 0.33; % lbf/lb, thrust to weight ratio
con2.Mmax = 0.82; % max mach number
con2.serviceCeiling = 36e3; % ft, required service ceiling (climb rate = 100 ft/min)
con2.engine_alpha = 47.7/229.8; % lapse rate for engine = T/T_sl

% aerodynamic data
con2.span = 254; % ft, wingspan
con2.AR = 5.5; % aspect ratio
con2.S = con2.span^2/con2.AR; % ft^2, wing area
con2.WS = 103; % lb/ft^2, wing loading
con2.lambdaLE = 32; % deg, leading edge sweep angle
con2.Swet = con2.S*5.4; % ft^2

% cruise parameters
con2.cruiseC = 0.43; % lb/lbf/hr, TSFC cruise
con2.cruiseV = 450; % kts, cruise speed
con2.cruiseAltitude = 30e3; % ft

% loiter parameters
con2.loiterT = 0.75; % hr
con2.loiterC = 0.31; % lb/lbf/hr, TSFC loiter
con2.loiterV = 250; % kts, loiter speed
con2.loiterAltitude = 16e3; % ft