function [increment, control] = Control2State_sdb(y_incs,Xp,prefix)

 index_s = 0*prefix.model.main.resolution+1:1*prefix.model.main.resolution ;
 index_e = prefix.model.main.resolution*(0*prefix.ensemblesize+1)+1:prefix.model.main.resolution*(1*prefix.ensemblesize+1) ;

 control.y.static   = y_incs(index_s); 
 control.y.ensemble = y_incs(index_e);

 [increment, control.x]=IncCal_sdb(control.y,Xp,prefix);




