function [x1 x2 x3 x4 x5]=model_derive_m03(K,x,y,modelresolution,index,b,c)

    x1=model_sump(K,x,x,modelresolution,index);
    x2=(b^2.).*model_sump(1,y,y,modelresolution,index);
    x3=c.*model_sump(1,y,x,modelresolution,index);
    x4=-x;
    x5=-b.*y;
           
