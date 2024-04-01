function PerformanceFunction(inputs)
  steps = 500;
  WSrange=linspace(90,200,steps);
  carpetWSvariance = 0.2;
  carpetTWvariance = 0.2;
  skewOffset = 4;
  skewcenter = [0,0];

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
  num_eng = inputs.PropulsionInputs.num_eng;           % number of engines

  if num_eng==2
    takeoff_parameter = (9+12759/73945)*160750/6693;
  elseif num_eng==4
    takeoff_parameter = (9-1129/20585)*1029250/35793;
  elseif num_eng==6
    takeoff_parameter = (9-747151/2647231)*661807750/18474717;
  else
    fprintf("Number of engines is not supported\n")
  end
  TWto = WSrange/takeoff_parameter/Cl_to;

  WSland = Cl_land/0.85/80*(9000-1000);
  
  [~,~,rho] = AtmosphereFunction(h);
  v = V*1.68781;
  q = 0.5*rho*v^2;
  Cdo = ParasiteDragFunction(inputs);
  oswaldInputs = inputs;
  oswaldInputs.Aero.Cdo = Cdo;
  e0 = OswaldEfficiency(oswaldInputs);
  TWtoc = WFcruise/lapse*(q/WFcruise*(Cdo./WSrange+WSrange./pi./AR./e0*(WFcruise/q)^2)+100/60/v);
  
  TWmax=max([TWto,TWtoc]);
  TWmin=min([TWto,TWtoc]);

  figure(1)
  plot(WSrange, TWto)
  hold on
  plot(WSrange, TWtoc)
  plot([WSland,WSland],[TWmin,TWmax])
  hold off
  grid on
  legend("Takeoff","Top of Climb","Landing","Location","best")
  xlabel("Wing Loading (lb/ft^2)")
  ylabel("Thrust to Weight Ratio")

  centerTW = inputs.PerformanceInputs.TW;
  centerWS = inputs.PerformanceInputs.WS;
  inputs = rmfield(inputs, "EmptyWeight");

  inputs.PerformanceInputs.TW = TWto;
  inputs.PerformanceInputs.WS = WSrange;
  W0to = GeneralSizingFunction(inputs);

  inputs.PerformanceInputs.TW = TWtoc;
  inputs.PerformanceInputs.WS = WSrange;
  W0toc = GeneralSizingFunction(inputs);

  inputs.PerformanceInputs.TW = linspace(TWmin, TWmax, steps);
  inputs.PerformanceInputs.WS = WSland*ones(1,steps);
  W0land = GeneralSizingFunction(inputs);

  linspaceRangeOffset = mod(steps,2)-1;
  TWstep = centerTW * carpetTWvariance;
  TWmin = centerTW - TWstep;
  TWmax = centerTW + TWstep;
  WSstep = centerWS * carpetWSvariance;
  WSmin = centerWS - WSstep;
  WSmax = centerWS + WSstep;

  inputs.PerformanceInputs.TW = linspace(TWmin, TWmax, steps+linspaceRangeOffset);
  inputs.PerformanceInputs.WS = WSmax;
  WSWSp = WSmax * ones(1, steps+linspaceRangeOffset);
  W0WSp = GeneralSizingFunction(inputs);

  inputs.PerformanceInputs.TW = linspace(TWmin, TWmax, steps+linspaceRangeOffset);
  inputs.PerformanceInputs.WS = centerWS;
  WSWSc = centerWS * ones(1, steps+linspaceRangeOffset);
  W0WSc = GeneralSizingFunction(inputs);

  inputs.PerformanceInputs.TW = linspace(TWmin, TWmax, steps+linspaceRangeOffset);
  inputs.PerformanceInputs.WS = WSmin;
  WSWSm = WSmin * ones(1, steps+linspaceRangeOffset);
  W0WSm = GeneralSizingFunction(inputs);

  inputs.PerformanceInputs.TW = TWmax;
  inputs.PerformanceInputs.WS = linspace(WSmin, WSmax, steps+linspaceRangeOffset);
  WSTWp = inputs.PerformanceInputs.WS;
  W0TWp = GeneralSizingFunction(inputs);

  inputs.PerformanceInputs.TW = centerTW;
  inputs.PerformanceInputs.WS = linspace(WSmin, WSmax, steps+linspaceRangeOffset);
  WSTWc = inputs.PerformanceInputs.WS;
  W0TWc = GeneralSizingFunction(inputs);

  inputs.PerformanceInputs.TW = TWmin;
  inputs.PerformanceInputs.WS = linspace(WSmin, WSmax, steps+linspaceRangeOffset);
  WSTWm = inputs.PerformanceInputs.WS;
  W0TWm = GeneralSizingFunction(inputs);

  WSint = [WSmax, centerWS, WSmin, WSmax, centerWS, WSmin, WSmax, centerWS, WSmin];
  W0int = [W0TWp(end), W0TWp(steps/2), W0TWp(1), W0TWc(end), W0TWc(steps/2), W0TWc(1), W0TWm(end), W0TWm(steps/2), W0TWm(1)];
  % WSTWp(steps/2)

  figure(2)
  plot(WSrange, W0to)
  hold on
  plot(WSrange, W0toc)
  plot(WSland*ones(steps), W0land)

  plot(WSWSp, W0WSp)
  plot(WSWSc, W0WSc)
  plot(WSWSm, W0WSm)
  plot(WSTWp, W0TWp)
  plot(WSTWc, W0TWc)
  plot(WSTWm, W0TWm)

  plot(WSint, W0int, " ob")
  hold off
  grid on
  legend("Takeoff","Top of Climb","Landing", "WS="+num2str(WSmax), "WS="+num2str(centerWS), "WS="+num2str(WSmin), "TW="+num2str(TWmax), "TW="+num2str(centerTW), "TW="+num2str(TWmin),"Location","best")
  xlabel("Wing Loading (lb/ft^2)")
  ylabel("Takeoff Weight (lbs)")
  title("Carpet Plot Unskewed")

  if skewcenter(2) == 0
      offset = -skewOffset;
  elseif skewcenter(2) == 1
      offset = -2*skewOffset;
  end



  figure(3)
  plot(WSrange, W0to)
  hold on
  plot(WSrange, W0toc)
  plot(WSland*ones(steps), W0land)

  ws = warning('off','all');
  coeffs = polyfit([W0TWm(end), W0TWc(end), W0TWp(end)], [offset, skewOffset + offset, 2*skewOffset + offset], 2);
  offsets = polyval(coeffs, W0WSp);
  plot(WSWSp+offsets, W0WSp)

  coeffs = polyfit([W0TWm(steps/2), W0TWc(steps/2), W0TWp(steps/2)], [offset, skewOffset + offset, 2*skewOffset + offset], 2);
  offsets = polyval(coeffs, W0WSc);
  plot(WSWSc+offsets, W0WSc)

  coeffs = polyfit([W0TWm(1), W0TWc(1), W0TWp(1)], [offset, skewOffset + offset, 2*skewOffset + offset], 2);
  offsets = polyval(coeffs, W0WSm);
  plot(WSWSm+offsets, W0WSm)
  warning(ws)

  plot(WSTWp + 2*skewOffset + offset, W0TWp)
  plot(WSTWc + skewOffset + offset, W0TWc)
  plot(WSTWm + offset, W0TWm)

  plot([WSint(1:3) + 2*skewOffset + offset, WSint(4:6) + skewOffset + offset, WSint(7:9) + offset], W0int, " ob")
  hold off
  grid on
  legend("Takeoff","Top of Climb","Landing", "WS="+num2str(WSmax), "WS="+num2str(centerWS), "WS="+num2str(WSmin), "TW="+num2str(TWmax), "TW="+num2str(centerTW), "TW="+num2str(TWmin),"Location","best")
  xlabel("Wing Loading (lb/ft^2)")
  ylabel("Takeoff Weight (lbs)")
  title("Carpet Plot Unskewed")


  
%% See Raymer Ch. 17 to comptue other performance characteristics
%% See Raymer Ch. 16 to compute control and stability performance
