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

%% AGGREGATED INPUTS FOR AIRCRAFT SIZING
inputs = AircraftParameters();

%% DETERMINE HEAVIEST STRUCTURE WEIGHT
    missionnames = fieldnames(inputs.Missions);
    inputs.Missionoutputs.temp = false;
    maxTOGW = 0;
    for i=1:size(missionnames,1)
        inputs.MissionInputs  = getfield(inputs.Missions, missionnames{i});
        inputs.Missionoutputs = setfield(inputs.Missionoutputs, missionnames{i}, MissionFunction(inputs));
        Wmat = getfield(inputs.Missionoutputs, missionnames{i}).Wmat;
        if (Wmat(1)>maxTOGW)
            maxTOGW = Wmat(1);
            maxindex = i;
        end
    end
    inputs.Missionoutputs = rmfield(inputs.Missionoutputs, "temp");
    
    inputs.EmptyWeight = getfield(inputs.Missionoutputs, missionnames{maxindex}).EmptyWeight;
    inputs.GeometryOutput = getfield(inputs.Missionoutputs, missionnames{maxindex}).GeometryOutput;

    for i=1:size(missionnames,1)
        inputs.MissionInputs  = getfield(inputs.Missions, missionnames{i});
        inputs.Missionoutputs = setfield(inputs.Missionoutputs, missionnames{i}, MissionFunction(inputs));
    end


%% PERFORMANCE ANALYSIS
   %PerformanceFunction(inputs);
   
%% ACQUISITION COST ANALYSIS
%    AqCostOutput = AcquisitionCostFunction(SizingOutput);
   
%% OPERATING COST ANALYSIS  
%    OpCostOutput = OperatingCostFunction(SizingOutput,AqCostOutput,EconMissionOutput);
  
%% DISPLAY RESULTS
   % FinalOutput              = FerryOutput;
%    FinalOutput.AqCostOutput = AqCostOutput;
%    FinalOutput.OpCostOutput = OpCostOutput;
   ReportFunction(inputs);

   PayloadRange(inputs);

   Vndiagram(inputs)
