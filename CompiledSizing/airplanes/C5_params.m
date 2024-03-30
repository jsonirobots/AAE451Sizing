%% aircraft description: C-5
c5.planeName = "C-5";

% missions' design parameters
c5.payloads = [281e3 120e3 0]; % lb, payload vector
c5.ranges = [2.3e3 4.8e3 7e3]; % nmi, range vector
c5.paxNums = [0 0 0]; % number of passengers

% known design weights (applies to existing aircraft only)
c5.knownWs = [840e3 380e3 341446]; % MTOW, We, max Wf

% crew and passenger parameters
c5.crewW_ea = 300; % lb, weight of each crew member
c5.crewNum = 4; % number of crew members
c5.crewW = c5.crewW_ea*c5.crewNum; % lb, total crew weight

c5.paxW_ea = 250; % lb, weight of each passenger

% performance parameters
c5.TWR = 0.26; % lbf/lb, thrust to weight ratio
c5.Mmax = 0.79; % max mach number

% aerodynamic data
c5.S = 6200; % ft^2, wing area
c5.span = 222+9/12; % ft, wingspan
c5.AR = c5.span^2/c5.S; % aspect ratio
c5.WS = 840e3/c5.S; % lb/ft^2, wing loading
c5.lambdaLE = deg2rad(32); % rad
c5.Swet = c5.S*4.5; % ft^2

% cruise parameters
c5.cruiseC = 0.5; % lb/lbf/hr, TSFC cruise
c5.cruiseV = 443.66; % kts, cruise speed
c5.cruiseAltitude = 35e3; % ft

% loiter parameters
c5.loiterT = 0.75; % hr
c5.loiterC = 0.35; % lb/lbf/hr, TSFC loiter
c5.loiterV = 335.8; % kts, loiter speed
c5.loiterAltitude = 10e3; % ft

