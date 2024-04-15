function output = TakeoffConstraintSizing(inputs)
    
    missionnames = fieldnames(inputs.Missions);
    inputs.Missionoutputs.temp = false;
    maxTOGW = zeros(size(inputs.PerformanceInputs.WS));
    maxindex = zeros(size(inputs.PerformanceInputs.WS));


    for i=1:size(missionnames,1)
        inputs.MissionInputs  = getfield(inputs.Missions, missionnames{i});
        inputs.Missionoutputs = setfield(inputs.Missionoutputs, missionnames{i}, TopOfClimbConstraintMission(inputs));
        Wmat = getfield(inputs.Missionoutputs, missionnames{i}).Wmat;
        
        maxindex = i.*(Wmat(1,:)>maxTOGW) + maxindex.*(Wmat(1,:)<=maxTOGW);
        maxTOGW = Wmat(1,:).*(Wmat(1,:)>maxTOGW) + maxTOGW.*(Wmat(1,:)<=maxTOGW);
    end
    inputs.Missionoutputs = rmfield(inputs.Missionoutputs, "temp");
    

    inputs.EmptyWeight.We = zeros(size(inputs.PerformanceInputs.WS));
    inputs.EmptyWeight.fe = zeros(size(inputs.PerformanceInputs.WS));

    inputs.GeometryOutput.AR = zeros(size(inputs.PerformanceInputs.WS));
    inputs.GeometryOutput.MAC = zeros(size(inputs.PerformanceInputs.WS));
    inputs.GeometryOutput.Sv = zeros(size(inputs.PerformanceInputs.WS));
    inputs.GeometryOutput.Sh = zeros(size(inputs.PerformanceInputs.WS));
    inputs.GeometryOutput.Sw = zeros(size(inputs.PerformanceInputs.WS));
    inputs.GeometryOutput.Swetfus = zeros(size(inputs.PerformanceInputs.WS));
    inputs.GeometryOutput.Sweteng = zeros(size(inputs.PerformanceInputs.WS));
    inputs.GeometryOutput.Swet = zeros(size(inputs.PerformanceInputs.WS));

    inputs.PerformanceInputs.TW = zeros(size(inputs.PerformanceInputs.WS));

    for i=1:size(missionnames,1)

        inputs.EmptyWeight.We = inputs.EmptyWeight.We + (maxindex==i).*getfield(inputs.Missionoutputs, missionnames{i}).EmptyWeight.We;
        inputs.EmptyWeight.fe = inputs.EmptyWeight.fe + (maxindex==i).*getfield(inputs.Missionoutputs, missionnames{i}).EmptyWeight.fe;

        inputs.GeometryOutput.AR = inputs.GeometryOutput.AR + (maxindex==i).*getfield(inputs.Missionoutputs, missionnames{i}).GeometryOutput.AR;
        inputs.GeometryOutput.MAC = inputs.GeometryOutput.MAC + (maxindex==i).*getfield(inputs.Missionoutputs, missionnames{i}).GeometryOutput.MAC;
        inputs.GeometryOutput.Sv = inputs.GeometryOutput.Sv + (maxindex==i).*getfield(inputs.Missionoutputs, missionnames{i}).GeometryOutput.Sv;
        inputs.GeometryOutput.Sh = inputs.GeometryOutput.Sh + (maxindex==i).*getfield(inputs.Missionoutputs, missionnames{i}).GeometryOutput.Sh;
        inputs.GeometryOutput.Sw = inputs.GeometryOutput.Sw + (maxindex==i).*getfield(inputs.Missionoutputs, missionnames{i}).GeometryOutput.Sw;
        inputs.GeometryOutput.Swetfus = inputs.GeometryOutput.Swetfus + (maxindex==i).*getfield(inputs.Missionoutputs, missionnames{i}).GeometryOutput.Swetfus;
        inputs.GeometryOutput.Sweteng = inputs.GeometryOutput.Sweteng + (maxindex==i).*getfield(inputs.Missionoutputs, missionnames{i}).GeometryOutput.Sweteng;
        inputs.GeometryOutput.Swet = inputs.GeometryOutput.AR + (maxindex==i).*getfield(inputs.Missionoutputs, missionnames{i}).GeometryOutput.Swet;

        inputs.PerformanceInputs.TW = inputs.PerformanceInputs.TW + (maxindex==i).*getfield(inputs.Missionoutputs, missionnames{i}).PerformanceInputs.TW;
    end

    for i=1:size(missionnames,1)
        inputs.MissionInputs  = getfield(inputs.Missions, missionnames{i});
        inputs.Missionoutputs = setfield(inputs.Missionoutputs, missionnames{i}, TopOfClimbConstraintMission(inputs));
    end

    output = inputs;