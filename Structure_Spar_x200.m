clear all
close all

%wing 

%% MISC
loadfactor = 9;
g = 9.81*loadfactor;
RF=struct();

%% factors
kd = 1.2; %material property knock down factor

%% material properties 
material = 'CFRP_90_0_10_percent'; %base tube

[limit,vxy,vyx,v_sqrt]= fngetproperties(material);


%% Geometry
getGeometry


%% At x=200mm (2nd rib bay)

%% Deflection - WRONG - need to change to 2 elements
k = 1/8;

I = pi()*r^(3)*t; %second moment of area for thing wall tube
wing_tip_deflection = k*P_W*L^(3)/(limit.Ex*I);

%% Torsion 
M_aero = 0; %TBD from CM
M = P_W*D/2 + M_aero;
theta = M*(L-0.2)/limit.Gxy/J;

%stiffness limit to be determined

%% Direct Bending 
Q=P_W/L;
sigma = Q*(L^2-0.2^2)/2*r/I;
RF.sigma = limit.sigma_c/sigma;

%% Shear Stress 
tao = (P_W/L*(L-0.2)/As) + (M*r/J); %transverse + torsion
RF.tao = limit.tao/tao;

%% Combined Direct + Shear stress
FI = (1/RF.sigma)^2 + 2*(1/RF.tao)^2;
RF.direct_shear_combined = 1/sqrt(FI);

%% Buckling Material Property
%ovelisation a=4D, b=pi*D/4, so a/b=5.1
a=4*D;
b=pi*D/4;
kb=0.5;
ks=0.075;

%compression buckling strength
limit.sigma_cr = kb*limit.E * (t/b); %tbc v or vxy or vyx

RF.compression_buckling = limit.sigma_cr/sigma;

%shear buckling strength
limit.tao_cr = ks*limit.E * (t/b);

RF.shear_buckling = limit.tao_cr/tao;

%combined compression and shear 
FI_cr = 1/RF.compression_buckling + (1/RF.shear_buckling)^2;
RF.compression_shear_buckling_combined = 1/FI_cr;

