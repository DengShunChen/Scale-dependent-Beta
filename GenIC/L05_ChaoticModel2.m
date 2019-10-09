
clc; 
clear all;

% configuration
L05_config

prefix.model.maxtime = 2000;

% Read in initial truth state (spin up) 
load(file_Init_Truth);
origial=truth;

npert=40
for p=-npert/2:npert/2
   disp([ ' perturbation ' num2str(p) ]) 

 truth=origial;
% Apply perturbation to background 
 initial_model_perturbation = p/10000.
 truth(prefix.model.main.resolution/2) = truth(prefix.model.main.resolution/2) + initial_model_perturbation;
 
 file.output.truth=['out_chaotic_' num2str(p+npert+1)]

% delete and open output files
 delete(file.output.truth);
 fid1 = fopen(file.output.truth, 'a');
  
%-----------------------------------------------------------------------------------------%
% Forward model 
 for t=1:prefix.model.maxtime 
   fprintf(fid1, '%10.6f', truth);

   disp(['Spin up model, looping ' num2str(prefix.model.maxtime) ' time steps ....' num2str(t) ]) 
   % Runge-Kutta coefficients
   if prefix.model.type == 3
     prefix.model.main.forcing    =15.0;
     truth = L05_model_3(truth,prefix.model.main,prefix.model.timestep);
   elseif prefix.model.type == 2
     truth = L05_model_2(truth,prefix.model.main,prefix.model.timestep);
     bckgd = L05_model_2(bckgd,prefix.model.main,prefix.model.timestep);
   elseif prefix.model.type == 1
     truth = L05_model_1(truth,prefix.model.main,prefix.model.timestep);
     bckgd = L05_model_1(bckgd,prefix.model.main,prefix.model.timestep);
   end

 end

end
