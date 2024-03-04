function FinalOutput = PerformanceFunction(inputs)
  FinalOutput             = inputs;

  WSrange=linspace(10,200,100000);

% Comptue takeoff lift coefficient (assumes Clmax is 1.2 times the takeoff lift coefficient 
  Cl_to   = inputs.AeroInputs.Clmax/1.2; 
  Cl_land = inputs.AeroInputs.Clmax;
  WFcruise = inputs.W2overW0;
  lapse = inputs.PropulsionInputs.lapse;
  V  = inputs.PerformanceInputs.V;            % Velocity [knots]
  h  = inputs.PerformanceInputs.hc;            % Altitude [ft]
  WS = inputs.PerformanceInputs.WS;
  AR = inputs.GeometryInputs.AR;
  nmax = inputs.PerformanceInputs.nmax;

  takeoff_parameter = (9-1129/20585)*1029250/35793;
  TWto = WSrange/takeoff_parameter/Cl_to;

  WSland = Cl_land/0.85/80*(9000-1000);
  
  [a,mu,rho] = AtmosphereFunction(h);
  v = V*1.68781;
  q = 0.5*rho*v^2;
  Cdo = ParasiteDragFunction(inputs);
  oswaldInputs = inputs;
  oswaldInputs.Aero.Cdo = Cdo;
  e0 = OswaldEfficiency(oswaldInputs);


  TWtoc = WFcruise/lapse*(q/WFcruise*(Cdo./WSrange+WSrange./pi./AR./e0*(nmax*WFcruise/q)^2)+100/60/v);
  
  TWmax=max([TWto,TWtoc]);
  TWmin=min([TWto,TWtoc]);

  plot(WSrange, TWto)
  hold on
  plot(WSrange, TWtoc)
  plot([WSland,WSland],[TWmin,TWmax])
  hold off
  grid on
  legend("Takeoff","Top of Climb","Landing","Location","best")
  xlabel("Wing Loading (lb/ft^2)")
  ylabel("Thrust to Weight Ratio")

  
%% See Raymer Ch. 17 to comptue other performance characteristics
%% See Raymer Ch. 16 to compute control and stability performance
