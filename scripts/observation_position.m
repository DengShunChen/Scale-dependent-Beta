
function [ H ,obs_positions ] = observation_position(number_observations,modelresolution)

%initialize observation operator 
 H=zeros(number_observations,modelresolution);

%observation counter
 obs_counter = [1 : number_observations ]';

%=-------------------------------------------------------------------------------------------%
%observation positions
 %float observing positions
 %obs_positions=rand(number_observations,1)*modelresolution+1;
 %obs_positions(obs_positions>modelresolution)=obs_positions(obs_positions>modelresolution)-modelresolution+1; 

 %integer observing positions
 %obs_positions=randi([1 modelresolution],number_observations,1);
 randpermdata = randperm(modelresolution);
 obs_positions=randpermdata(1:number_observations);
%-------------------------------------------------------------------------------------------%
 obs_positions = sort(obs_positions);

%factors
 x1 = fix(obs_positions);

 x2 = x1 + 1;
 x2 = mod(x2,modelresolution) ;
 x2(x2==0)=modelresolution;

 f2 = obs_positions - x1;
 f1 = 1 - f2;
 
%observation opperator
 for i = 1 : number_observations
  H(i,x1(i))=f1(i);
  H(i,x2(i))=f2(i);
 end


