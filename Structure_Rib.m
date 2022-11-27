clear all
close all

%rib load model - refer to Rib notes & Load notes P29
% 13 ribs in total, 2 at tip and root carry half loads compared to others
% therefore devide lift by 11*2+2 = 24
% Assume all ribs weigh 80g, ~4g each - negilible

%% MISC
loadfactor = 9;
g = 9.81*loadfactor;
RF=struct();

%% factors
kd = 1.2; %material property knock down factor

%% material properties 
material = 'Birch_3_CrossPly'; %base tube

[limit,vxy,vyx,v_sqrt]= fngetproperties(material);

%% Geometry
getGeometry

%% Rib Loads
Lift = P_W/24;


I = tw*bw^3/12+4*tf*bf*(bw_newton/2)^2;
As = tw*bw_newton;

%% Check Stiffness - strangely small, to be checked
k=1/8; %tbc
%bending deflection
vb_LE = k*Lift/4 * (c/12)^3 / I / limit.Ex;
vb_TE = k*Lift/4*3 * (c/4)^3 / I / limit.Ex;
%shear deflection
vs_LE = Lift/4 * c/12 / limit.Gxy / As;
vs_TE = Lift/4*3 * c/4 / limit.Gxy / As;

v_LE = vb_LE + vs_LE;
v_TE = vb_TE + vs_TE;

%% Check Strength
%bending stress
%checking trailing edge only as it's longer and carries more load
sigma = Lift*3/4 * c/4 * bw/2 / I * 1.03;
RF.sigma = min(limit.sigma_t,limit.sigma_c) / sigma;
%shear stress
tao = Lift*3/4 * 1.59 / As;
RF.tao = limit.tao/tao;
%combined stress for the unflanged panel web
FI = (1/RF.sigma)^2 + 2*(1/RF.tao)^2;
RF.direct_shear_combined = 1/sqrt(FI);

%% Check Stability
%unflanged panel web
kb = 24;
ks = 5.5;
limit.sigma_cr_web = kb*limit.E * (tw/bw)^2;
RF.compres_buckling_web = limit.sigma_cr_web/sigma;
limit.tao_cr_web = ks*limit.E * (tw/bw)^2;
RF.shear_buckling_web = limit.tao_cr_web/tao;

FI_cr = 1/RF.compres_buckling_web + (1/RF.shear_buckling_web)^2;
RF.cr_buckling_combined_web = 1/FI_cr;

%flange
limit.sigma_cr_flange = pi*pi*limit.E * (tf*(2*bf)^3/12) / (2*bf*tf) / (c/4*3)^2;
RF.compres_buckling_flange = limit.sigma_cr_flange/sigma;
