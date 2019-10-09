
clc; 
clear all;

% Initialization of Model Variables
 model_type = 7;
 modelresolution=960;
 ensemblesize=20;
 I_lorenz=1     % for model_type 6 : Lorez96_model_III
 b=10.;          % for model_type 6 : Lorez96_model_III
 c=2.5;          % for model_type 6 : Lorez96_model_III
 forcing=15.0;
 K=modelresolution/30;            % for model_type 3 : Lorez96_model_II

 spin_up=1000;

 initial_model_perturbation=0.008;
 initial_ensemble_perturbation=0.01;

 if I_lorenz==1
   timestep=0.0025;
   observation_error=2.0;
   obs_percent=(1/24)*100;
 elseif  I_lorenz==12
   timestep=0.0025;
   observation_error=0.3;
   obs_percent=(1/2)*100;
 else
   disp('Not a good model settings !!')
 end

 index=[1:modelresolution]';

% Generating arrays
 truth=ones(modelresolution,1)*forcing;
 ensemble=repmat(truth,1,ensemblesize);

% Apply perturbation
 truth(modelresolution/2)=truth(modelresolution/2)+initial_model_perturbation;

 ensemble(modelresolution/2,1:ensemblesize) = ensemble(modelresolution/2,1:ensemblesize) ...
               + initial_model_perturbation + randn(1,ensemblesize)*initial_ensemble_perturbation;

% Forward model 
 for t=1:spin_up 
  disp(['Spin up model, looping ' num2str(spin_up) ' time steps ....' num2str(t) ]) 
   % Runge-Kutta coefficients
   truth=L05_model_3(truth,I_lorenz,modelresolution,index,K,b,c,timestep,forcing);
   for j=1:ensemblesize
      ensemble(:,j)= L05_model_3(ensemble(:,j),I_lorenz,modelresolution,index,K,b,c,timestep,forcing);
   end
 end

% Saving files  
if I_lorenz==1 
 save L96_Init_Truth_M02.mat truth
 if ensemblesize == 20 
   save L96_Init_Bckgrd_ens_M02_m20.mat ensemble
 elseif ensemblesize == 10
   save L96_Init_Bckgrd_ens_M02_m10.mat ensemble
 elseif ensemblesize == 5
   save L96_Init_Bckgrd_ens_M02_m05.mat ensemble
 elseif ensemblesize == 100
   save L96_Init_Bckgrd_ens_M02_m100.mat ensemble
 end 
elseif  I_lorenz==12
 save L96_Init_Truth_M03.mat truth
 if ensemblesize == 20 
   save L96_Init_Bckgrd_ens_M03_m20.mat ensemble
 elseif ensemblesize == 10
   save L96_Init_Bckgrd_ens_M03_m10.mat ensemble
 elseif ensemblesize == 5
   save L96_Init_Bckgrd_ens_M03_m05.mat ensemble
 elseif ensemblesize == 100
   save L96_Init_Bckgrd_ens_M03_m100.mat ensemble
 end 
end


