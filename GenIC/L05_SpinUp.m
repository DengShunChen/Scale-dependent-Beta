
clc; 
clear all;

% configuration
 L05_config

 rand('seed',20);

% Generating arrays
 truth    =ones(prefix.model.main.resolution,1)*prefix.model.main.forcing;
 bckgd    =ones(prefix.model.main.resolution,1)*prefix.model.main.forcing;
 ensemble =repmat(truth,1,prefix.ensemblesize);

% Apply perturbation
 truth(prefix.model.main.resolution/2)=truth(prefix.model.main.resolution/2)+initial_model_perturbation1;
 bckgd(prefix.model.main.resolution/2)=bckgd(prefix.model.main.resolution/2)+initial_model_perturbation2;
 
 ensemble(prefix.model.ens.resolution/2,1:prefix.ensemblesize) = ensemble(prefix.model.ens.resolution/2,1:prefix.ensemblesize) ...
               + randn(1,prefix.ensemblesize)*initial_ensemble_perturbation;

% Forward model 
 for t=1:prefix.model.spinuptime
   disp(['Spin up model, looping ' num2str(prefix.model.spinuptime) ' time steps ....' num2str(t) ]) 
   % Runge-Kutta coefficients
   if prefix.model.type == 3
     truth = L05_model_3(truth,prefix.model.main,prefix.model.timestep);
     bckgd = L05_model_3(bckgd,prefix.model.main,prefix.model.timestep);
   elseif prefix.model.type == 2
     truth = L05_model_2(truth,prefix.model.main,prefix.model.timestep);
     bckgd = L05_model_2(bckgd,prefix.model.main,prefix.model.timestep);
   elseif prefix.model.type == 1
     truth = L05_model_1(truth,prefix.model.main,prefix.model.timestep);
     bckgd = L05_model_1(bckgd,prefix.model.main,prefix.model.timestep);
   end

   figure(1);
   subplot(2,1,1);
   plot(truth,'K-')
   hold on
   plot(bckgd,'b-')
   axis([-inf inf -30 30]);
   hold off

   for j=1:ensemblesize

      if prefix.model.type == 3 
        ensemble(:,j) = L05_model_3(ensemble(:,j),prefix.model.ens,prefix.model.timestep);
      elseif prefix.model.type == 2
        ensemble(:,j) = L05_model_2(ensemble(:,j),prefix.model.ens,prefix.model.timestep);
      elseif prefix.model.type == 1
        ensemble(:,j) = L05_model_1(ensemble(:,j),prefix.model.ens,prefix.model.timestep);
      end

     subplot(2,1,2);
     plot(ensemble(:,j))
     axis([-inf inf -30 30]);
     hold on
   end

   drawnow
   hold off
 end

% Saving files  
  save(file_Init_Truth,'truth')
  save(file_Init_Bck,'bckgd')
  save(file_Init_Bck_Ens,'ensemble')


