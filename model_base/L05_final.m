
% Open output data file and input data
 fclose(fid1);
 fclose(fid4a);
 fclose(fid4b);
 if strcmp(prefix.da.system,'3DVAR') || strcmp(prefix.da.system,'3DHYB')
  % open output files
  fclose(fid2a);
  fclose(fid2b);
  fclose(fid5a);
  fclose(fid5b);
 end
 if strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
  % open output files
  fclose(fid3a);
  fclose(fid3b);
 end

