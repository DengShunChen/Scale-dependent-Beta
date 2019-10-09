% Initialization of Model Variables
% prefix.expname='ColdStartF';  % full resolusion 
% prefix.expname='ColdStart';   % half resolusion 
%  prefix.expname='ColdStartM200';   % half resolusion
  prefix.expname='ColdStartFM100';   % half resolusion

  poolobj = parpool
%------------------------------------------------------------

 prefix.model.maxtime		      = 1000;

 prefix.reduced_factor		    = 1;		% reduced resolution of ensemble 
 prefix.ensemblesize		      = 100;

 prefix.model.reduced_factor	= prefix.reduced_factor; 

 prefix.model.timestep	      = 0.0025;
 % main analysis
 prefix.model.main.resolution	= 960;
 prefix.model.main.I		      = 12;
 prefix.model.main.K		      = prefix.model.main.resolution/30;
 prefix.model.main.b		      = 10.;          %  Lorez96_model_III
 prefix.model.main.c		      = 2.5;          %  Lorez96_model_III
 prefix.model.main.forcing	  = 15.0;

 % ensemble 
 prefix.model.ens.resolution	= prefix.model.main.resolution / prefix.reduced_factor;
 prefix.model.ens.I		        = prefix.model.main.I / prefix.reduced_factor;
 prefix.model.ens.K		        = prefix.model.ens.resolution/30;
 prefix.model.ens.b		        = 10.;          %  Lorez96_model_III
 prefix.model.ens.c		        = 2.5;          %  Lorez96_model_III
 prefix.model.ens.forcing	    = 15.0;

%----------------------------------------------------------------------------------%
 zero=zeros(prefix.model.main.resolution,1);
 prefix.model.main.index	= [1:prefix.model.main.resolution]';
 prefix.model.ens.index   = [1:prefix.model.ens.resolution]';
 prefix.model.ens.bins    = [1:prefix.reduced_factor:prefix.model.main.resolution]';
%----------------------------------------------------------------------------------%

 datapath='../../';
 initial_model_perturbation=0.008;
 initial_ensemble_perturbation=0.01;

% Generating arrays
 field.truth=ones(prefix.model.main.resolution,1)*prefix.model.main.forcing;
 field.bckgd=ones(prefix.model.main.resolution,1)*prefix.model.main.forcing;
 field.ensemble=repmat(field.truth(prefix.model.ens.bins),1,prefix.ensemblesize);

% Apply perturbation
 field.truth(prefix.model.main.resolution/2) = field.truth(prefix.model.main.resolution/2) ...
                                             + initial_model_perturbation ;

 field.bckgd(prefix.model.main.resolution/2) = field.bckgd(prefix.model.main.resolution/2) ...
                                             + initial_model_perturbation + randn ;

 field.ensemble(prefix.model.ens.resolution/2,1:prefix.ensemblesize) = ...
                        field.ensemble(prefix.model.ens.resolution/2,1:prefix.ensemblesize) ...
                        + randn(1,prefix.ensemblesize)*initial_ensemble_perturbation;


 % Define file name
 file.output.ColdStart	=['data_' prefix.expname '.mat'];


% Begin time cycle portion of the code
 for t=1:prefix.model.maxtime

   % Forward model 
    disp(['model integral from time ' num2str(t-1) ' to ' num2str(t)])
   [field] = L05_update(field,prefix.model,prefix.ensemblesize,'3DHYB');

 end
 % set and write out the Truth
  save(file.output.ColdStart,'field')

 delete(poolobj)
