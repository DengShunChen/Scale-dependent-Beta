function [XY]=model_sump(K,X,Y,modelresolution,index)

    % X : field 1
    % Y : field 2
    if mod(K,2)==0
       J=K/2;
       shift=-J:J;
       K1=size(shift,2);

       weight=ones(K1,1);
       weight(1)=0.5; weight(end)=0.5;
       indices1=repmat(index,1,K1);
    else
       J=(K-1)/2;
       shift=-J:J;
       K1=size(shift,2);

       weight=ones(K1,1);
       indices1=repmat(index,1,K1);
    end

    XS = model_sum1v(K,shift,indices1,weight,X,modelresolution);
    YS = model_sum1v(K,shift,indices1,weight,Y,modelresolution);
    XY = model_sum2v(K,shift,indices1,weight,XS,Y,modelresolution);

    indicesp=[index-(2*K) index-K];
    indicesp=mod(indicesp,modelresolution);
    indicesp(indicesp==0)=modelresolution;

    XY = XY - XS(indicesp(:,1)).*YS(indicesp(:,2));
            
