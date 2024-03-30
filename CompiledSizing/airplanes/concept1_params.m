%% aircraft description: An-225
con1.planeName = "Concept 1";

% missions' design parameters (must have max payload case first)
con1.payloads = [430e3 295e3 0]; % lb, payload vector
con1.ranges = [2.5e3 5e3 8e3]; % nmi, range vector
con1.paxNums = [0 0 0]; % number of passengers

% known design weights (applies to existing aircraft only)
%con1.knownWs = [1410958 628317 660e3]; % MTOW, We, max Wf

% crew and passenger parameters
con1.crewW_ea = 300; % lb, weight of each crew member
con1.crewNum = 4; % number of crew members
con1.crewW = con1.crewW_ea*con1.crewNum; % lb, total crew weight

con1.paxW_ea = 250; % lb, weight of each passenger

% performance parameters
con1.TWR = 0.32; % lbf/lb, thrust to weight ratio
con1.Mmax = 0.82; % max mach number
con1.serviceCeiling = 36e3; % ft, required service ceiling (climb rate = 100 ft/min)
con1.engine_alpha = 47.7/229.8; % lapse rate for engine = T/T_sl

% aerodynamic data
con1.span = 260; % ft, wingspan
con1.AR = 5.7; % aspect ratio
con1.S = con1.span^2/con1.AR; % ft^2, wing area

con1.WS = 102; % lb/ft^2, wing loading
con1.lambdaLE = 32; % deg, leading edge sweep angle
con1.Swet = con1.S*5.4; % ft^2

% cruise parameters
con1.cruiseC = 0.43; % lb/lbf/hr, TSFC cruise
con1.cruiseV = 450; % kts, cruise speed
con1.cruiseAltitude = 30e3; % ft

% loiter parameters
con1.loiterT = 0.75; % hr
con1.loiterC = 0.31; % lb/lbf/hr, TSFC loiter
con1.loiterV = 250; % kts, loiter speed
con1.loiterAltitude = 16e3; % ft