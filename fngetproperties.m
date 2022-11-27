function [limit,vxy,vyx,v_sqrt]= fngetproperties(strname)


%% factors
kd = 1.2; %material property knock down factor

%read file
T= readtable('material_properties.csv');

%find row
row = find(strcmp(T.Name,strname));
if length(row)>1
    disp('error - more than 1 row of material properties matched')
end

%% extract material properties 
limit = struct;
%modulus
limit.Ex=T.Ex(row);
limit.Ey=T.Ey(row);
limit.Ex_c=T.Ex_c(row);
if ~isnan(T.Ex_c(row))
    disp('Ex_c exists')
end
limit.E=sqrt(limit.Ex*limit.Ey);

limit.Gxy=T.Gxy(row);

vxy=T.Vxy(row); %poisson
vyx=T.Vyx(row); %poisson
v_sqrt=sqrt(vxy*vyx);

%strength
limit.sigma_t = T.sigma_x_t(row); %tensile yield strength - x by default
limit.sigma_c = T.sigma_x_c(row); %compressive yield strength - x by default
limit.sigma_x_t = T.sigma_x_t(row); %tensile yield strength
limit.sigma_x_c = T.sigma_x_c(row); %compressive yield strength
limit.sigma_y_t = T.sigma_y_t(row); %tensile yield strength
limit.sigma_y_c = T.sigma_y_c(row);

limit.tao = T.tao(row); %shear strength
limit.sigma_br = T.sigma_br(row); %bearing ??? to be confirmed

%pin - to be added

%knock down
limit.E = limit.E/kd;
limit.Ex = limit.Ex/kd;
limit.Ey = limit.Ey/kd;
limit.Ex_c = limit.Ex_c/kd;
limit.Gxy=limit.Gxy/kd;

limit.sigma_t = limit.sigma_t/kd;
limit.sigma_c = limit.sigma_c/kd;
limit.sigma_x_t = limit.sigma_x_t/kd;
limit.sigma_x_c = limit.sigma_x_c/kd;
limit.sigma_y_t = limit.sigma_y_t/kd;
limit.sigma_y_c = limit.sigma_y_c/kd;
limit.sigma_sqrt = sqrt(limit.sigma_x_t*limit.sigma_y_c);
limit.sigma_sqrt_x = sqrt(limit.sigma_x_t*limit.sigma_x_c);
limit.sigma_sqrt_y = sqrt(limit.sigma_y_t*limit.sigma_y_c);
limit.tao = limit.tao/kd;
limit.sigma_br = limit.sigma_br/kd;


end