function [W_bar]=sum2v(K,shift,indices,weight,f1,f2,modelresolution)

 W_bar=zeros(modelresolution,1);

 shift_big=repmat(shift,modelresolution,1);
 %size(shift_big)
 indices1=indices-K+shift_big;
 indices1=mod(indices1,modelresolution);
 indices1(indices1==0) = modelresolution;

 indices2=indices+K+shift_big;
 indices2=mod(indices2,modelresolution);
 indices2(indices2==0) = modelresolution;

 W_bar = (f1(indices1).*f2(indices2))*weight/K;


