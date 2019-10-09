function [x1, x2, x3]=model_derive_m01(K,x,modelresolution,index)

    indicesp=[index-2 index-1 index+1];
    indicesp=mod(indicesp,modelresolution);
    indicesp(indicesp==0)=modelresolution;

    x1 = -x(indicesp(:,1)).*x(indicesp(:,2));
    x2 =  x(indicesp(:,2)).*x(indicesp(:,3));
    x3 = -x;
           
