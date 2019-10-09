
clc; 
clear all;

% Initialization of Model Variables
model_type = 7;
modelresolution=960;
ensemblesize=60;
timestep=0.002;     % for fast wave speed 
%timestep=0.01;     % for slow wave speed    
maxtime=20000;
spin_up=1000;
%maxtime=100;
initial_model_perturbation=0.008;
initial_ensemble_perturbation=0.01;
zero=zeros(modelresolution,1);

forcing=15.0;   
K=modelresolution/30;            % for model_type 3 : Lorez96_model_II

I_lorenz=12;    % for model_type 6 : Lorez96_model_III
b=10.;          % for model_type 6 : Lorez96_model_III
c=2.5;          % for model_type 6 : Lorez96_model_III
%c=2.56          % for model_type 6 : Lorez96_model_III

DA_Type='NO DA' % only running Truth

index=[1:modelresolution];

% Generating arrays
truth=ones(modelresolution,1)*forcing;
X=zeros(modelresolution,maxtime);

% Apply perturbation to truth
truth(modelresolution/2)=truth(modelresolution/2)+initial_model_perturbation;

for i=1:spin_up 
  if i==1 ; disp(['Spin up model, looping ' num2str(spin_up) ' time steps ....']) ; end
  lorenz_96_cycle
end

% Begin time cycle portion of the code
for t=1:maxtime 
   disp(['model looping t=' num2str(t)])
   lorenz_96_cycle

   X(:,t)=truth;   
end

nsamp = size(X,2); disp(['number of samples: ' int2str(nsamp)])
% ensemble mean
xm = mean(X,2);
% remove the mean from teh ensemble (XbM is a matrix version of xbm)
[tmp Xm] = meshgrid(ones(nsamp,1),xm);
Xp = X - Xm;
B = Xp*Xp'/(nsamp-1);

% option to save B to disk for use with DA experiments
if I_lorenz==1
 save L96_climo_B_1.mat B
 save L96_climo_B_Err_1.mat Xp
elseif  I_lorenz==12
 save L96_climo_B_12.mat B
 save L96_climo_B_Err_12.mat Xp
end
