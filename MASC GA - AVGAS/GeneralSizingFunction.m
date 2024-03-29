function output=GeneralSizingFunction(inputs)

%% DETERMINE HEAVIEST STRUCTURE WEIGHT
    
    DesignOutput = DesignMissionFunction(inputs);
    MediumOutput = MediumMissionFunction(inputs);
    FerryOutput = FerryMissionFunction(inputs);

    zeromat = zeros(size(inputs.PerformanceInputs.WS));

    inputs.EmptyWeight.We         = zeromat;
    inputs.EmptyWeight.fe         = zeromat;
    inputs.GeometryOutput.b       = zeromat;
    inputs.GeometryOutput.MAC     = zeromat;
    inputs.GeometryOutput.Sv      = zeromat;
    inputs.GeometryOutput.Sh      = zeromat;
    inputs.GeometryOutput.Sw      = zeromat;
    inputs.GeometryOutput.Swetfus = zeromat;
    inputs.GeometryOutput.Sweteng = zeromat;
    inputs.GeometryOutput.Swet    = zeromat;

    boolmat = (DesignOutput.EmptyWeight.We > MediumOutput.EmptyWeight.We).*(DesignOutput.EmptyWeight.We > FerryOutput.EmptyWeight.We);
    inputs.EmptyWeight.We         = inputs.EmptyWeight.We+boolmat.*DesignOutput.EmptyWeight.We;
    inputs.EmptyWeight.fe         = inputs.EmptyWeight.fe+boolmat.*DesignOutput.EmptyWeight.fe;
    inputs.GeometryOutput.b       = inputs.GeometryOutput.b+boolmat.*DesignOutput.GeometryOutput.b;
    inputs.GeometryOutput.MAC     = inputs.GeometryOutput.MAC+boolmat.*DesignOutput.GeometryOutput.MAC;
    inputs.GeometryOutput.Sv      = inputs.GeometryOutput.Sv+boolmat.*DesignOutput.GeometryOutput.Sv;
    inputs.GeometryOutput.Sh      = inputs.GeometryOutput.Sh+boolmat.*DesignOutput.GeometryOutput.Sh;
    inputs.GeometryOutput.Sw      = inputs.GeometryOutput.Sw+boolmat.*DesignOutput.GeometryOutput.Sw;
    inputs.GeometryOutput.Swetfus = inputs.GeometryOutput.Swetfus+boolmat.*DesignOutput.GeometryOutput.Swetfus;
    inputs.GeometryOutput.Sweteng = inputs.GeometryOutput.Sweteng+boolmat.*DesignOutput.GeometryOutput.Sweteng;
    inputs.GeometryOutput.Swet    = inputs.GeometryOutput.Swet+boolmat.*DesignOutput.GeometryOutput.Swet;

    boolmat = (MediumOutput.EmptyWeight.We > DesignOutput.EmptyWeight.We).*(MediumOutput.EmptyWeight.We > FerryOutput.EmptyWeight.We);
    inputs.EmptyWeight.We         = inputs.EmptyWeight.We+boolmat.*MediumOutput.EmptyWeight.We;
    inputs.EmptyWeight.fe         = inputs.EmptyWeight.fe+boolmat.*MediumOutput.EmptyWeight.fe;
    inputs.GeometryOutput.b       = inputs.GeometryOutput.b+boolmat.*MediumOutput.GeometryOutput.b;
    inputs.GeometryOutput.MAC     = inputs.GeometryOutput.MAC+boolmat.*MediumOutput.GeometryOutput.MAC;
    inputs.GeometryOutput.Sv      = inputs.GeometryOutput.Sv+boolmat.*MediumOutput.GeometryOutput.Sv;
    inputs.GeometryOutput.Sh      = inputs.GeometryOutput.Sh+boolmat.*MediumOutput.GeometryOutput.Sh;
    inputs.GeometryOutput.Sw      = inputs.GeometryOutput.Sw+boolmat.*MediumOutput.GeometryOutput.Sw;
    inputs.GeometryOutput.Swetfus = inputs.GeometryOutput.Swetfus+boolmat.*MediumOutput.GeometryOutput.Swetfus;
    inputs.GeometryOutput.Sweteng = inputs.GeometryOutput.Sweteng+boolmat.*MediumOutput.GeometryOutput.Sweteng;
    inputs.GeometryOutput.Swet    = inputs.GeometryOutput.Swet+boolmat.*MediumOutput.GeometryOutput.Swet;

    boolmat = (FerryOutput.EmptyWeight.We > DesignOutput.EmptyWeight.We).*(FerryOutput.EmptyWeight.We > MediumOutput.EmptyWeight.We);
    inputs.EmptyWeight.We         = inputs.EmptyWeight.We+boolmat.*FerryOutput.EmptyWeight.We;
    inputs.EmptyWeight.fe         = inputs.EmptyWeight.fe+boolmat.*FerryOutput.EmptyWeight.fe;
    inputs.GeometryOutput.b       = inputs.GeometryOutput.b+boolmat.*FerryOutput.GeometryOutput.b;
    inputs.GeometryOutput.MAC     = inputs.GeometryOutput.MAC+boolmat.*FerryOutput.GeometryOutput.MAC;
    inputs.GeometryOutput.Sv      = inputs.GeometryOutput.Sv+boolmat.*FerryOutput.GeometryOutput.Sv;
    inputs.GeometryOutput.Sh      = inputs.GeometryOutput.Sh+boolmat.*FerryOutput.GeometryOutput.Sh;
    inputs.GeometryOutput.Sw      = inputs.GeometryOutput.Sw+boolmat.*FerryOutput.GeometryOutput.Sw;
    inputs.GeometryOutput.Swetfus = inputs.GeometryOutput.Swetfus+boolmat.*FerryOutput.GeometryOutput.Swetfus;
    inputs.GeometryOutput.Sweteng = inputs.GeometryOutput.Sweteng+boolmat.*FerryOutput.GeometryOutput.Sweteng;
    inputs.GeometryOutput.Swet    = inputs.GeometryOutput.Swet+boolmat.*FerryOutput.GeometryOutput.Swet;

%% SIZE AIRCRAFT
   DesignOutput = DesignMissionFunction(inputs);

   output = DesignOutput.DesignTOGW;



