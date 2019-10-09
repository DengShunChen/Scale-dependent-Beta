
% Initialization of Observation Variables
number_observations=round(prefix.model.main.resolution*observation_percent)
obs_value=zeros(number_observations,1);
plot_obs_value=zeros(prefix.model.main.resolution,1);
R=zeros(number_observations,number_observations);
I=eye(prefix.model.main.resolution);
%H=zeros(number_observations,modelresolution);

% observation error variance 
R = diag(ones(number_observations,1))*observation_error;
R_inv = inv(R);

 
