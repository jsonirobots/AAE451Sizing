%% aircraft description: An-124
an124.planeName = "An-124";

% missions' design parameters, max payload must be first
an124.payloads = [330693 176370 88185 0]; % lb, payload vector
an124.ranges = [2e3 4.5e3 6.2e3 7.6e3]; % nmi, range vector
an124.paxNums = [0 0 0 0]; % number of passengers

% known design weights (applies to existing aircraft only)
an124.knownWs = [886258 399037 463343]; % MTOW, We, max Wf

% crew and passenger parameters
an124.crewW_ea = 300; % lb, weight of each crew member
an124.crewNum = 8; % number of crew members
an124.crewW = an124.crewW_ea*an124.crewNum; % lb, total crew weight

an124.paxW_ea = 250; % lb, weight of each passenger

% performance parameters
an124.TWR = 0.23; % lbf/lb, thrust to weight ratio
an124.Mmax = 0.8; % max mach number

% aerodynamic data
an124.S = 6760; % ft^2, wing area
an124.span = 240 + 6/12; % ft, wingspan
an124.AR = an124.span^2/an124.S; % aspect ratio
an124.WS = 886258/an124.S; % lb/ft^2, wing loading
an124.lambdaLE = deg2rad(30); % rad
an124.Swet = an124.S*3.5; % ft^2

% cruise parameters
an124.cruiseC = 0.546; % lb/lbf/hr, TSFC cruise
an124.cruiseV = 460; % kts, cruise speed
an124.cruiseAltitude = 35e3; % ft

% loiter parameters
an124.loiterT = 0.75; % hr
an124.loiterC = 0.5; % lb/lbf/hr, TSFC loiter
an124.loiterV = 300; % kts, loiter speed
an124.loiterAltitude = 11e3; % ft