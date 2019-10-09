
clc; 
clear all;

% configuration
 L05_config

 prefix.model.maxtime = 2000;

% Read in initial truth state (spin up) 
 load(file_Init_Truth);

% Apply perturbation to background 
 initial_model_perturbation = 0.0001
 bckgd = truth;
 bckgd(prefix.model.main.resolution/2) = bckgd(prefix.model.main.resolution/2) + initial_model_perturbation;

% delete and open output files
 delete(file.output.truth);
 delete(file.output.bckgd.main);
 fid1 = fopen(file.output.truth, 'a');
 fid2 = fopen(file.output.bckgd.main, 'a');
  
%-----------------------------------------------------------------------------------------%
% Forward model 
 for t=1:prefix.model.maxtime 
   fprintf(fid1, '%10.6f', truth);
   fprintf(fid2, '%10.6f', bckgd);

   disp(['Spin up model, looping ' num2str(prefix.model.maxtime) ' time steps ....' num2str(t) ]) 
   % Runge-Kutta coefficients
   if prefix.model.type == 3
     prefix.model.main.forcing    =15.0;
     truth = L05_model_3(truth,prefix.model.main,prefix.model.timestep);
     prefix.model.main.forcing    =15.0;
     bckgd = L05_model_3(bckgd,prefix.model.main,prefix.model.timestep);
   elseif prefix.model.type == 2
     truth = L05_model_2(truth,prefix.model.main,prefix.model.timestep);
     bckgd = L05_model_2(bckgd,prefix.model.main,prefix.model.timestep);
   elseif prefix.model.type == 1
     truth = L05_model_1(truth,prefix.model.main,prefix.model.timestep);
     bckgd = L05_model_1(bckgd,prefix.model.main,prefix.model.timestep);
   end

 end


