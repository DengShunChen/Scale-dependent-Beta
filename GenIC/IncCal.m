function [increment, x]=IncCal(y,Xp,prefix)

 % x.static
 x.static = prefix.da.beta1_inv * prefix.da.Bs * y.static;

 % x.ensemble
 y_ensemble = reshape(y.ensemble,[prefix.model.main.resolution prefix.ensemblesize]);
 x_ensemble = prefix.da.beta2_inv * prefix.da.L * y_ensemble;
 x.ensemble = reshape(x_ensemble,[prefix.model.main.resolution*prefix.ensemblesize 1]);

 % increment
 increment.static   = x.static ; 
 increment.ensemble = (Xp.*x_ensemble)*ones(prefix.ensemblesize,1);
 increment.total    = increment.static + increment.ensemble;
  

