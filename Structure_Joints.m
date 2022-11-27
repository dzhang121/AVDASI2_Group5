clear all
close all

% joints to be calculated:
% fuselage to wing joint 
%     cleavage
%     flange bending
% wing to wing joint (centre bar)
%     bar bending
%     bar torsion
%     spar bearing
%     spar shear
%     spar cleavage
%     pin sheear
% 
% spar to spar - bonded joint

%% MISC
loadfactor = 9;
g = 9.81*loadfactor;
RF=struct();

%% factorst_bat
kd = 1.2; %material property knock down factor

%% material properties - centre bar
material = 'Ally_6082_T6'; %base tube

[limit,vxy,vyx,v_sqrt]= fngetproperties(material);

%% Geometry
getGeometry

%% Centre Bar
%pure bending
I = pi*(d_bar^4-d0_bar^4)/64;
sigma = P_W * L/2 * D/2 / I; % M*y/I
RF.bar_sigma = limit.sigma_x_c/sigma;

%% Bolt
%shear
P = P_W/2 + ( (P_W*(L+25e-3)/75e-3)+(P_W) /2); %P_AT + P_A /2 

tao_bolt = P/ (pi*(d_hole/2)^2);
RF.bolt_tao = 800e9/sqrt(3) / tao_bolt;

%% Spar
material = 'CFRP_90_0_10_percent'; %base tube
[limit,vxy,vyx,v_sqrt]= fngetproperties(material);

%bearing
P = P_W/2 + ( (P_W*(L+25e-3)/75e-3)+(P_W) /2); %P_AT + P_A /2 
sigma_br = P / t / d_hole; 
RF.spar_sigma_br = limit.sigma_br / sigma_br;

%tension
sigma_t = 3.0 * P / t / (3*d_hole);
RF.spar_sigma_t = limit.sigma_y_t / sigma_t;

%shear
tao = P/2/(2*d_hole)/t;
RF.spar_tao = limit.tao / tao;

%cleavage
sigma_y = P/2/(2*d_hole)*t;
RF.spar_sigma_cleavage = limit.sigma_y_t / sigma_y;

%% Spar to Spar bonding
%property for glue to be added
