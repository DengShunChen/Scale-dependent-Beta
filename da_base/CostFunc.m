function Penalty = CostFunc(alpha,y_incs,d_y,Xp,prefix,innov,H)

 index_s = 0*prefix.model.main.resolution+1:1*prefix.model.main.resolution ;
 index_e = prefix.model.main.resolution*(0*prefix.ensemblesize+1)+1:prefix.model.main.resolution*(1*prefix.ensemblesize+1) ;

 control.y.static   = y_incs(index_s);
 control.y.ensemble = y_incs(index_e);

  % static
  control.y.static   = control.y.static   + alpha*d_y(index_s); 
  % ensemble 
  control.y.ensemble = control.y.ensemble + alpha*d_y(index_e);
 
 [increment, control.x]=IncCal(control.y,Xp,prefix);

 [Jb Jo Je] = CostFunc2(control.x,control.y,increment.total,innov,prefix.da.R_inv,H);

  Penalty = Jb + Jo + Je; 

