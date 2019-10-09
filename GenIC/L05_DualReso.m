% Initialization of Model Variables
 prefix.expname='FullReso';
%prefix.expname='DualReso'; 
%prefix.expname='DualReso2';
%------------------------------------------------------------

 prefix.model.maxtime		= 20;

 prefix.reduced_factor		= 1;		% reduced resolution of ensemble 
 prefix.ensemblesize		= 10;

 prefix.model.reduced_factor	= prefix.reduced_factor; 

 % main analysis
 prefix.model.main.resolution	= 960 ;
 prefix.model.main.I		= 12 ;
 prefix.model.main.K		= prefix.model.main.resolution/30;
 prefix.model.main.b		= 10.;          %  Lorez96_model_III
 prefix.model.main.c		= 2.5;          %  Lorez96_model_III
 prefix.model.main.forcing	= 14.0;

 % ensemble 
 prefix.model.ens.resolution	= prefix.model.main.resolution / prefix.reduced_factor;
 prefix.model.ens.I		= prefix.model.main.I / prefix.reduced_factor;
 prefix.model.ens.K		= prefix.model.ens.resolution/30;
 prefix.model.ens.b		= 10.;          %  Lorez96_model_III
 prefix.model.ens.c		= 2.5;          %  Lorez96_model_III
 prefix.model.ens.forcing	= 14.0;

% observation
%if prefix.model.main.I==1
%  prefix.model.timestep	= 0.025;
%  observation_error=2.0;
%  obs_percent=(1/24)*100;
%elseif  prefix.model.main.I==12
   prefix.model.timestep	= 0.0025;
%  obs_error=0.3;
%  obs_percent=(1/8)*100;
%else
%  disp('Not a good model settings !!')
%end

%------------------------------------------------------------

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

 truth=field.truth(prefix.model.ens.bins);
 Truth=zeros(prefix.model.ens.resolution,1);

% Begin time cycle portion of the code
 for t=1:prefix.model.maxtime
 
   % Forward model 
    disp(['model integral from time ' num2str(t) ' to ' num2str(t+1)])
    truth=L05_model_3(truth,prefix.model.ens,prefix.model.timestep);
    Truth(:,t)=truth;
 
 end

  % set and write out 
 file.output.ColdStart  =['data_' prefix.expname '.mat'];
 save(file.output.ColdStart,'Truth')



