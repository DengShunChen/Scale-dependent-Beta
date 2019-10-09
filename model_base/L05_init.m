
% Initialization of Model Variables
 [field, data t_ini] = L05_readin(prefix,file,obs)

% delete previous file
 delete(file.output.truth);
 delete(file.output.obsdata);
 delete(file.output.obsposi);

% Open output data file and input data
 fid1 = fopen(file.output.truth, 'a');
 fid4a = fopen(file.output.obsdata, 'a');
 fid4b = fopen(file.output.obsposi, 'a');
 if strcmp(prefix.da.system,'3DVAR') || strcmp(prefix.da.system,'3DHYB')
  % delete previous file
  delete(file.output.analy.main)
  delete(file.output.bckgd.main)
  delete(file.output.xbinc)
  delete(file.output.xeinc)
  % open output files
  fid2a = fopen(file.output.analy.main, 'a');
  fid2b = fopen(file.output.bckgd.main, 'a');
  fid5a = fopen(file.output.xbinc, 'a');
  fid5b = fopen(file.output.xeinc, 'a');
 end
 if strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
  % delete previous file
  delete(file.output.analy.ens)
  delete(file.output.bckgd.ens)
  % open output files
  fid3a = fopen(file.output.analy.ens, 'a');
  fid3b = fopen(file.output.bckgd.ens, 'a');
 end

