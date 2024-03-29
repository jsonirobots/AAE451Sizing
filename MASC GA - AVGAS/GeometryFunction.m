%% This function analyzes the aircraft geometry %%%
% Outputs:                                        %
%   Wing span                                     %
%   Mean Aerodynamic Chord (MAC)                  %
%   Wing planform area                            %
%   H-tail planform area                          %
%   V-tail planform area                          %
%   Wing wetted area                              %
%   H-tail wetted area                            %
%   V-tail wetted area                            %
%   Fuselage wetted area                          %
%   Engine wetted area                            %
%   Aircraft wetted area                          %
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [output] = GeometryFunction(inputs)

%% INPUTS
Wt          = inputs.Sizing.TOGW_temp;                 % Takeoff gross weight [lbs]
WingLoading = inputs.PerformanceInputs.WS;             % Wing loading [lbs/ft^2]
M           = inputs.PerformanceInputs.M;              % Cruise mach number
num_eng     = inputs.PropulsionInputs.num_eng;         % Number of engines

AR          = inputs.GeometryInputs.AR;                % Wing aspect ratio
TR          = inputs.GeometryInputs.TR;                % Wing taper ratio
lf          = inputs.LayoutInputs.lf;                  % Fuselage length [ft]
df          = inputs.LayoutInputs.df;                  % Fuselage diameter [ft]

Cht         = inputs.GeometryInputs.Cht;                      % Horizontal-tail volume coefficient
Cvt         = inputs.GeometryInputs.Cvt;                      % Vertical-tail volume coefficient
H_loc       = inputs.GeometryInputs.H_loc;                    % Location of H-tail as a fraction of fuselage length
V_loc       = inputs.GeometryInputs.H_loc;                    % Location of H-tail as a fraction of fuselage length
le          = inputs.GeometryInputs.le;                       % engine length [ft]
de          = inputs.GeometryInputs.de;                       % engine diameter [ft]

%%
%% Wing geometry computations (See Raymer Ch.7 Eq. 7.5-7.8)
Sw          = Wt./WingLoading;                          % Wing planform area [ft^2]
b           = sqrt(AR.*Sw);                             % Wing span [ft]
MAC         = ((1+TR+(TR.^2))./(1+TR).^2).*(Sw./b).*(4/3);   % Mean aerodynamic chord of wing
Swetwing    = 2*Sw*1.02;                               % Wing wetted area [ft^2]
%% Fuselage wetted computations
% need to be checked for source
fr          = lf./df;                                   % fuselage finess ratio
Swetfus     = pi.*df.*lf.*(1-2./fr).^(2/3)*(1+1./fr.^2);      % wetted area of fuselage [ft^2]

%% Tails geometry computations (Based on Raymer Ch.6 Eq. 6.28-6.29)
Lht         = H_loc.*lf;                                % H-tail moment arm [ft]
Lvt         = V_loc.*lf;                                % V-tail moment arm (for engines on wing) [ft]
Sv          = Cvt.*b.*Sw./Lvt;                            % V-tail surface area [ft^2]
Sh          = Cht.*MAC.*Sw./Lht;                          % H-tail surface area [ft^2]
Sweth       = 2*Sh*1.02;                               % H-tail wetted area [ft^2]
Swetv       = 2*Sv*1.02;                               % V-tail wetted area [ft^2]

%% Engine geometry computations (based on Raymer Taqble 10.4)
Sweteng     = pi.*de.*le.*num_eng;                        % wetted area of engines [ft^2]

%% Total wetted area computation
Swet        = Swetwing+Swetfus+Swetv+Sweth+Sweteng;    % total wetted area of aircraft [ft^2]

%% Function Outputs
output.b       = b;
output.MAC     = MAC;
output.Sv      = Sv;
output.Sh      = Sh;
output.Sw      = Sw;
output.Swetfus = Swetfus;
output.Sweteng = Sweteng;
output.Swet    = Swet;
end
