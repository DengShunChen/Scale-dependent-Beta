
 clc; 
 clear all;

% configuration
 L05_config

%prefix.model.maxtime         =10000;
%observation_error            =2.;
%observation_percent          =1/24;
%file_truth                   ='data_all_truth_M03.txt';
%file_obsdata                 ='data_all_obsdata_M03_limited.txt';
%file_obsposi                 ='data_all_obsposi_M03_limited.txt';

 prefix.model.maxtime         =10000;
 observation_error            =1.;
 observation_percent          =1/8;
 file_truth                   ='data_all_truth_M03.txt';
 file_obsdata                 ='data_all_obsdata_M03_basic.txt';
 file_obsposi                 ='data_all_obsposi_M03_basic.txt';
%
%-----------------------------------------------------------------------------------%

% Generating arrays
 delete(file_truth)   ;  fid1 = fopen(file_truth, 'a');
 delete(file_obsdata) ; fid4a = fopen(file_obsdata, 'a');
 delete(file_obsposi) ; fid4b = fopen(file_obsposi, 'a');

% Read in initial truth state (spin up) 
 load(file_Init_Truth);
    
% Create Observation Error Covariance
 observation_init
  
% Randon seed
  % rng(40) ;  %v2
  % rng(20);
   rand('seed',20);

% Create observations postions 
 [ H ,obs_positions ] = observation_position(number_observations,prefix.model.main.resolution);

% Begin time cycle portion of the code
 for t=1:prefix.model.maxtime

   % Create Observations
   [ observations ] = observation_create(truth,number_observations,observation_error,H);

   % Write out analysis to text files 
    fprintf(fid1,  '%10.6f', truth);
    fprintf(fid4a, '%10.6f', observations);
    fprintf(fid4b, '%4i', obs_positions);
 
   % Forward model 
    disp(['model integral from time ' num2str(t-1) ' to ' num2str(t)])
    truth = L05_model_3(truth,prefix.model.main,prefix.model.timestep);
   
 end

