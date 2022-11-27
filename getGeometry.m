%% Geometry
%1g
m = (10-4)/2;%wing effective lift
AUM = 10;
D0 = 27e-3; %root diameter
d0tip = 18e-3;
%taper
D = D0;

r = D/2;
t = 0.5e-3; %thickness
t = 1.25e-3; % two layers

r = D/2;
m_bat = 2;
m_wing = 2;
J=2*pi*r^3*t;

As = pi*D*t/2;

L = 1325e-3; %semispan

%% longitudinal balance
%ref loads notes P5
ZH_ = 0.966;%TBC
ZM_ = 0.048;%TBC
ZM = 0.031; %TBC

P_HTP = -AUM*g* ZM_ /ZH_;
P_MWP = (AUM*g - P_HTP) - m_bat*g - m_wing*g;
P_W = P_MWP/2; %half wing effective lift

%% Rib
c=300e-3; %chord
thickness = 0.15;

bw = c*thickness*0.8; %rib height, scaled by 0.8 of aerofoil thickness
tw = 1.5e-3; %rib thickness
bf = 3e-3; %flange for I beam equivalence
tf = 3e-3;

bw_newton = bw-tf; %length w.r.t to mid point of flange, bw'
