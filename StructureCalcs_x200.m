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
%1g
m = (10-4)/2;%wing effective lift
AUM = 10;
D0 = 27e-3; %root diameter
d0tip = 18e-3;
%taper
D = D0 + 0.2/1.351 *(d0tip - D0);
% D=0.044;

r = D/2;
t = 0.5e-3; %thickness
t = 1.25e-3; % two layers

m_bat = 2;
m_wing = 2;
J=2*pi*r^3*t;

As = pi*D*t/2;

L = 1325e-3; %semispan


%% At x=200mm (2nd rib bay)

%% longitudinal balance
%ref loads notes P5
ZH_ = 0.966;%TBC
ZM_ = 0.048;%TBC
ZM = 0.031; %TBC

P_HTP = -AUM*g* ZM_ /ZH_;
P_MWP = (AUM*g - P_HTP) - m_bat*g - m_wing*g;
P_W = P_MWP/2; %half wing effective lift

%% Deflection - WRONG - need to change to 2 elements
k = 1/8;

I = pi()*r^(3)*t; %second moment of area for thing wall tube
wing_tip_deflection = k*P_W*L^(3)/(limit_Ex*I);

%% Torsion 
M_aero = 0; %TBD from CM
M = P_W*D/2 + M_aero;
theta = M*(L-0.2)/limit_Gxy/J;

%stiffness limit to be determined

%% Direct Bending 
Q=P_W/L;
sigma = Q*(L^2-0.2^2)/2*r/I;
RF.sigma = limit_sigma_c/sigma;

%% Shear Stress 
tao = (P_W/L*(L-0.2)/As) + (M*r/J); %transverse + torsion
RF.tao = limit_tao/tao;

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
limit_sigma_cr = kb*limit_E * (t/b); %tbc v or vxy or vyx

RF.compression_buckling = limit_sigma_cr/sigma;

%shear buckling strength
limit_tao_cr = ks*limit_E * (t/b);

RF.shear_buckling = limit_tao_cr/tao;

%combined compression and shear 
FI_cr = 1/RF.compression_buckling + (1/RF.shear_buckling)^2;
RF.compression_shear_buckling_combined = 1/FI_cr;

