function output = GeneralSizing(inputs)
    
    missionnames = fieldnames(inputs.Missions);
    inputs.Missionoutputs.temp = false;

    vectorsize = [1, max(size(inputs.PerformanceInputs.WS,2),size(inputs.PerformanceInputs.TW,2))];
    

    maxTOGW = zeros(vectorsize);
    maxindex = zeros(vectorsize);
    inputs = rmfield(inputs, "EmptyWeight");

    for i=1:size(missionnames,1)
        
        inputs.MissionInputs  = getfield(inputs.Missions, missionnames{i});
        inputs.Missionoutputs = setfield(inputs.Missionoutputs, missionnames{i}, MissionFunction(inputs));
        Wmat = getfield(inputs.Missionoutputs, missionnames{i}).Wmat;
        
        maxindex = i.*(Wmat(1,:)>maxTOGW) + maxindex.*(Wmat(1,:)<=maxTOGW);
        maxTOGW = Wmat(1,:).*(Wmat(1,:)>maxTOGW) + maxTOGW.*(Wmat(1,:)<=maxTOGW);



    end
    inputs.Missionoutputs = rmfield(inputs.Missionoutputs, "temp");
    

    inputs.EmptyWeight.We = zeros(vectorsize);
    inputs.EmptyWeight.fe = zeros(vectorsize);

    inputs.GeometryOutput.AR = zeros(vectorsize);
    inputs.GeometryOutput.MAC = zeros(vectorsize);
    inputs.GeometryOutput.Sv = zeros(vectorsize);
    inputs.GeometryOutput.Sh = zeros(vectorsize);
    inputs.GeometryOutput.Sw = zeros(vectorsize);
    inputs.GeometryOutput.Swetfus = zeros(vectorsize);
    inputs.GeometryOutput.Sweteng = zeros(vectorsize);
    inputs.GeometryOutput.Swet = zeros(vectorsize);

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

    end

    for i=1:size(missionnames,1)
        inputs.MissionInputs  = getfield(inputs.Missions, missionnames{i});
        inputs.Missionoutputs = setfield(inputs.Missionoutputs, missionnames{i}, MissionFunction(inputs));
    end
    
    maxTOGW = zeros(vectorsize);

    
    for i=1:size(missionnames,1)
        Wmat = getfield(inputs.Missionoutputs, missionnames{i}).Wmat;
        maxTOGW = Wmat(1,:).*(Wmat(1,:)>maxTOGW) + maxTOGW.*(Wmat(1,:)<=maxTOGW);
    end

    output = maxTOGW;