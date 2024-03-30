%% aircraft description: C-17
c17.planeName = "C-17";

% missions' design parameters (must have max payload case first)
c17.payloads = [164900 0]; % lb, payload vector
c17.ranges = [2.4e3 6230]; % nmi, range vector
c17.paxNums = [0 0]; % number of passengers

% known design weights (applies to existing aircraft only)
c17.knownWs = [585e3 282500 238503]; % MTOW, We, max Wf
% Wf for C17 converted from 35546 US Gal to lbs of jet fuel

% crew and passenger parameters
c17.crewW_ea = 300; % lb, weight of each crew member
c17.crewNum = 4; % number of crew members
c17.crewW = c17.crewW_ea*c17.crewNum; % lb, total crew weight

c17.paxW_ea = 250; % lb, weight of each passenger

% performance parameters
c17.TWR = 0.277; % lbf/lb, thrust to weight ratio
c17.Mmax = 0.8; % max mach number

% aerodynamic data
c17.S = 3800; % ft^2, wing area
c17.span = 169+9.6/12; % ft, wingspan
c17.AR = c17.span^2/c17.S; % aspect ratio
c17.WS = 585e3/c17.S; % lb/ft^2, wing loading
c17.lambdaLE = deg2rad(32); % rad, leading edge sweep angle
c17.Swet = c17.S*5; % ft^2

% cruise parameters
c17.cruiseC = 0.55; % lb/lbf/hr, TSFC cruise
c17.cruiseV = 450; % kts, cruise speed
c17.cruiseAltitude = 32e3; % ft

% loiter parameters
c17.loiterT = 0.75; % hr
c17.loiterC = 0.45; % lb/lbf/hr, TSFC loiter
c17.loiterV = 300; % kts, loiter speed
c17.loiterAltitude = 10e3; % ft
