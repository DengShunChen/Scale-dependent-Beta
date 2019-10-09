               
% Runge-Kutta coefficients for Lorenz model II in 2005's paper
function [NEXT_Field]=L05_model_2(Field,prefix,timestep)

 X = Field; 
 [x1 x2]=model_derive_m02(prefix.K,X,prefix.resolution,prefix.index);
 k1=timestep.*(x1+x2+prefix.forcing);
                          
 X = Field + (k1/2.); 
 [x1 x2]=model_derive_m02(prefix.K,X,prefix.resolution,prefix.index);
 k2=timestep.*(x1+x2+prefix.forcing);

 X = Field + (k2/2.); 
 [x1 x2]=model_derive_m02(prefix.K,X,prefix.resolution,prefix.index);  
 k3=timestep.*(x1+x2+prefix.forcing);
                
 X = Field + k3; 
 [x1 x2]=model_derive_m02(prefix.K,X,prefix.resolution,prefix.index);               
 k4=timestep.*(x1+x2+prefix.forcing);
                          
 NEXT_Field = Field + (k1+(2*k2)+(2*k3)+k4)/6.;

