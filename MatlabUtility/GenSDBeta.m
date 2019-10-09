function [ sdb_beta1_inv sdb_beta2_inv] = GenSDBeta(beta1_inv,modelresolution)
 wgt(1:modelresolution/2+1)=1.;
 beta2_inv=1-beta1_inv;

% define beta2_inv tail can not only be zero
 %beta2_tail = 0.125;
 beta2_tail = 0.0;
 
% large-scale 
 center_l=1; Radius=6;
 for i=1:modelresolution/2+1
   wgt_l(i) = exp((-(i-center_l)^2)/(2*(Radius)^2));
 end
 
 % meso-scale
% center_m=18; Radius=6;
 center_m=35; Radius=16;
 for i=1:modelresolution/2+1
   wgt_m(i) = exp((-(i-center_m)^2)/(2*(Radius)^2));
 end
 wgt_m(center_l:center_m)=1-wgt_l(center_l:center_m);

 % small-scale 
 wgt_s=1-wgt_l-wgt_m;

 if (beta2_tail > beta2_inv) 
   beta2_tail = beta2_inv;
 end
 width = abs(beta1_inv-beta2_inv)+(beta1_inv-beta2_tail);
 shift = abs(beta2_inv-width);
 wgt=abs(width)*(wgt_m+wgt_l)+shift;

%------------------------------------------------------
 wgt_flipr = fliplr(wgt);

 %sdb_beta1_inv = [wgt wgt_flipr(2:end-1)]';
 %sdb_beta2_inv = 1 - sdb_beta1_inv;

 sdb_beta2_inv = [wgt wgt_flipr(2:end-1)]';
 sdb_beta1_inv = 1 - sdb_beta2_inv;
 
