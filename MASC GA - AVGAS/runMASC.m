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

%% DESIGN MISSION PARAMETERS
DesignInputs.R           = 2150;    % aircraft range [nmi]
DesignInputs.loiter_time = 0.5;   % loiter time [hours]
DesignInputs.pax         = 0;      % number of passengers   

%% MEDIUM PAYLOAD MISSION PARAMETERS


%% FERRY MISSION PARAMETERS


%% ECONOMIC MISSION PARAMETERS
EconMission.range         = 1350;    % economic mission length [nmi]

%% PERFORMANCE PARAMETERS

PerformanceInputs.TW   = 0.26;     % thrust-to-weight ratio
PerformanceInputs.WS   = 840000/6200;        % wing loading [lbs/ft^2]
PerformanceInputs.V    = 450;       % cruise velocity [knots]
PerformanceInputs.M    = 0.77;     % cruise velocity [Mach]. This needs to be changed to match V at desired altitude.  Can automate this calculation with the AtmosphereFunction
PerformanceInputs.Vlt  = 300;       % loiter velocity [knots]
PerformanceInputs.nmax = 2;      % maximum load factor
PerformanceInputs.hc   = 33000;      % cruise altitude [ft]
PerformanceInputs.hlt  = 10000;      % loiter altitude [ft]

%% GEOMETRY PARAMETERS
GeometryInputs.AR          = 8;         % wing aspect ratio
GeometryInputs.WingSweep   = 25;          % wing sweep (LE) [deg]
GeometryInputs.thick2chord = 0.15;       % wing thickness-to-chord ratio
GeometryInputs.TR          = 0.3;        % wing taper ratio
        
%% CONFIGURATION PARAMETERS
LayoutInputs.lf = 55;                    % length of fuselage [ft]
LayoutInputs.df = 5.9;                   % diameter of fuselage [ft]

%% AERODYNAMIC PARAMETERS
AeroInputs.Clmax   = 1.6;                  % maximum lift coefficient

%% PROPULSION PARAMETERS
PropulsionInputs.num_eng    = 1;           % number of engines
PropulsionInputs.C          = 0.5;         % Jet specific fuel consumption [1/hr] 

%% PAYLOAD PARAMETERS
PayloadInputs.crewnum    = 4;              % number of crew members (pilots)
PayloadInputs.paxweight  = 200;            % passenger weight (including luggage) [lbs]
PayloadInputs.crewweight = 300;            % crew member weight (including luggage) [lbs]
PayloadInputs.loadweight = 281000;

paxweight  = PayloadInputs.paxweight.*DesignInputs.pax;      % weight of passengers (including luggage) [lbs]
crewweight = PayloadInputs.crewweight*PayloadInputs.crewnum;  % weight of crew members [lbs]
loadweight = PayloadInputs.loadweight;
PayloadInputs.w_payload  = crewweight + paxweight + loadweight;            % total payload weight

%% AGGREGATED INPUTS FOR AIRCRAFT SIZING
inputs.DesignInputs      = DesignInputs;
inputs.EconMission       = EconMission;
inputs.PerformanceInputs = PerformanceInputs;
inputs.LayoutInputs      = LayoutInputs;
inputs.GeometryInputs    = GeometryInputs;
inputs.PayloadInputs     = PayloadInputs;
inputs.PropulsionInputs  = PropulsionInputs;
inputs.AeroInputs        = AeroInputs;

%% SIZE AIRCRAFT
   DesignOutput = DesignMissionFunction(inputs);

%% ECONOMIC MISSION ANALYSIS
   EconMissionOutput = EconMissionFunction(DesignOutput);
   
%% PERFORMANCE ANALYSIS
   PerformanceOutput = PerformanceFunction(DesignOutput);
   
%% ACQUISITION COST ANALYSIS
%    AqCostOutput = AcquisitionCostFunction(SizingOutput);
   
%% OPERATING COST ANALYSIS  
%    OpCostOutput = OperatingCostFunction(SizingOutput,AqCostOutput,EconMissionOutput);
  
%% DISPLAY RESULTS
   FinalOutput              = DesignOutput;
%    FinalOutput.AqCostOutput = AqCostOutput;
%    FinalOutput.OpCostOutput = OpCostOutput;
   ReportFunction(FinalOutput);





