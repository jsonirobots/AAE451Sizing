function FinalOutput = PerformanceFunction(inputs)
  FinalOutput             = inputs;

% Comptue takeoff lift coefficient (assumes Clmax is 1.2 times the takeoff lift coefficient 
  Cl_to   = inputs.AeroInputs.Clmax/1.44; 
 
% Compute takeoff parrameter (based on Raymer Ch.5 Figure 5.4)
  takeoff_parameter = (inputs.PerformanceInputs.WS)/(Cl_to*inputs.PerformanceInputs.TW);
  
% Estimate takeoff distance by using takeoff_parameter and Figure 5.4 in Raymer Ch.5 
  FinalOutput.Sto = (35793/1029250*takeoff_parameter+1129/20585) * 1000; % take-off distance; 8.5 is the slope for Ground Roll for a 4-engined jet aircraft;
                                      % change to meet FAR part 23
                                      % requirements
  
%% See Raymer Ch. 17 to comptue other performance characteristics
%% See Raymer Ch. 16 to compute control and stability performance
