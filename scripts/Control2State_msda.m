function [increment, control] = Control2State_msda(y_incs,Xp,prefix)

 index_s.l = 0*prefix.model.main.resolution+1:1*prefix.model.main.resolution ;
 index_s.s = 1*prefix.model.main.resolution+1:2*prefix.model.main.resolution ;
 
 index_e.l = prefix.model.main.resolution*(0*prefix.ensemblesize+2)+1:prefix.model.main.resolution*(1*prefix.ensemblesize+2) ;
 index_e.s = prefix.model.main.resolution*(1*prefix.ensemblesize+2)+1:prefix.model.main.resolution*(2*prefix.ensemblesize+2) ; 

 control.y.static.l = y_incs(index_s.l); 
 control.y.static.s = y_incs(index_s.s);

 control.y.ensemble.l = y_incs(index_e.l);
 control.y.ensemble.s = y_incs(index_e.s);

 [increment, control.x]=IncCal_msda(control.y,Xp,prefix);




