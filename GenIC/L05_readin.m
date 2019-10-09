
function [field, data t_init ]= L05_readin(prefix,file,obs)

%----------------------------------------------------------------------------------%
% Read in truth and the corresponding observations and its positions  
%----------------------------------------------------------------------------------%

 % Read in truth state
 fid=fopen(file.input.truth,'r');
 data.input.truth=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
 fclose(fid);

 % Read in observed data
 fid=fopen(file.input.obsdata,'r');
 data.input.obsdata=fscanf(fid,'%f',[obs.numbers Inf]);
 fclose(fid);

 % Read in observed positions
 fid=fopen(file.input.obsposi,'r');
 data.input.obsposi=fscanf(fid,'%d',[obs.numbers Inf]);
 fclose(fid);

%----------------------------------------------------------------------------------%
%   Initilized if not restart run
%----------------------------------------------------------------------------------%
 if strcmp(prefix.restart,'false')

  t_init = 1;
  % preparing in truth state
  field.truth=data.input.truth(:,t_init);

  % preparing in ensemble state
  %disp(['Generating probabilistic backgrund field for using ' prefix.da.system])
  disp(['Loading initial fields for using ' prefix.da.system])
  load(file.input.bckgd_ens)
  field.ensemble=ensemble(1:prefix.reduced_factor:prefix.model.main.resolution,1:prefix.ensemblesize);

  % preparing in background state
  %disp(['Generating deterministic backgrund field for using ' prefix.da.system])
  %ensemble_bar=mean(field.ensemble,2);
  load(file.input.bckgd)
  field.bckgd=bckgd;
  
%----------------------------------------------------------------------------------%
%   Initilized if restart run
%----------------------------------------------------------------------------------%
 elseif strcmp(prefix.restart,'truth')
  % Read in output data for checking
  fid=fopen(file.output.truth,'r');
  field.restart.truth=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
  fclose(fid);

  t_init=size(field.restart.truth,2)-4

  if  strcmp(prefix.da.system,'3DVAR') || strcmp(prefix.da.system,'3DHYB')
   % reading in analysis increment estimated static B      
   fid=fopen(file.output.xbinc,'r');
   field.restart.xbinc=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
   fclose(fid);

   % reading in analysis increment estimated ensemble B
   fid=fopen(file.output.xeinc,'r');
   field.restart.xeinc=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
   fclose(fid);

   % reading in background
   fid=fopen(file.output.bckgd.main,'r');
   field.restart.bckgd.main=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
   fclose(fid);

   % reading in analysis
   fid=fopen(file.output.analy.main,'r');
   field.restart.analy.main=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
   fclose(fid);
  end

  if  strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
   % reading in ensemble background
   fid=fopen(file.output.bckgd.ens,'r');
   field.restart.bckgd.ens = fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
   field.restart.bckgd.ens = ...
     reshape(field.restart.bckgd.ens,prefix.model.main.resolution,prefix.ensemblesize,[]);
   fclose(fid);

   % reading in ensemble analysis
   fid=fopen(file.output.analy.ens,'r');
   field.restart.analy.ens = fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
   field.restart.analy.ens = ...
     reshape(field.restart.analy.ens,prefix.model.main.resolution,prefix.ensemblesize,[]);
   fclose(fid);
  end
 end


