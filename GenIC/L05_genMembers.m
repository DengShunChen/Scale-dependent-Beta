
 L05_namelist;

 % Initialization of Model Variables
 [field, data t_ini] = L05_readin(prefix,file,obs)

 L05_cycle_GenMem;

 truth = field.truth 
 bckgd = field.bckgd
 ensemble = field.ensemble

% Saving files  
 save('data_genmem_truth_M03.mat','truth')
 save('data_genmem_bckgd_M03.mat','bckgd')
 save('data_genmem_bck_ens_M03_m200.mat','ensemble')
