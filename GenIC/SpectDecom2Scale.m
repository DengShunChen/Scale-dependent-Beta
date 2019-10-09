function [ X_l, X_s ] = SpectDecom2Scale(X,modelresolution)
% Spectral Decompositions  
% decompose to three different scale, large, mediom and small

 % Create weightings  
 wgt_l(1:modelresolution/2+1)=0.;

 % large-scale 
 center_l=1; Radius=30;
 for i=1:modelresolution/2+1
   wgt_l(i) = exp((-(i-center_l)^2)/(2*(Radius)^2));
 end
 wgt_l_flipr = fliplr(wgt_l);
 
 % small-scale 
 wgt_s=1-wgt_l;
 wgt_s_flipr = fliplr(wgt_s);

 waveband_l = [wgt_l wgt_l_flipr(2:end-1)]';
 waveband_s = [wgt_s wgt_s_flipr(2:end-1)]';
 
 X_fft=fft(X);

 X_l_fft = diag(waveband_l)*X_fft;
 X_s_fft = diag(waveband_s)*X_fft;
 
 X_l = ifft(X_l_fft);
 X_s = ifft(X_s_fft);
