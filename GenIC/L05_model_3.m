               
% Runge-Kutta coefficients for Lorenz model III in 2005's paper
function [NEXT_Field]=L05_model_3(Field,prefix,timestep)

 if strcmp(prefix.sppt,'true')
   F=prefix.forcing*randn ;
 else
   F=prefix.forcing ;
 end

 [X Y]=model_calxy(prefix.I,Field,prefix.resolution,prefix.index);                
 [x1 x2 x3 x4 x5]=model_derive_m03(prefix.K,X,Y,prefix.resolution,prefix.index,prefix.b,prefix.c);
 k1=timestep.*(x1+x2+x3+x4+x5+F);
                          
 [X Y]=model_calxy(prefix.I,Field+(k1/2.),prefix.resolution,prefix.index);               
 [x1 x2 x3 x4 x5]=model_derive_m03(prefix.K,X,Y,prefix.resolution,prefix.index,prefix.b,prefix.c);
 k2=timestep.*(x1+x2+x3+x4+x5+F);

 [X Y]=model_calxy(prefix.I,Field+(k2/2.),prefix.resolution,prefix.index);                
 [x1 x2 x3 x4 x5]=model_derive_m03(prefix.K,X,Y,prefix.resolution,prefix.index,prefix.b,prefix.c);  
 k3=timestep.*(x1+x2+x3+x4+x5+F);
                
 [X Y]=model_calxy(prefix.I,Field+k3,prefix.resolution,prefix.index);                
 [x1 x2 x3 x4 x5]=model_derive_m03(prefix.K,X,Y,prefix.resolution,prefix.index,prefix.b,prefix.c);               
 k4=timestep.*(x1+x2+x3+x4+x5+F);
                          
 NEXT_Field = Field + (k1+(2*k2)+(2*k3)+k4)/6.;

