% This function generates a payload range diagram for the aircraft. % 
% It can be called by adding PayloadRange(FinalOutput) to the end   %
% of the runMASC file. It uses a binary search to find the range    %
% values that would cause the weight estimation to converge for     %
% each payload value.                                               %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function PayloadRange(inputs)
    tolerance = 0.1;
    numPLs = 10000;

    maxR = 10000;
    Rsteps = log(maxR/2/tolerance)/log(2)+1;

    missionnames = fieldnames(inputs.Missions);
    maxLoadweight = 0;
    maxFW = 0;
    MTOW = 0;
    for i=1:size(missionnames,1)
        if (getfield(inputs.Missions, missionnames{i}).loadweight>maxLoadweight)
            maxLoadweight = getfield(inputs.Missions, missionnames{i}).loadweight;
        end
        if (getfield(inputs.Missionoutputs, missionnames{i}).Wfuel>maxFW)
            maxFW = getfield(inputs.Missionoutputs, missionnames{i}).Wfuel;
        end
        if (getfield(inputs.Missionoutputs, missionnames{i}).Wmat(1)>MTOW)
            MTOW = getfield(inputs.Missionoutputs, missionnames{i}).Wmat(1);
        end
    end

    loadweights = linspace(0,maxLoadweight, numPLs);
    payloads = loadweights + inputs.PayloadInputs.crewpayload;
    WS = getfield(inputs.Missionoutputs, missionnames{i}).EmptyWeight.We;
    fuelweights = min([MTOW-payloads-WS; ones(1, numPLs)*maxFW],[],1);
    FWFs = fuelweights./(fuelweights+payloads+WS);

    f_to = WarmupTakeoffFunction(inputs).f_to;
    f_cl = ClimbFunction(inputs).f_cl;
    f_dec = DescentFunction(inputs).f_dec;
    f_lnd = LandingTaxiFunction(inputs).f_lnd;

    f_to_times_f_lt_target = (1-FWFs/1.01)/f_to/f_cl/f_dec/f_lnd;

    inputs.MissionInputs.R = ones(1, numPLs)*maxR/2;
    stepsize = maxR/2;

    B1 = (fuelweights+payloads+WS)*f_to*f_cl;
    B2 = (fuelweights+payloads+WS)*f_to*f_cl*f_dec;

    for i = 1:Rsteps
        f_cr = CruiseFunction(inputs,B1).f_cr;
        f_lt = LoiterFunction(inputs,B2.*f_cr).f_lt;

        stepsize = stepsize/2;
        stepdir = sign(f_cr.*f_lt-f_to_times_f_lt_target);
        inputs.MissionInputs.R = inputs.MissionInputs.R + stepdir*stepsize;
    end
    
    loadweights=[loadweights,loadweights(end)];
    inputs.MissionInputs.R=[inputs.MissionInputs.R,0];

    figure(11)
    plot(loadweights, inputs.MissionInputs.R)
    grid on
    xlabel("Payload (lb)")
    ylabel("Range (nmi)")
end
