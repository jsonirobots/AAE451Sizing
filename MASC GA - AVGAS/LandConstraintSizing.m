function output = LandConstraintSizing(inputs)

    missionnames = fieldnames(inputs.Missions);
    inputs.Missionoutputs.temp = false;
    maxTOGW = 0;
    for i=1:size(missionnames,1)
        inputs.MissionInputs  = getfield(inputs.Missions, missionnames{i});
        inputs.Missionoutputs = setfield(inputs.Missionoutputs, missionnames{i}, LandConstraintMission(inputs));
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
        inputs.Missionoutputs = setfield(inputs.Missionoutputs, missionnames{i}, LandConstraintMission(inputs));
    end

    output = inputs;