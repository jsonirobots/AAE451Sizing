% base aircraft parameter file
folder = "airplanes/";
filenm = "An225_params";
run(folder+filenm);
plane = an225;

% specify how much to vary TWR and W/S by
varyTWR = 0.1;
varyWS = 10;
stencilpts = 3; % of pts around nominal design point
midpt = (stencilpts+1)/2;

baseTWR = plane.TWR - varyTWR*(stencilpts-1)/2;
baseWS = plane.wing.WS - varyWS*(stencilpts-1)/2;

W0s = zeros(stencilpts,stencilpts);
WSs = zeros(stencilpts,stencilpts);
TWRs = zeros(1,stencilpts);

%f = waitbar(0,"Carpet Plot");
% this loop sizes an aircraft with each iteration varying the T/W and W/S
% from the sizing output, W0 and W/S are stored for carpet plot
for i=1:stencilpts
    for j=1:stencilpts
        plane.TWR = baseTWR + (i-1)*varyTWR;
        plane.wing.WS = baseWS + (j-1)*varyWS;
        [out,plane] = sizeAirplane(plane,1200e3,0);
        W0s(i,j) = plane.W0max;
        WSs(i,j) = plane.wing.WS;
        TWRs(i) = plane.TWR;
        if(i==midpt && j==midpt)
            origPlane = plane;
        end
        %waitbar(((i-1)+j)/stencilpts^2,f,"Carpet Plot");
    end
end
%close(f);

%WS = linspace(baseWS-varyWS,baseWS+varyWS*stencilpts,50);
WS = linspace(20,200,50);
cons = constraints(origPlane,WS,out.Wfracs); % constraint function
correction = 0.84;
conW01 = origPlane.TWR*origPlane.W0max./(cons.TOC.TWR.*correction); % T/W0 * W0 = T; T/(T/W) = W
conW02 = origPlane.TWR*origPlane.W0max./(cons.TO.TWR);

figure; % constraint diagram plot
co = ["m" "m" "r" "b"];
transparency = 0.3;
colororder(co);
area([cons.land.WS,max(WS)],[1 1],LineWidth=1,FaceAlpha=transparency,LineStyle='--');
hold on; grid on;
plot(cons.land.WS.*[1,1],[0 1],LineWidth=2,LineStyle='--');
area(WS,cons.TOC.TWR.*correction,LineWidth=2,FaceAlpha=transparency,EdgeColor=co(3),LineStyle='--');
area(WS,cons.TO.TWR,LineWidth=2,FaceAlpha=transparency,EdgeColor=co(4),LineStyle='--');
plot(an225.wing.WS,an225.TWR,'kO',LineWidth=4);
ylim([0 1.0]);
legend(["LD" "LD" "TOC" "TO" "AN-225"],Location="northwest");
xlabel("W0 / S [lb/ft^2]");
ylabel("T / W0");

figure; % carpet plot
colororder(["r" "b" "m" "g" "k" "c"]);
plot(WSs,W0s,'-O',LineWidth=2);
hold on;
plot(WSs',W0s','-O',LineWidth=2);
grid on;
plot(WS,conW01,'b--');
plot(WS,conW02,'k--');
plot(cons.land.WS.*[1,1],[1e6,2e6],'m--');
xlim([baseWS-varyWS,baseWS+varyWS*stencilpts]);
legend(["W/S = "+WSs(1,:),"T/W = "+TWRs,"TOC","TO","LD"],Location="best");
xlabel("W0 / S [lb/ft^2]");
ylabel("W0 [lbs]");
