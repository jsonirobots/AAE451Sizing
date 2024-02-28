%This function estimates the empty of the aircraft, following the same     % 
%approach used in the excel "simple" and "initial" sizing sheets.          %
%Recommended to perform an empty weight build-up by estimating the weight  % 
% of all the aircraft component (groups).                                  %
% See Raymer Ch.15 Eq. 15.25 - 15.45 for alternative ways to compute       %
% component weights                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output = EmptyWeightFunction(inputs)

  AR        = inputs.GeometryInputs.AR;               % wing aspect ratio
  TW        = inputs.PerformanceInputs.TW;            % thrust-to-weight ratio
  WS        = inputs.PerformanceInputs.WS;            % wing loading [lbs/ft^2]
  M_max      = 1.05*inputs.PerformanceInputs.M;        % M_max = 5% higher than cruise Mach  
  W_dg      = inputs.Sizing.TOGW_temp;                % Design gross weight [lb]			


% Empty weight [lbs]
%Raymer "GA - SINGLE ENGINE", Table 6.2
  a         = 0.32;
  b         = 0.66;
  C1        = -0.13;
  C2        = 0.30;
  C3        = 0.06;
  C4        = -0.05;
  C5        = 0.05;
  K_VS      = 1.00;

  output.We = (a+b*W_dg^C1*AR^C2*TW^C3*WS^C4*M_max^(0.27))*W_dg;
% Empty weight fraction
  output.fe = output.We/inputs.Sizing.TOGW_temp; 

end
