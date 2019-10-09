% Initialization of Model Variables
 prefix.restart='fault';
% prefix.restart='truth';
 prefix.expname='MSDA2';
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
 prefix.model.main.forcing	= 14.0;

 % ensemble 
 prefix.model.ens.resolution	= prefix.model.main.resolution / prefix.reduced_factor;
 prefix.model.ens.I		= prefix.model.main.I / prefix.reduced_factor;
 prefix.model.ens.K		= prefix.model.ens.resolution/30;
 prefix.model.ens.b		= 10.;          %  Lorez96_model_III
 prefix.model.ens.c		= 2.5;          %  Lorez96_model_III
 prefix.model.ens.forcing	= 14.0;

%------------------------------------------------------------
 %prefix.da.system='LETKF'; prefix.da.beta1_inv=0.25
 %prefix.da.system='3DVAR'; prefix.da.beta1_inv=0.25
  prefix.da.system='3DHYB'; prefix.da.beta1_inv=0.0;

% letkf 
  prefix.da.rho=1.01;  

  if   strcmp(prefix.da.system,'3DVAR') 
    prefix.da.system='3DHYB'; prefix.da.beta1_inv=1.0;
  end
%------------------------------------------------------------

 datapath='../../'
 file.input.B=[ datapath 'L96_climo_B_' num2str(prefix.model.main.I) '_MSDA_v2.mat'];

 if prefix.model.main.I==1
   prefix.model.timestep	=0.025;
   prefix.da.observation_error	=2.0;
   prefix.da.obs_percent	=(1/24)*100;
   prefix.da.assim_bin.main	=2;
   prefix.da.localize_radius	=15;
 elseif  prefix.model.main.I==12
   prefix.model.timestep 	=0.0025;
   prefix.da.observation_error	=0.3;
   %prefix.da.obs_percent	=(1/2)*100;
   prefix.da.obs_percent	=(1/8)*100;
   prefix.da.assim_bin.main	=2;
   % Multi-scale data assimilation 
   prefix.da.LR.l	=90;
   prefix.da.LR.m	=15;
   prefix.da.LR.s	=3;
 else
   disp('Not a good model settings !!')
 end

 if prefix.model.ens.I==1/prefix.reduced_factor 
   prefix.da.assim_bin.ens=2;
 elseif  prefix.model.ens.I==12/prefix.reduced_factor
   prefix.da.assim_bin.ens=2;
 end

%----------------------------------------------------------------------------------%
 obs.numbers=round(prefix.model.main.resolution*(prefix.da.obs_percent/100));
%----------------------------------------------------------------------------------%

 if prefix.model.main.I==1
   file.input.bckgd_ens=[ datapath 'L96_IC_Bckgrd_ens_M02.mat' ];
   file.input.truth	=[ datapath 'L96_All_truth_M02_o24.txt' ];
   file.input.obsdata	=[ datapath 'L96_All_obsdata_M02_o24.txt' ];
   file.input.obsposi	=[ datapath 'L96_All_obsposi_M02_o24.txt' ];
 elseif  prefix.model.main.I==12
   file.input.bckgd_ens=[ datapath 'L96_IC_Bckgrd_ens_M03.mat'];
   file.input.truth	=[ datapath 'L96_All_truth_M03.txt'];
   file.input.obsdata	=[ datapath 'L96_All_obsdata_M03_o04.txt' ];
   file.input.obsposi	=[ datapath 'L96_All_obsposi_M03_o04.txt' ];
 else
   disp('Not a good model settings !!')
 end

 file.input

 % Define file name
 file.output.truth	=['data_truth_' prefix.expname '.txt'];
 file.output.obsdata	=['data_obsdata_' prefix.expname '.txt'];
 file.output.obsposi	=['data_obsposi_' prefix.expname '.txt'];

 file.output.analy.main	=['data_analy_' prefix.expname '.txt'];
 file.output.bckgd.main	=['data_bckgd_' prefix.expname '.txt'];
 file.output.analy.ens	=['data_analy_ens_' prefix.expname '.txt'];
 file.output.bckgd.ens	=['data_bckgd_ens_' prefix.expname '.txt'];

 file.output.xbinc	=['data_xbinc_' prefix.expname '.txt'];
 file.output.xeinc	=['data_xeinc_' prefix.expname '.txt'];


%----------------------------------------------------------------------------------%
 zero=zeros(prefix.model.main.resolution,1);
 prefix.model.main.index	=[1:prefix.model.main.resolution]';
 prefix.model.ens.index       	=[1:prefix.model.ens.resolution]';
 prefix.model.ens.bins        	=[1:prefix.reduced_factor:prefix.model.main.resolution]';
%----------------------------------------------------------------------------------%

% Localization
 [ prefix.da.L.l, prefix.da.L.m, prefix.da.L.s ]=...
      L05_genL(prefix.model.main.resolution,prefix.da.LR.l,prefix.da.LR.m,prefix.da.LR.s);

% Initialization of Observation Variables
 prefix.da.R	 = diag(ones(obs.numbers,1))*prefix.da.observation_error;
 prefix.da.R_inv = inv(prefix.da.R);

if strcmp(prefix.da.system,'3DVAR') || strcmp(prefix.da.system,'3DHYB')
  % Preparing 3DVAR Static Background Error Covariance
  load(file.input.B);
  maxBs_l=max(max(Bs_l)); minBs_l=min(min(Bs_l));
  maxBs_m=max(max(Bs_m)); minBs_m=min(min(Bs_m));
  maxBs_s=max(max(Bs_s)); minBs_s=min(min(Bs_s));

  obserr_l=prefix.da.observation_error;
  obserr_m=prefix.da.observation_error;
  obserr_s=prefix.da.observation_error;

  Bs_l=(Bs_l/(maxBs_l-minBs_l))*obserr_l;
  Bs_m=(Bs_m/(maxBs_m-minBs_m))*obserr_m;
  Bs_s=(Bs_s/(maxBs_s-minBs_s))*obserr_s;

  prefix.da.Bs.l=prefix.da.L.l.*Bs_l;
  prefix.da.Bs.m=prefix.da.L.m.*Bs_m;
  prefix.da.Bs.s=prefix.da.L.s.*Bs_s;

  % preparing static and ensemble weightings
  prefix.da.beta2_inv = 1. - prefix.da.beta1_inv ;

end


	
