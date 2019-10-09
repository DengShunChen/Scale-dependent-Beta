
function [field] = L05_update(field,model,ensemblesize,DA_Type)
   

if model.type ==1
    % Runge-Kutta coefficients
    %field.truth=L05_model_1(field.truth,model.main,model.timestep);

    if strcmp(DA_Type,'3DVAR') || strcmp(DA_Type,'3DHYB')
      field.bckgd=L05_model_1(field.bckgd,model.main,model.timestep);
    end

    % project : hi to lo resolution
     ensemble_l=field.ensemble;

    if strcmp(DA_Type,'LETKF') || strcmp(DA_Type,'3DHYB')
      parfor j=1:ensemblesize
         ensemble_l(:,j)= L05_model_1(ensemble_l(:,j),model.ens,model.timestep);
      end
    end

    field.ensemble = ensemble_l;


elseif (model.main.I==1 && model.type ==3) || model.type ==2
    % Runge-Kutta coefficients
    %field.truth=L05_model_2(field.truth,model.main,model.timestep);

    if strcmp(DA_Type,'3DVAR') || strcmp(DA_Type,'3DHYB')
      field.bckgd=L05_model_2(field.bckgd,model.main,model.timestep);
    end

    % project : hi to lo resolution
     ensemble_l=field.ensemble;

    if strcmp(DA_Type,'LETKF') || strcmp(DA_Type,'3DHYB')
      parfor j=1:ensemblesize
         ensemble_l(:,j)= L05_model_2(ensemble_l(:,j),model.ens,model.timestep);
      end
    end

    field.ensemble = ensemble_l;


elseif  model.type ==3 && model.main.I==12
    % Runge-Kutta coefficients
    %field.truth=L05_model_3(field.truth,model.main,model.timestep);

    if strcmp(DA_Type,'3DVAR') || strcmp(DA_Type,'3DHYB')
      field.bckgd=L05_model_3(field.bckgd,model.main,model.timestep);
    end

    % project : hi to lo resolution
     ensemble_l=field.ensemble;

    if strcmp(DA_Type,'LETKF') || strcmp(DA_Type,'3DHYB')
      parfor j=1:ensemblesize
         ensemble_l(:,j)= L05_model_3(ensemble_l(:,j),model.ens,model.timestep);
      end
    end

    field.ensemble = ensemble_l;
end
    % spline : lo to hi resolution
    %for j=1:ensemblesize
    %   field.ensemble(:,j)=interpft(ensemble_l(:,j),model.main.resolution);
    %end 


