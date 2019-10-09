function [W_bar]=sum1v(K,shift,indices1,weight,f1,modelresolution)

 W_bar=zeros(modelresolution,1);

 shift_big=repmat(shift,modelresolution,1);
 indices1=indices1-shift_big;
 indices1=mod(indices1,modelresolution);
 indices1(indices1==0) = modelresolution;

 W_bar = f1(indices1)*weight/K;
   

