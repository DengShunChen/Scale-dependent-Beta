% Initialization of Model Variables
 prefix.model.type            = 3;
 prefix.model.spinuptime      = 800;

 prefix.reduced_factor        =1;
%prefix.ensemblesize          =20;
 prefix.ensemblesize          =200;
 ensemblesize=prefix.ensemblesize;

 prefix.model.reduced_factor  = prefix.reduced_factor;

 % main analysis
 prefix.model.main.resolution =960;
 prefix.model.main.I          = 12;
 prefix.model.main.K          = prefix.model.main.resolution/30;
 prefix.model.main.b          =10.;          % for model_type 6 : Lorez96_model_III
 prefix.model.main.c          =2.5;          % for model_type 6 : Lorez96_model_III
 prefix.model.main.forcing    =15.0;
 prefix.model.main.sppt='false';

 % ensemble 
 prefix.model.ens.resolution  = prefix.model.main.resolution / prefix.reduced_factor;
 prefix.model.ens.I           = prefix.model.main.I / prefix.reduced_factor;
 prefix.model.ens.K           = prefix.model.ens.resolution/30;
 prefix.model.ens.b           =10.;          % for model_type 6 : Lorez96_model_III
 prefix.model.ens.c           =2.5;          % for model_type 6 : Lorez96_model_III
 prefix.model.ens.forcing     =15.0;
 prefix.model.ens.sppt='false';


 initial_model_perturbation1=0.008;
 initial_model_perturbation2=0.009;
 initial_ensemble_perturbation=0.01;

 if prefix.model.type ==1
   prefix.model.timestep        =0.025;
   observation_error            =1,0;
   observation_percent          =1/24;

   file_Init_Truth              ='data_init_truth_M01.mat'
   file_Init_Bck                ='data_init_bckgd_M01.mat'
   file_Init_Bck_Ens            ='data_init_bck_ens_M01_m20.mat'

   file_truth                   ='data_all_truth_M01_Op24.txt';
   file_obsdata                 ='data_all_obsdata_M01_Op24.txt';
   file_obsposi                 ='data_all_obsposi_M01_Op24.txt';
 elseif (prefix.model.main.I==1 & prefix.model.type ==3) | prefix.model.type ==2
   prefix.model.timestep        =0.025;
   observation_error            =1.0;
   observation_percent          =1/24;

   file_Init_Truth              ='data_init_truth_M02.mat'
   file_Init_Bck                ='data_init_bckgd_M02.mat'
   file_Init_Bck_Ens            ='data_init_bck_ens_M02_m20.mat'

   file_truth                   ='data_all_truth_M02_Op24.txt';
   file_obsdata                 ='data_all_obsdata_M02_Op24.txt';
   file_obsposi                 ='data_all_obsposi_M02_Op24.txt';
 elseif  prefix.model.type ==3 & prefix.model.main.I==12
   prefix.model.timestep        =0.0025;
   observation_error            =1.0;
   observation_percent          =0.125;

   file_Init_Truth              ='data_init_truth_M03.mat'
   file_Init_Bck                ='data_init_bckgd_M03.mat'
   file_Init_Bck_Ens            ='data_init_bck_ens_M03_m200.mat'

   file_truth                   ='data_all_truth_M03_p125.txt';
   file_obsdata                 ='data_all_obsdata_M03_p125.txt';
   file_obsposi                 ='data_all_obsposi_M03_p125.txt';
 else
   disp('Not a good model settings !!')
 end

 zero=zeros(prefix.model.main.resolution,1);
 prefix.model.main.index  =[1:prefix.model.main.resolution]';
 prefix.model.ens.index   =[1:prefix.model.ens.resolution]';
 prefix.model.ens.bins    =[1:prefix.reduced_factor:prefix.model.main.resolution]';

 % Define file name
 file.output.truth      =['output_truth.txt'];
 file.output.obsdata    =['output_obsdata.txt'];
 file.output.obsposi    =['output_obsposi.txt'];

 file.output.analy.main =['output_analy.txt'];
 file.output.bckgd.main =['output_bckgd.txt'];
 file.output.analy.ens  =['output_analy_ens.txt'];
 file.output.bckgd.ens  =['output_bckgd_ens.txt'];

 obs.numbers=round(prefix.model.main.resolution*(observation_percent));
