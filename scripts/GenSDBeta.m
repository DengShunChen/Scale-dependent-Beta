function [ sdb_beta1_inv, sdb_beta2_inv] = GenSDBeta(beta1_inv,modelresolution)
 wgt(1:modelresolution/2+1)=1.;
 beta2_inv=1-beta1_inv;

% define beta2_inv tail can not only be zero
 %beta2_tail = 0.125;
 beta2_tail = 0.0;
 
 center=40;
 Radius=20;

%- Gaussian Distribution -------------------------------
 for i=1:modelresolution/2+1
   wgt(i) = exp((-(i-center)^2)/(2*(Radius)^2));
 end
 wgt(1:center)=1.;
%------------------------------------------------------

 if (beta2_tail > beta2_inv) 
   beta2_tail = beta2_inv;
 end
 width = abs(beta1_inv-beta2_inv)+(beta1_inv-beta2_tail);
 shift = abs(beta2_inv-width);
 wgt=abs(width)*wgt+shift;

 wgt_flipr = fliplr(wgt);

 sdb_beta2_inv = [wgt wgt_flipr(2:end-1)]';
 sdb_beta1_inv = 1 - sdb_beta2_inv;
 
