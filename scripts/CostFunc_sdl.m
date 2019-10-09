function Penalty = CostFunc_sdl(alpha,y_incs,d_y,Xp,prefix,innov,H)


 index_s.l = 0*prefix.model.main.resolution+1:1*prefix.model.main.resolution ;
 index_s.s = 1*prefix.model.main.resolution+1:2*prefix.model.main.resolution ;

 index_e.l = prefix.model.main.resolution*(0*prefix.ensemblesize+2)+1:prefix.model.main.resolution*(1*prefix.ensemblesize+2) ;
 index_e.s = prefix.model.main.resolution*(1*prefix.ensemblesize+2)+1:prefix.model.main.resolution*(2*prefix.ensemblesize+2) ;


 control.y.static.l = y_incs(index_s.l);
 control.y.static.s = y_incs(index_s.s);

 control.y.ensemble.l = y_incs(index_e.l);
 control.y.ensemble.s = y_incs(index_e.s);

  % static
  control.y.static.l = control.y.static.l + alpha*d_y(index_s.l);
  control.y.static.s = control.y.static.s + alpha*d_y(index_s.s);
 
 % ensemble 
  control.y.ensemble.l = control.y.ensemble.l + alpha*d_y(index_e.l);
  control.y.ensemble.s = control.y.ensemble.s + alpha*d_y(index_e.s);
 
 [increment, control.x]=IncCal_sdl(control.y,Xp,prefix);

 [Jb, Jo, Je] = CostFunc2_sdl(control.x,control.y,increment.total,innov,prefix.da.R_inv,H);

  Penalty = Jb + Jo + Je; 

