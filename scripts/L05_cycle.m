
% Begin time cycle portion of the code
 for t=1:prefix.model.maxtime

   % set background if below the restart time 
   if strcmp(prefix.restart,'truth')
     if t<=t_ini
       if strcmp(prefix.da.system,'3DVAR') || strcmp(prefix.da.system,'3DHYB')
         field.bckgd=field.restart.bckgd.main(:,t) ;
       end
       if strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
         field.ensemble=field.restart.bckgd.ens(:,:,t) ;
       end
     end 
   end

   % Write out background to text files 
   if strcmp(prefix.da.system,'3DVAR') || strcmp(prefix.da.system,'3DHYB')
     fprintf(fid2b, '%10.6f',field.bckgd );
   end
   if strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
     fprintf(fid3b, '%10.6f', field.ensemble);
   end

   % set and write out the Truth
   field.truth=data.input.truth(:,t);   
   fprintf(fid1, '%10.6f', field.truth);
   
   % set and write out the Observed Data
   obs.values=data.input.obsdata(:,t);   
   fprintf(fid4a, '%10.6f', obs.values);

   % set and write out the Observed Positions
   obs.positions=data.input.obsposi(:,t);      
   fprintf(fid4b, '%4i', obs.positions);

   % Analysis System
   if t<t_ini
     if strcmp(prefix.da.system,'3DVAR') || strcmp(prefix.da.system,'3DHYB')
       field.bckgd=field.restart.analy.main(:,t);
       xb_inc=field.restart.xbinc(:,t);
       xe_inc=field.restart.xeinc(:,t);
     end
     if strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
       field.ensemble=field.restart.analy.ens(:,:,t);
     end
   else       
     if strcmp(prefix.da.system,'3DVAR') || strcmp(prefix.da.system,'3DHYB')
       if mod(t,prefix.da.assim_bin.main) == 0   
         if strcmp(prefix.da.type,'sdl')
           [field.bckgd,xb_inc,xe_inc]=da_3dvar_drive_sdl(field,obs,prefix);
         elseif strcmp(prefix.da.type,'sdb')
           [field.bckgd,xb_inc,xe_inc]=da_3dvar_drive_sdb(field,obs,prefix);
         elseif strcmp(prefix.da.type,'msda')
           [field.bckgd,xb_inc,xe_inc]=da_3dvar_drive_msda(field,obs,prefix);
         else
           [field.bckgd,xb_inc,xe_inc]=da_3dvar_drive(field,obs,prefix);
         end
       else
         xb_inc=zero;  xe_inc=zero;
       end
     end
     if strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
       if mod(t,prefix.da.assim_bin.ens) == 0   
         field.ensemble=da_letkf_drive(field,obs,prefix);
       end
     end
   end

   % Write out analysis to text files 
   if strcmp(prefix.da.system,'3DVAR') || strcmp(prefix.da.system,'3DHYB')
     fprintf(fid2a, '%10.6f', field.bckgd);
     fprintf(fid5a, '%10.6f', xb_inc);
     fprintf(fid5b, '%10.6f', xe_inc);
   end
   if strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
     xb_bar = mean(field.ensemble,2);
     xb_bar_m = repmat(xb_bar,1,prefix.ensemblesize);
     Xb = field.ensemble - xb_bar_m;
     XbSpread = mean(std(Xb,0,2)) ;
     fprintf(prefix.fid7, '%10.6f',XbSpread );

     fprintf(fid3a, '%10.6f', field.ensemble);
   end

   if t<t_ini
    disp(['read model data from time ' num2str(t) ' to ' num2str(t+1)])
   else
    % Forward model 
    disp(['model integral from time ' num2str(t) ' to ' num2str(t+1)])
    [field] = L05_update(field,prefix.model,prefix.ensemblesize,prefix.da.system);
   end
 end

