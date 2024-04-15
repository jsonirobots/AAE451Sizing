
%% Function that sizes the aircraft for the given input parameters
% The approach follows Raymer Ch.6
% The design mission is assumed to be:
%
%              ______cruise_____
%             /                 \ descent
%            /                   \___
%           /climb                \_/ loiter
%          /                        \ 
%_________/                          \_____ 
%taxi & TO                          landing & taxi
%
% Note that no reserve segment is present here. 
% Additional mission segments can be added but this function must be
% changed to accomodate these.
%%
function Output = TakeoffConstraintMission(inputs)
tolerance = 0.1;

%% Start Aircraft Sizing Iterations
minTOGW = 1000000;
maxTOGW = 2000000;
TOGWrange = maxTOGW-minTOGW;
TOGWsteps = log(TOGWrange/2/tolerance)/log(2)+1;
stepsize = TOGWrange/2;
TOGW_temp = (minTOGW+stepsize).*ones(size(inputs.PerformanceInputs.WS));

Cl_to   = inputs.AeroInputs.CLmax/1.2;
num_eng = inputs.PropulsionInputs.num_eng;           % number of engines
if num_eng==2
    takeoff_parameter = (inputs.PerformanceInputs.fieldLength/1000+12759/73945)*160750/6693;
  elseif num_eng==4
    takeoff_parameter = (inputs.PerformanceInputs.fieldLength/1000-1129/20585)*1029250/35793;
  elseif num_eng==6
    takeoff_parameter = (inputs.PerformanceInputs.fieldLength/1000-747151/2647231)*661807750/18474717;
  else
    fprintf("Number of engines is not supported\n")
end
inputs.PerformanceInputs.TW = inputs.PerformanceInputs.WS./takeoff_parameter./Cl_to;

initialFlag = isfield(inputs, "EmptyWeight") == 0;

for i=1:TOGWsteps
   inputs.Sizing.Thrust    = TOGW_temp.*inputs.PerformanceInputs.TW; % compute total power (based on P/W)
   inputs.Sizing.TOGW_temp = TOGW_temp;                             % store initial gross weight
   W0                      = TOGW_temp;                             % initial gross weight for current iteration
   inputs.Sizing.W0        = W0;
%% Begin estimation of weight components (empty, fuel, and total weights)
  if initialFlag
    % Generate geometry data for determining heaviest load
    inputs.GeometryOutput = GeometryFunction(inputs);

    % Compute Empty weight and empty weight fraction
    inputs.EmptyWeight = EmptyWeightFunction(inputs);

    % inputs.GeometryOutput = inputs.FerryGeometryOutput;
  end
  
% Warm-up and Takeoff segment fuel weight fraction
  WarmupTakeoffOutput = WarmupTakeoffFunction(inputs);
  f_to                = WarmupTakeoffOutput.f_to;         % warm-up and takeoff fuel weight fraction
  W1                  = TOGW_temp.*f_to;                   % aircraft weight after warm-up and takeoff [lbs]
% Climb segment fuel weight fraction
  ClimbOutput         = ClimbFunction(inputs);
  f_cl                = ClimbOutput.f_cl;                 % climb fuel weight fraction
  W2                  = W1.*f_cl;                          % aircraft weight after climb segment [lbs]
% Cruise segment fuel weight fraction
  CruiseOutput        = CruiseFunction(inputs,W2);
  f_cr                = CruiseOutput.f_cr;                % cruise fuel weight fraction
  W3                  = W2.*f_cr;                          % aircraft weight after cruise segment [lbs]
% Descent segment fuel weight fraction
  DescentOutput       = DescentFunction(inputs);
  f_dec               = DescentOutput.f_dec;              % descent fuel weight segment
  W4                  = W3.*f_dec;                         % aircraft weight after descent segment [lbs]
% Loiter segment fuel weight fraction
  LoiterOutput        = LoiterFunction(inputs,W4);
  f_lt                = LoiterOutput.f_lt;                % loiter fuel weight segment
  W5                  = W4.*f_lt;                          % aircraft weight after loiter segment [lbs]
% Landing and taxi fuel weight fraction
  LandingTaxiOutput   = LandingTaxiFunction(inputs);
  f_lnd               = LandingTaxiOutput.f_lnd;          % landing and taxi fuel weight segment
  W6                  = W5.*f_lnd;                         % aircraft weight after landing & taxi segment [lbs]

%% Compute new weights based on results of current iteration  
% Total fuel weight fraction (including trapped fuel of 1%)

  FWF       = 1.01.*(1 - f_to.*f_cl.*f_cr.*f_dec.*f_lt.*f_lnd);  % Fuel weight fraction 
  Wfuel     = FWF.*TOGW_temp;                              % Total fuel weight [lbs] (Overestimates - used scaling factor)
  
% Aircraft Takeoff Gross Weight Weight (TOGW) [lbs]: Wempty+Wpayload+Wfuel  
  TOGW      = inputs.EmptyWeight.We + inputs.MissionInputs.w_payload + Wfuel;  

  stepsize = stepsize/2;
  stepdir = -sign(TOGW_temp-TOGW);
  TOGW_temp = TOGW_temp + stepdir*stepsize;
end

% EmptyWeightOutput
TOGW = TOGW_temp;                  % Aircraft takeoff gross weight [lbs]
EWF  = inputs.EmptyWeight.We./TOGW;  % Empty weight fraction

%% Aggregate results
Output = inputs;
Output.Wfuel          = Wfuel;
Output.Thrust         = inputs.Sizing.Thrust;
Output.Wmat           = [TOGW; W1; W2; W3; W4; W5; W6];
Output.GeometryOutput = inputs.GeometryOutput;
Output.EmptyWeight    = inputs.EmptyWeight;
end
