% This function estimates fuel weight  for cruise.         % 
% It assumes CONSTANT ALTITUDE and MACH NUMBER for cruise. %
% Hence, L/D is assumed to be constant (for given altitude %
% and mach number).                                        %
% See Raymer Ch.6 equation 6.11                            %
% Outputs:                                                 %
%   Cruise fuel weight fraction                            %
%   Cruise fuel weight                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output = CruiseFunction(inputs,Wo)

%% Inputs for cruise fuel computations
Range  = inputs.MissionInputs.R;                    % aircraft design range [nmi]
C  = inputs.PropulsionInputs.C;             % specific fuel consumption [1/hr]
%%
%% Parasite drag computation
 inputs.Aero.Cdo = ParasiteDragFunction(inputs);    % Parasite Drag Coefficient, Cdo
 inputs.Aero.e0  = OswaldEfficiency(inputs);        % Oswald Efficiency Factor, e0

%% Additional inputs needed for cruise segment analysis
 inputs.Aero.V = inputs.PerformanceInputs.V;        % cruise velocity [knots]
 inputs.Aero.h = inputs.PerformanceInputs.hc;       % cruise altitude [ft]
 
%% Cruise fuel computation  
   V     = inputs.Aero.V;                           % cruise velocity [knots]
   Wf    = Wo;                                      % initialize aircraft weight for cruise computation [lbs]
   segs  = 25;                                      % number of cruise segments
   Range_seg = Range/segs;                   % length of each cruise segment [nmi]
   V_ft_s =  V*1.68781;                             % cruise velocity [ft/s]
   
  for i = 1:segs
      Wi = Wf;                                      % weight at beginning of cruise segment
      [Cdi,CL]    = InducedDragFunction(inputs,Wi); % induced drag and lift coefficients 
      CD          = inputs.Aero.Cdo + Cdi;          % total drag coefficient
      LDrat       = CL/CD;                          % lift-to-drag ratio during segment
      fc          = exp(-Range_seg*C/(LDrat*V));    % cruise fuel fraction 
      Wf          = Wi*fc;                          % final aircraft weight after cruise [lbs]
  end
  output.f_cr     = Wf/Wo;                          % cruise fuel-weight ratio (for entire mission)
  output.fuel     = (Wo-Wf);                          % total cruise fuel [lbs]
end
  
  
