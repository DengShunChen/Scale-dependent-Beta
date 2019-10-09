function [X, Y]=calxy(I,Z,modelresolution,index)

 alpha=(3.*I^2.+3.)/(2.*I^3.+4.*I);
 beta=(2.*I^2.+1)/(I^4.+2.*I^2.);

 X=zeros(modelresolution,1);
 for ii=-I:I
    if ii==-I || ii==I
      weight=0.5;
    else 
      weight=1.0;
    end
    indices1=index+ii;
    indices1=mod(indices1,modelresolution);
    indices1(indices1==0) = modelresolution;

    X = X + weight*( (alpha-beta.*abs(ii)).* Z(indices1(:)) );   
 end   
 
 Y = Z - X;

