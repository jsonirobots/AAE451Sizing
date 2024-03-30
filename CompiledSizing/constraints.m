function constraint = constraints(plane,WS,Wfracs)
% TOC
TOC.beta = prod(Wfracs(1,1:2));
TOC.dhdt = 100/60; % ft/s, service ceiling FAA
TOC.dvdt = 0; % ft/s/s, longitudinal acceleration
V = ktsTOfts(plane.cruiseV); % ft/s, velocity at TOC
g = 32.174; % ft/s/s
constraint.TOC.TWR = TOC.beta/plane.engines.alpha*(plane.cruiseq/TOC.beta* ...
    (plane.Cd0./WS + 1/(pi*plane.wing.AR*plane.e)*...
    (TOC.beta/plane.cruiseq)^2.*WS) + 1/V*TOC.dhdt + 1/g*TOC.dvdt);

% TO
CL_TO = plane.wing.CLmax*cosd(plane.wing.lambdaLE);
TOP = plane.wing.WS/(1*CL_TO*plane.TWR); % takeoff parameter
constraint.TO.TWR =  WS./(TOP*1*CL_TO);% beta_TO^2./(TOP.*1*Clmax).*W_S;

% Land
% https://www.hq.nasa.gov/pao/History/SP-468/app-h.htm
% ~ 40% of available field length is left to handle off-nominal
% landings (floating, varying landing speeds, etc.)
landdist = plane.maxRunwayLen*0.6; 
apprdist = 50/tand(3); % approach distance, clearing 50 ft obstacle at glide slope = 3 deg
constraint.land.WS = plane.wing.CLmax/0.85/80*(landdist - apprdist);

end

% knots to ft/s conversion
function fts = ktsTOfts(kts)
    fts = 1.68781*kts;
end