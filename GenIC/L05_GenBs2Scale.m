clear all;

% Initialization of Model Variables
 prefix.expname='GenBs2Scale';
%------------------------------------------------------------

 prefix.model.maxtime		= 5000;

 prefix.reduced_factor		= 2;		% reduced resolution of ensemble 
 prefix.ensemblesize		= 10;

 prefix.model.reduced_factor	= prefix.reduced_factor; 

 % main analysis
 prefix.model.main.resolution	= 960;
 prefix.model.main.I		= 12;
 prefix.model.main.K		= prefix.model.main.resolution/30;
 prefix.model.main.b		= 10.;          %  Lorez96_model_III
 prefix.model.main.c		= 2.5;          %  Lorez96_model_III
 prefix.model.main.forcing	= 15.0;

 % ensemble 
 prefix.model.ens.resolution	= prefix.model.main.resolution / prefix.reduced_factor;
 prefix.model.ens.I		= prefix.model.main.I / prefix.reduced_factor;
 prefix.model.ens.K		= prefix.model.ens.resolution/30;
 prefix.model.ens.b		= 10.;          %  Lorez96_model_III
 prefix.model.ens.c		= 2.5;          %  Lorez96_model_III
 prefix.model.ens.forcing	= 15.0;

% observation
 if prefix.model.main.I==1
   prefix.model.timestep	= 0.025;
   observation_error=2.0;
   obs_percent=(1/24)*100;
 elseif  prefix.model.main.I==12
   prefix.model.timestep	= 0.0025;
   obs_error=0.3;
   obs_percent=(1/8)*100;
 else
   disp('Not a good model settings !!')
 end

%------------------------------------------------------------

 datapath='../../'

 % Define file name
 file.input.ColdStart	=['data_ColdStart.mat'];

 % Load array in
 load(file.input.ColdStart)

%----------------------------------------------------------------------------------%
 zero=zeros(prefix.model.main.resolution,1);
 prefix.model.main.index = [1:prefix.model.main.resolution]';
 prefix.model.ens.index = [1:prefix.model.ens.resolution]';
 prefix.model.ens.bins  = [1:prefix.reduced_factor:prefix.model.main.resolution]';
%----------------------------------------------------------------------------------%
% Begin time cycle portion of the code
 for t=1:prefix.model.maxtime
 
   % Forward model 
    disp(['model integral from time ' num2str(t) ' to ' num2str(t+1)])
    field.truth=L05_model_3(field.truth,prefix.model.main,prefix.model.timestep);
    X(:,t)=field.truth;
     
 end

 ensemble_h=X(:,1:20:end);
 nsamp = size(ensemble_h,2); disp(['number of samples: ' int2str(nsamp)])

 % ensemble mean
 xb_bar = mean(ensemble_h,2);
 xb_bar_m = repmat(xb_bar,1,nsamp);

 % remove the mean from teh ensemble (XbM is a matrix version of xbm)
 Xp = (ensemble_h - xb_bar_m) ;

 [ Xp_l, Xp_s ] = SpectDecom2Scale(Xp,prefix.model.main.resolution);
 Bs_l = Xp_l*Xp_l'/(nsamp-1);
 Bs_s = Xp_s*Xp_s'/(nsamp-1);

% option to save B to disk for use with DA experiments
 if prefix.model.main.I==1
   save L05_climo_B_1_MSDA1.mat Bs_l Bs_s
 elseif  prefix.model.main.I==12
   save L05_climo_B_12_MSDA1.mat Bs_l Bs_s
 end
 
 outfile = [ 'data_' prefix.expname '.mat' ];
 save(outfile,'Bs_l','Bs_s')


