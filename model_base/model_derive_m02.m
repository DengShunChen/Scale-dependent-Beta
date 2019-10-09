function [x1 x2]=model_derive_m02(K,x,modelresolution,index)

    x1 = model_sump(K,x,x,modelresolution,index);
    x2 = -x;
           
