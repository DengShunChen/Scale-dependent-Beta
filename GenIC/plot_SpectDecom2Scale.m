function rs = SpectDecom2Scale()
% Spectral Decompositions  
% decompose to three different scale, large, mediom and small

 modelresolution=960
 % Create weightings  
 wgt_l(1:modelresolution/2+1)=0.;

%% large-scale 
%center_l=1; Radius=30;
%for i=1:modelresolution/2+1
%  wgt_l(i) = exp((-(i-center_l)^2)/(2*(Radius)^2));
%end
%wgt_l_flipr = fliplr(wgt_l);
%
%% small-scale 
%wgt_s=1-wgt_l;
%wgt_s_flipr = fliplr(wgt_s);

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

%% small-scale 
 wgt_s=1-(wgt_m);


% plot weighting function 
 semilogx(wgt_m,'k','Linewidth',1.5);
 %plot(wgt_l,'k','Linewidth',1.5);
 hold on;
% semilogx(wgt_m,'b','Linewidth',1.5);
 %plot(wgt_l,'k','Linewidth',1.5);
% hold on;
 semilogx(wgt_s,'r','Linewidth',1.5);
 %plot(wgt_s,'r','Linewidth',1.5);
%legend('Large','Median','Small','Location','best');
 legend('Large','Small','Location','best');
 axis([1 480 -0.1 1.1])

 xlabel('Wavenumber');
 ylabel('Spectral filter coefficient')
 hold off
 print('BandPassFunction','-dpng')
 print('BandPassFunction','-dpdf')
