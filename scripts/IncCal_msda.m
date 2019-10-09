function [increment, x]=IncCal_msda(y,Xp,prefix)

 % x.static
 x.static.l = prefix.da.beta1_inv.l * prefix.da.Bs.l * y.static.l;
 x.static.s = prefix.da.beta1_inv.s * prefix.da.Bs.s * y.static.s;

 % x.ensemble
 y_ensemble.l = reshape(y.ensemble.l,[prefix.model.main.resolution prefix.ensemblesize]);
 y_ensemble.s = reshape(y.ensemble.s,[prefix.model.main.resolution prefix.ensemblesize]);

 x_ensemble.l = prefix.da.beta2_inv.l * prefix.da.L.l * y_ensemble.l;
 x_ensemble.s = prefix.da.beta2_inv.s * prefix.da.L.s * y_ensemble.s;

 x.ensemble.l = reshape(x_ensemble.l,[prefix.model.main.resolution*prefix.ensemblesize 1]);
 x.ensemble.s = reshape(x_ensemble.s,[prefix.model.main.resolution*prefix.ensemblesize 1]);


 % increment 
 increment.static.l = x.static.l ; 
 increment.static.s = x.static.s ;

 increment.ensemble.l = (Xp.l.*x_ensemble.l)*ones(prefix.ensemblesize,1);
 increment.ensemble.s = (Xp.s.*x_ensemble.s)*ones(prefix.ensemblesize,1);

 increment.static.total  = increment.static.l  + increment.static.s;
 increment.ensemble.total = increment.ensemble.l + increment.ensemble.s;
 increment.total   = increment.static.total + increment.ensemble.total;
  

