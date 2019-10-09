function [ Y ] = SpectDecom(X,modelresolution)
% Spectral Decompositions  
% decompose to three different scale, large, mediom and small

 % Create weightings  
 wgt_l(1:modelresolution/2+1)=0.;

%%--case 1------------------------------------%%
%% large-scale 
%center_l=1; Radius=30;
%for i=1:modelresolution/2+1
% wgt_l(i) = exp((-(i-center_l)^2)/(2*(Radius)^2));
%end
%wgt_l_flipr = fliplr(wgt_l);

%% small-scale 
%wgt_s=1-wgt_l;
%wgt_s_flipr = fliplr(wgt_s);

%%--end of case 1-----------------------------%%
%%--case 2------------------------------------%%
%% large-scale 
 center_l=1; Radius=6;
 for i=1:modelresolution/2+1
   wgt_l(i) = exp((-(i-center_l)^2)/(2*(Radius)^2));
 end

%% meso-scale
% center_m=18; Radius=6;
 center_m=18; Radius=20;
 for i=1:modelresolution/2+1
   wgt_m(i) = exp((-(i-center_m)^2)/(2*(Radius)^2));
 end
 wgt_m(center_l:center_m)=1;

%% final large scale 
 wgt_l=wgt_m;
 wgt_l_flipr = fliplr(wgt_l);

%% small-scale 
 wgt_s=1.-wgt_l;
 wgt_s_flipr = fliplr(wgt_s);

%%--end of case 2-----------------------------%%

 waveband_l = [wgt_l wgt_l_flipr(2:end-1)]';
 waveband_s = [wgt_s wgt_s_flipr(2:end-1)]';
 
 X_fft=fft(X);

 X_l_fft = diag(waveband_l)*X_fft;
 X_s_fft = diag(waveband_s)*X_fft;
 
 Y.l = ifft(X_l_fft);
 Y.s = ifft(X_s_fft);
