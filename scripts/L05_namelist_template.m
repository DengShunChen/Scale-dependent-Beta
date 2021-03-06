% Initialization of Model Variables
 prefix.restart='false';
 prefix.expname='matrix';

 prefix.model.type            = 3; 
 prefix.model.maxtime		      = 5000;

 prefix.reduced_factor=4;           % (1/reduced_factor) * model resolution
 prefix.ensemblesize=10;
 prefix.da.scenario = 'basic'

%------------------------------------------------------------
 prefix.model.reduced_factor	= prefix.reduced_factor; 

 % main analysis
 prefix.model.main.resolution	=960;
 prefix.model.main.I		      = 12;
 prefix.model.main.K		      = prefix.model.main.resolution/30;
 prefix.model.main.b		      =10.;          
 prefix.model.main.c		      =2.5;          
 prefix.model.main.forcing	  =14.0;        % imperfect model 
 prefix.model.main.sppt       ='false';

 % ensemble 
 prefix.model.ens.resolution	= prefix.model.main.resolution / prefix.reduced_factor;
 prefix.model.ens.I		        = prefix.model.main.I / prefix.reduced_factor;
 prefix.model.ens.K		        = prefix.model.ens.resolution/30;
 prefix.model.ens.b		        =10.;          
 prefix.model.ens.c		        =2.5;          
 prefix.model.ens.forcing	    =14.0;        % imperfect model 
 prefix.model.ens.sppt       ='false';

 disp('model configure')
 prefix.model.main	
 prefix.model.ens
%------------------------------------------------------------
  % Data Assimilation type
  prefix.da.type='regular' ; % regular, sdb,  sdl, msda
  % sdb: scale-dependent beta
  % sdl: scale-dependent localization
  % msda: multi-scale data assimilation 

  % Data Assimilation system 
  prefix.da.system='3DHYB';     % 3DVAR, 3DHYB, LETKF

  % hybrid weighting 
  if  strcmp(prefix.da.type,'msda')
    prefix.da.beta1_inv.l=0.10;
    prefix.da.beta1_inv.s=1.00;
  else
    prefix.da.beta1_inv=0.1;
  end

  % localization 
  if strcmp(prefix.da.type,'sdl') || strcmp(prefix.da.type,'msda')
    prefix.da.LR.l=15;
    prefix.da.LR.s=1;
  else
    prefix.da.LR=50;
  end

  % preparing static and ensemble weightings
  if strcmp(prefix.da.type,'msda') 
    prefix.da.beta2_inv.l = 1. - prefix.da.beta1_inv.l ;
    prefix.da.beta2_inv.s = 1. - prefix.da.beta1_inv.s ;
  else
    prefix.da.beta2_inv = 1. - prefix.da.beta1_inv ;
  end
 
  if strcmp(prefix.da.type,'sdb')
    [prefix.da.sd_beta1_inv, prefix.da.sd_beta2_inv] = ...
              GenSDBeta(prefix.da.beta1_inv,prefix.model.main.resolution);
  end

  % letkf multiplicative inflation
  prefix.da.rho=1.01;

  % additive inflation : RTPP
  prefix.da.RTPP = 'false';
  prefix.da.RTPPalpha =0.75 ;

  % multiplicative inflation : RTPS
  prefix.da.RTPS = 'false';
  prefix.da.RTPSalpha =0.95 ;

  if  strcmp(prefix.da.system,'3DVAR') 
    prefix.da.system='3DHYB'; prefix.da.beta1_inv=1.0;
  end

 disp('da configure')
 prefix.da
%===============================================================================================%
% End of general settings
%===============================================================================================%

 datapath='/Users/dalab/Matlab_LorenzModel/prefixdata/'
 if strcmp(prefix.da.type,'sdl') || strcmp(prefix.da.type,'msda')
  %file.input.B=[ datapath 'L05_climo_B_' num2str(prefix.model.main.I) '_MSDA.mat'];
   file.input.B=[ datapath 'L05_climo_B_' num2str(prefix.model.main.I) '_MSDA_new.mat'];
 else
   file.input.B=[ datapath 'L05_climo_B_' num2str(prefix.model.main.I) '.mat'];
 end

 if prefix.model.type ==1
   prefix.model.timestep        =0.025;
   prefix.da.observation_error	=2.0;
   prefix.da.obs_percent	      =(1/24)*100;
   prefix.da.assim_bin.main	    =2;
   prefix.da.localize_radius	  =15;

   file_Init_Truth              ='data_init_truth_M01.mat'
   file_truth                   ='data_all_truth_M01_Op24.txt';
   file_obsdata                 ='data_all_obsdata_M01_Op24.txt';
   file_obsposi                 ='data_all_obsposi_M01_Op24.txt';
 elseif (prefix.model.main.I==1 & prefix.model.type ==3) | prefix.model.type ==2
   prefix.model.timestep        =0.025;
   prefix.da.observation_error	=2.0;
   prefix.da.obs_percent	      =(1/24)*100;
   prefix.da.assim_bin.main	    =2;
   prefix.da.localize_radius	  =15;

   file_Init_Truth              ='data_init_truth_M02.mat'
   file_Init_Bck_Ens            ='data_init_bck_ens_M03_m20.mat'

   file_truth                   ='data_all_truth_M02_Op24.txt';
   file_obsdata                 ='data_all_obsdata_M02_Op24.txt';
   file_obsposi                 ='data_all_obsposi_M02_Op24.txt';
 elseif  prefix.model.type ==3 & prefix.model.main.I==12
   prefix.model.timestep        =0.0025;
   prefix.da.assim_bin.main	    =20;   % assimilate observations every 20 time steps 

   % initial fields
   file_Init_Truth              ='data_init_truth_M03.mat'
   file_Init_Bck                ='data_init_bckgd_M03.mat'
   file_Init_Bck_Ens            ='data_init_bck_ens_M03_m200.mat'

   % Truth with F=15
   file_truth                   ='data_all_truth_M03.txt';
  if strcmp(prefix.da.scenario,'basic')
    prefix.da.observation_error  =1.0;
    prefix.da.obs_percent        =(1/8)*100;
    file_obsdata                 ='data_all_obsdata_M03_basic.txt';
    file_obsposi                 ='data_all_obsposi_M03_basic.txt';
  elseif strcmp(prefix.da.scenario,'limited')
    prefix.da.observation_error  =2.0;
    prefix.da.obs_percent        =(1/24)*100;
    file_obsdata                 ='data_all_obsdata_M03_limited.txt';
    file_obsposi                 ='data_all_obsposi_M03_limited.txt';
  elseif strcmp(prefix.da.scenario,'dense')
    prefix.da.observation_error  =0.3;
    prefix.da.obs_percent        =(1/2)*100;
    prefix.da.assim_bin.main	    =2;   % assimilate observations every 20 time steps 
    file_obsdata                 ='data_all_obsdata_M03_dense.txt';
    file_obsposi                 ='data_all_obsposi_M03_dense.txt';
  end
 else
   disp('Not a good model settings !!')
 end

 % assimilation window 
 if prefix.model.ens.I==1/prefix.reduced_factor 
   prefix.da.assim_bin.ens=0.05/prefix.model.timestep;
 elseif  prefix.model.ens.I==12/prefix.reduced_factor
   %prefix.da.assim_bin.ens=0.005/prefix.model.timestep;
   prefix.da.assim_bin.ens=prefix.da.assim_bin.main;
 end

%----------------------------------------------------------------------------------%
 obs.numbers=round(prefix.model.main.resolution*(prefix.da.obs_percent/100));
 zero=zeros(prefix.model.main.resolution,1);
 prefix.model.main.index	=[1:prefix.model.main.resolution]';
 prefix.model.main.bins	=[1:prefix.model.main.resolution]';
 prefix.model.ens.index   =[1:prefix.model.ens.resolution]';
 prefix.model.ens.bins    =[1:prefix.reduced_factor:prefix.model.main.resolution]';
%----------------------------------------------------------------------------------%

 % input file 
 file.input.bckgd_ens =[ datapath file_Init_Bck_Ens ];
 file.input.bckgd     =[ datapath file_Init_Bck ];
 file.input.truth	    =[ datapath file_truth ];
 file.input.obsdata	  =[ datapath file_obsdata ];
 file.input.obsposi	  =[ datapath file_obsposi ];

 disp('file input')	
 file.input

 % Define file name
 file.output.truth	    =['output_truth.txt'];
 file.output.obsdata	  =['output_obsdata.txt'];
 file.output.obsposi	  =['output_obsposi.txt'];

 file.output.analy.main	=['output_analy.txt'];
 file.output.bckgd.main	=['output_bckgd.txt'];
 file.output.analy.ens	=['output_analy_ens.txt'];
 file.output.bckgd.ens	=['output_bckgd_ens.txt'];

 file.output.xbinc	    =['output_xbinc.txt'];
 file.output.xeinc	    =['output_xeinc.txt'];

 file.output.gsta	      =['output_gsta.txt'];
 file.output.gens	      =['output_gens.txt'];
 
 file.output.spd        =['output_spd.txt'];

 disp('file output')	
 file.output

% Localization
  if strcmp(prefix.da.type,'sdl') || strcmp(prefix.da.type,'msda')
    prefix.da.L.l = L05_genL(prefix.model.main.resolution,prefix.da.LR.l);
    prefix.da.L.s = L05_genL(prefix.model.main.resolution,prefix.da.LR.s);
  else
    prefix.da.L = L05_genL(prefix.model.main.resolution,prefix.da.LR);
  end

% Initialization of Observation Variables
 prefix.da.R = diag(ones(obs.numbers,1))*prefix.da.observation_error;
 prefix.da.R_inv = inv(prefix.da.R);

if strcmp(prefix.da.system,'3DVAR') || strcmp(prefix.da.system,'3DHYB')
  % Preparing 3DVAR Static Background Error Covariance
  load(file.input.B);

  if strcmp(prefix.da.type,'sdl') || strcmp(prefix.da.type,'msda')
    wgt=mean(diag(Bs_l))/prefix.da.observation_error;
    BEV=(diag(Bs_l)/wgt);
    Bs_L.l = L05_genL(prefix.model.main.resolution,prefix.da.LR.l); 
    prefix.da.Bs.l=Bs_L.l*diag(BEV);

    %wgt=mean(diag(Bs_s))/(prefix.da.observation_error/10.);
    BEV=(diag(Bs_s)/wgt);
    Bs_L.s = L05_genL(prefix.model.main.resolution,prefix.da.LR.s); 
    prefix.da.Bs.s=Bs_L.s*diag(BEV);
  else
    wgt=mean(diag(B))/prefix.da.observation_error;
    BEV=(diag(B)/wgt);
    Bs_loc=15;
    Bs_L = L05_genL(prefix.model.main.resolution,Bs_loc);
    prefix.da.Bs=Bs_L*diag(BEV);
  end
end


