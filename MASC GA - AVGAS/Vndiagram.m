function Vndiagram(inputs)
nmax = inputs.PerformanceInputs.nmax;
nmin = inputs.PerformanceInputs.nmin;
CLmax = inputs.AeroInputs.CLmax;
CLmaxcruise=inputs.AeroInputs.CLmaxcruise;
CLmin = inputs.AeroInputs.CLmin;
CLalpha = inputs.AeroInputs.CLalpha;
hc = inputs.PerformanceInputs.hc;
Mcruise = inputs.PerformanceInputs.M;
Mmax = inputs.PerformanceInputs.Mmax;
WS = inputs.PerformanceInputs.WS;
Sw = inputs.GeometryOutput.Sw;
b = inputs.GeometryInputs.b;

missionnames = fieldnames(inputs.Missions);
Wmat = getfield(inputs.Missionoutputs, missionnames{1}).Wmat;

[a_cruise,mu_cruise,rho_cruise] = AtmosphereFunction(hc);
[a_sl,mu_sl,rho_sl] = AtmosphereFunction(0);
Vmin = 0;
Vcruise = a_cruise*Mcruise;
Vmax = a_cruise*Mmax;
V_stall_upper = sqrt(2/rho_sl*WS/CLmax);
V_stall_lower = sqrt(2/rho_sl*WS/abs(CLmin));
V_stall_cruise = sqrt(2*WS*(Wmat(3)/Wmat(1))/rho_cruise/CLmaxcruise);

Vrange = linspace(Vmin, Vmax*1.1, 100000);

n_plus = rho_cruise/2*1.668^2*Vrange.^2*CLmax/WS;
n_minus = rho_cruise/2*1.668^2*Vrange.^2*CLmin/WS;

n_upper_cutoff = 4;
n_lower_cutoff = -2;

n_plus_filtered=n_plus(1:find(n_plus<n_upper_cutoff,1, "last"));
n_minus_filtered=n_minus(1:find(n_minus>n_lower_cutoff,1, "last"));

VAplus=sqrt(nmax/rho_cruise*2/1.668^2*WS/CLmax);
VAminus=sqrt(nmin/rho_cruise*2/1.668^2*WS/CLmin);

cbar = Sw/b;
mu = 2*WS/rho_cruise/32.17/cbar/CLalpha;
K = 0.88*mu/(5.3+mu);
U = (25-50)/(50000-20000)*(hc-20000)+50;
ng = 1+K*U*Vcruise*sqrt(rho_cruise/rho_sl)*CLalpha/498/WS;
VB = V_stall_cruise*sqrt(ng);

plus_start = find(Vrange>V_stall_upper,1, "first");
plus_end = find(n_plus<nmax,1, "last");
n_plus_intersect = n_plus(plus_start:plus_end);
V_plus_intersect = Vrange(plus_start:plus_end);

minus_start = find(Vrange>V_stall_lower,1, "first");
minus_end = find(n_minus>nmin,1, "last");
n_minus_intersect = n_minus(minus_start:minus_end);
V_minus_intersect = Vrange(minus_start:minus_end);

n_contour = [n_plus_intersect, nmax, nmin, fliplr(n_minus_intersect), 0, 0, n_plus_intersect(1)];
V_contour = [V_plus_intersect, Vmax, Vmax, fliplr(V_minus_intersect), V_stall_lower, V_stall_upper, V_stall_upper];

figure(21)
plot([Vmin, Vmax*1.1], [nmax,nmax])

hold on
plot([Vmin, Vmax*1.1], [nmin,nmin])
plot([Vcruise, Vcruise], [n_lower_cutoff, n_upper_cutoff])
plot([Vmax, Vmax], [n_lower_cutoff, n_upper_cutoff])
plot([VAplus, VAplus], [0, n_upper_cutoff])
plot([VAminus, VAminus], [n_lower_cutoff, 0])
plot([VB, VB], [0, n_upper_cutoff])

plot(Vrange(1:find(n_minus>n_lower_cutoff,1, "last")), n_minus_filtered)
plot(Vrange(1:find(n_plus<n_upper_cutoff,1, "last")), n_plus_filtered)

plot([Vmin, Vmax*1.1], [0,0], "k")
plot(V_contour, n_contour, "k", "LineWidth", 3)
hold off

legend("n_{max}", "n_{min}", "V_C", "V_D", "V_A", "V_{A-}", "V_B", "Location","northwest")
xlabel("Velocity [ft/s]")
ylabel("Load Factor, n")
title("Load Factor vs. Velocity")

