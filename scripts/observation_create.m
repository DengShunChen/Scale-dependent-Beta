
function [ observations ] = observation_create(truth,number_observations,observation_error,H)

% observation counter
 obs_counter = [1 : number_observations ]';

% Create Observations
 observations(obs_counter)= H*truth + observation_error*randn(number_observations,1);
 observations = observations';
