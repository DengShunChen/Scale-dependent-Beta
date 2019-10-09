% Initialization of Model Variables
 prefix.expname='GenTruthObs';
%------------------------------------------------------------

 prefix.model.maxtime		= 500;

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
   %obs_percent=(1/2)*100;
   %observation_error=0.5;
   %observation_error=0.3;
   %obs_percent=(1/4)*100;
   obs_error=0.3;
   obs_percent=(1/8)*100;
 else
   disp('Not a good model settings !!')
 end

%------------------------------------------------------------

 datapath='../../'

 % Define file name
 file.input.ColdStart	=['data_ColdStart.mat'];
%file_truth = ['data_truth_' prefix.expname '.txt'];
%file_obsdata=['obs_value_' prefix.expname '.txt'];
%file_obsposi=['obs_posit_' prefix.expname '.txt'];

% Generating arrays
%delete(file_truth)   ;  fid1 = fopen(file_truth, 'a');
%delete(file_obsdata) ; fid4a = fopen(file_obsdata, 'a');
%delete(file_obsposi) ; fid4b = fopen(file_obsposi, 'a');

 % Load array in
 load(file.input.ColdStart)

%----------------------------------------------------------------------------------%
 zero=zeros(prefix.model.main.resolution,1);
 prefix.model.main.index = [1:prefix.model.main.resolution]';
 prefix.model.ens.index = [1:prefix.model.ens.resolution]';
 prefix.model.ens.bins  = [1:prefix.reduced_factor:prefix.model.main.resolution]';
%----------------------------------------------------------------------------------%

% Create Observation Error Covariance
% observation_init

% Random Seeds
%  rand('seed',20);

% Create observations postions
% [ H ,obs_posit ] = observation_position(number_obs,prefix.model.main.resolution);

% Begin time cycle portion of the code
 for t=1:prefix.model.maxtime

   % Create Observations
   % [ obs_value ] = observation_create(field.truth,number_obs,obs_error,H);

   % Write out analysis to text files 
   % fprintf(fid1,  '%10.6f', field.truth);
   % fprintf(fid4a, '%10.6f', obs_value);
   % fprintf(fid4b, '%10.6f', obs_posit);
 
   % Forward model 
    disp(['model integral from time ' num2str(t) ' to ' num2str(t+1)])
    field.truth=L05_model_3(field.truth,prefix.model.main,prefix.model.timestep);
    X(:,t)=field.truth;
     
 end

nsamp = size(X,2); disp(['number of samples: ' int2str(nsamp)])
% ensemble mean
xm = mean(X,2);
% remove the mean from teh ensemble (XbM is a matrix version of xbm)
[tmp Xm] = meshgrid(ones(nsamp,1),xm);
Xp = X - Xm;
B = Xp*Xp'/(nsamp-1);

% option to save B to disk for use with DA experiments
if prefix.model.main.I==1
 save L05_climo_B_1.mat B
 save L05_climo_B_Err_1.mat Xp
elseif  prefix.model.main.I==12
 save L05_climo_B_12.mat B
 save L05_climo_Err_12.mat Xp
end


