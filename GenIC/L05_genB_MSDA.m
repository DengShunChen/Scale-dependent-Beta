
clc; 
clear all;

% configuration
 L05_config

 prefix.model.maxtime         = 5000;
%-----------------------------------------------------------------------------------%


% Read in initial truth state (spin up) 
 load(file_Init_Truth);

% Begin time cycle portion of the code
 for t=1:prefix.model.maxtime
   disp(['model integral from time ' num2str(t-1) ' to ' num2str(t)])
   truth = L05_model_3(truth,prefix.model.main,prefix.model.timestep);

   X(:,t)=truth;   
 end

 nsamp = size(X,2); disp(['number of samples: ' int2str(nsamp)])
 % ensemble mean
 xm = mean(X,2);
 % remove the mean from teh ensemble (XbM is a matrix version of xbm)
 [tmp Xm] = meshgrid(ones(nsamp,1),xm);
 Xp = X - Xm;
 
 [ XpM ] = SpectDecom(Xp,prefix.model.main.resolution);
 Bs_l = XpM.l*XpM.l'/(nsamp-1);
 Bs_s = XpM.s*XpM.s'/(nsamp-1);

% option to save B to disk for use with DA experiments
 if prefix.model.main.I==1
%save L05_climo_B_1_MSDA.mat Bs_l Bs_s
   save L05_climo_B_1_MSDA_new.mat Bs_l Bs_s
 elseif  prefix.model.main.I==12
%save L05_climo_B_12_MSDA.mat Bs_l Bs_s
   save L05_climo_B_12_MSDA_new.mat Bs_l Bs_s
 end
