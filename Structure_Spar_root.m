clear all
close all

%wing 

%% MISC
loadfactor = 9; %6*1.5
g = 9.81*loadfactor;

%% factors
kd = 1.2; %material property knock down factor

%% material properties 
material = 'CFRP_90_0_10_percent'; %base tube

[limit,vxy,vyx,v_sqrt]= fngetproperties(material);

%% Geometry
getGeometry

%overwrite and sweep spar tube wall thickness 
RF_table = table; %initiate result table

for n_reinforcement = 0:5

t=0.5e-3; %original thickness
t = t + 0.25e-3*n_reinforcement;

RF=struct();

%% At Root

%% Deflection
k = 1/8;

I = pi()*r^(3)*t; %second moment of area for thing wall tube
wing_tip_deflection = k*P_W*L^(3)/(limit.Ex*I);

%% Torsion 
M_aero = 0; %TBD from CM
M = P_W*D/2 + M_aero;
theta = M*L/limit.Gxy/J;

%stiffness limit to be determined

%% Direct Bending
sigma = P_W*L/2*r/I;
RF.sigma = limit.sigma_c/sigma;

%% Shear Stress
tao = (P_W/As) + (M*r/J); %transverse + torsion
RF.tao = limit.tao/tao;

%% Combined Direct + Shear
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

RF.compres_buckling = limit.sigma_cr/sigma;

%shear buckling strength
limit.tao_cr = ks*limit.E * (t/b);

RF.shear_buckling = limit.tao_cr/tao;

%combined compression and shear 
FI_cr = 1/RF.compres_buckling + (1/RF.shear_buckling)^2;
RF.compres_shear_cr_combined = 1/FI_cr;

temp = struct2table(RF);
temp.n_reinforcement = n_reinforcement;
RF_table = [RF_table; temp];
end

fnplot(RF_table);