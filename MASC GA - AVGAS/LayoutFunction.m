% Function that computes fuselage dimensions and number of crew members 
% (excluding pilots) based on the number of passengers. 
% Changes may be required based on the specific aircraft being studied.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output = LayoutFunction(inputs)

%% Inputs
pax = inputs.MissionInputs.pax;

%% Aircraft layout inputs (mid-size passenger transport)
crewnum          = 1;    % crew members (pilots only)

%% Aircraft fuselage dimensions & flight crew 

% diameter of fuselage [ft]
df = 5.9;                                       % aircraft diameter [ft]

% length of fuselage [ft]  
lf = 55;

% number of crew members (not including pilots) 
flcrewnum   = 0;  % number of flight crew 

%number of crew members (pilots and flight attendants)
crew = crewnum + flcrewnum;  

%% Output compilation
output.df     = df;
output.lf     = lf;
output.crew   = crew;
output.pilots = crewnum;
output.flcrew = flcrewnum;


        
        