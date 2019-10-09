function [increment, x]=IncCal_sdb(y,Xp,prefix)

 % x (for control)
 x.static   = prefix.da.Bs * y.static;
 x.ensemble = prefix.da.L  * reshape(y.ensemble,[prefix.model.main.resolution prefix.ensemblesize]);

 % y (for increment)
 increment.static   = x.static   ;
 increment.ensemble = reshape((Xp.*x.ensemble)*ones(prefix.ensemblesize,1),[prefix.model.main.resolution 1]) ; 

 [x] = ApplySDB(x,prefix) ;
 [increment] = ApplySDB(increment,prefix) ;

 % output
 x.ensemble = reshape(x.ensemble,[prefix.model.main.resolution*prefix.ensemblesize 1]);
 increment.total   	= increment.static + increment.ensemble;
 
 

