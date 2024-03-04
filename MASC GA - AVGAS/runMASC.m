%% MATLAB AIRCRAFT SIZING CODE (MASC) - GA AIRCRAFT (AV GAS)
%This sizing routing size a General Aviation aircraft for a set of given  %  
% input parameters It largely based on Raymer's aircraft sizing approach- %
% equations and tables are referenced throughout the code.                %              %  
% Note 1:                                                                 % 
% This code does not have an engine-deck generation. Power is  obtained   % 
% from the P/W parameter and the engine sized accordingly. This is a      % 
% simplified way to get engine information and may need to be changed     % 
% according to desired studies/analyses.                                  % 
% Note 2:                                                                 % 
% The cabin (fuselage) layout is computed based on a series of parameters %
% that are listed in LayoutFunction.m. These must be changed if alternate % 
% cabin layout configurations are desired.                                % 
% Parithi Govindaraju - January 2016                                      %
% Brandonn Sells - EDITED JANUARY 2019                                    %

%% HOUSEKEEPING
clear
clc

%% PAYLOAD PARAMETERS
PayloadInputs.crewnum    = 8;              % number of crew members (pilots)
PayloadInputs.paxweight  = 200;            % passenger weight (including luggage) [lbs]
PayloadInputs.crewweight = 300;            % crew member weight (including luggage) [lbs]

%% DESIGN MISSION PARAMETERS
DesignInputs.R           = 2500;           % aircraft range [nmi]
DesignInputs.loiter_time = 0.5;            % loiter time [hours]
DesignInputs.pax         = 0;              % number of passengers   
DesignInputs.loadweight  = 430000;         % weight of load carried in mission
paxweight  = PayloadInputs.paxweight.*DesignInputs.pax;      % weight of passengers (including luggage) [lbs]
crewweight = PayloadInputs.crewweight*PayloadInputs.crewnum;  % weight of crew members [lbs]
DesignInputs.w_payload  = crewweight + paxweight + DesignInputs.loadweight;

%% MEDIUM PAYLOAD MISSION PARAMETERS
MediumInputs.R           = 5000 ;    % aircraft range [nmi]
MediumInputs.loiter_time = 0.5;   % loiter time [hours]
MediumInputs.pax         = 0;      % number of passengers   
MediumInputs.loadweight  = 295000; % weight of load carried in mission
paxweight  = PayloadInputs.paxweight.*DesignInputs.pax;      % weight of passengers (including luggage) [lbs]
crewweight = PayloadInputs.crewweight*PayloadInputs.crewnum;  % weight of crew members [lbs]
MediumInputs.w_payload  = crewweight + paxweight + MediumInputs.loadweight;

%% FERRY MISSION PARAMETERS
FerryInputs.R           = 8000;    % aircraft range [nmi]
FerryInputs.loiter_time = 0.5;   % loiter time [hours]
FerryInputs.pax         = 0;      % number of passengers   
FerryInputs.loadweight  = 0; % weight of load carried in mission
paxweight  = PayloadInputs.paxweight.*DesignInputs.pax;      % weight of passengers (including luggage) [lbs]
crewweight = PayloadInputs.crewweight*PayloadInputs.crewnum;  % weight of crew members [lbs]
FerryInputs.w_payload  = crewweight + paxweight + FerryInputs.loadweight;

%% AGGREGATED INPUTS FOR AIRCRAFT SIZING
inputs = AircraftParameters();
inputs.DesignInputs      = DesignInputs;
inputs.MediumInputs      = MediumInputs;
inputs.FerryInputs       = FerryInputs;
inputs.PayloadInputs     = PayloadInputs;

%% SIZE AIRCRAFT
   DesignOutput = DesignMissionFunction(inputs);

%% MEDIUM PAYLOAD MISSION ANALYSIS
   MediumMissionOutput = MediumMissionFunction(DesignOutput);

%% FERRY MISSION ANALYSIS
   FerryMissionOutput = FerryMissionFunction(MediumMissionOutput);
   
%% PERFORMANCE ANALYSIS
   PerformanceOutput = PerformanceFunction(FerryMissionOutput);
   
%% ACQUISITION COST ANALYSIS
%    AqCostOutput = AcquisitionCostFunction(SizingOutput);
   
%% OPERATING COST ANALYSIS  
%    OpCostOutput = OperatingCostFunction(SizingOutput,AqCostOutput,EconMissionOutput);
  
%% DISPLAY RESULTS
   FinalOutput              = PerformanceOutput;
%    FinalOutput.AqCostOutput = AqCostOutput;
%    FinalOutput.OpCostOutput = OpCostOutput;
   ReportFunction(FinalOutput);





