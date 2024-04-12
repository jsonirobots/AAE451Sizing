function Vndiagram(inputs)
nmax = inputs.PerformanceInputs.nmax;
nmin = inputs.PerformanceInputs.nmin;
CLmax = inputs.AeroInputs.CLmax;
CLmin = inputs.AeroInputs.CLmin;
CLalpha = inputs.AeroInputs.CLalpha;
hc = inputs.PerformanceInputs.hc;
Mcruise = inputs.PerformanceInputs.M;
Mmax = inputs.PerformanceInputs.Mmax;
WS = inputs.PerformanceInputs.WS;
Sw = inputs.GeometryOutput.Sw;
b = inputs.GeometryInputs.b;

[a_cruise,mu_cruise,rho_cruise] = AtmosphereFunction(hc);
[a_sl,mu_sl,rho_sl] = AtmosphereFunction(0);
Vmin = 0;
Vcruise = a_cruise*Mcruise;
Vmax = a_cruise*Mmax;

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
U = (38-66)/(50000-20000)*(hc-20000)+66;
VS = VAplus/sqrt(nmax);
VB = VS*sqrt(1+K*U*Vcruise*CLalpha/498/WS);

n_plus_intersect = n_plus(1:find(n_plus<nmax,1, "last"));
V_plus_intersect = Vrange(1:find(n_plus<nmax,1, "last"));
n_minus_intersect = n_minus(1:find(n_minus>nmin,1, "last"));
V_minus_intersect = Vrange(1:find(n_minus>nmin,1, "last"));

n_contour = [n_plus_intersect, nmax, nmin, fliplr(n_minus_intersect)];
V_contour = [V_plus_intersect, Vmax, Vmax, fliplr(V_minus_intersect)];

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

legend("n_{max}", "n_{min}", "V_C", "V_D", "V_A", "V_{A-}", "V_B", "Location","best")

