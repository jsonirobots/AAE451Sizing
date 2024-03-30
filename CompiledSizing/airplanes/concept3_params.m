%% aircraft description: An-225
con3.planeName = "Concept 3";

% missions' design parameters (must have max payload case first)
con3.payloads = [430e3 295e3 0]; % lb, payload vector
con3.ranges = [2.5e3 5e3 8e3]; % nmi, range vector
con3.paxNums = [0 0 0]; % number of passengers

% known design weights (applies to existing aircraft only)
%con3.knownWs = [1410958 628317 660e3]; % MTOW, We, max Wf

% crew and passenger parameters
con3.crewW_ea = 300; % lb, weight of each crew member
con3.crewNum = 4; % number of crew members
con3.crewW = con3.crewW_ea*con3.crewNum; % lb, total crew weight

con3.paxW_ea = 250; % lb, weight of each passenger

% performance parameters
con3.TWR = 0.3; % lbf/lb, thrust to weight ratio
con3.Mmax = 0.82; % max mach number
con3.serviceCeiling = 36e3; % ft, required service ceiling (climb rate = 100 ft/min)
con3.engine_alpha = 47.7/229.8; % lapse rate for engine = T/T_sl

% aerodynamic data
con3.span = 261; % ft, wingspan
con3.AR = 6.5; % aspect ratio
con3.S = con3.span^2/con3.AR; % ft^2, wing area
con3.WS = 115; % lb/ft^2, wing loading
con3.lambdaLE = 32; % deg, leading edge sweep angle
con3.Swet = con3.S*5.4; % ft^2

% cruise parameters
con3.cruiseC = 0.43; % lb/lbf/hr, TSFC cruise
con3.cruiseV = 450; % kts, cruise speed
con3.cruiseAltitude = 30e3; % ft

% loiter parameters
con3.loiterT = 0.75; % hr
con3.loiterC = 0.31; % lb/lbf/hr, TSFC loiter
con3.loiterV = 250; % kts, loiter speed
con3.loiterAltitude = 16e3; % ft