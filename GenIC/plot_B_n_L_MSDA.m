 modelresolution = 960;
 load L05_climo_B_12_MSDA_new.mat;
 figure;
 LR_l=15 ;
 LR_s=1  ;
 observation_error = 1; 

 % Localization
 L_l = L05_genL(modelresolution,LR_l);
 L_s = L05_genL(modelresolution,LR_s);

 %% large scale
 wgt=mean(diag(Bs_l))/observation_error;
 BEV=(diag(Bs_l)/wgt);
 Bs_l=L_l*diag(BEV);

 %% small scale 
% wgt=mean(diag(Bs_s))/(observation_error/10.);
 BEV=(diag(Bs_s)/wgt);
 Bs_s=L_s*diag(BEV);


 subplot(2,2,1);
 contourf(Bs_l), shading flat;
 caxis([-0.2, 0.6]);
 %colorbar('southoutside')
 title('Large Scale B')

 subplot(2,2,2);
 contourf(Bs_s), shading flat;
 caxis([-0.2, 0.6]);
 %colorbar('southoutside')
 %colorbar
 title('Small Scale B')


 subplot(2,2,[3 4]);
 %plot(Bs(:,480),'k--','Linewidth',1);
 %hold on;
 plot(Bs_l(:,480),'k','Linewidth',1);
 hold on;
 plot(Bs_s(:,480),'r','Linewidth',1);
 axis([1 960 -0.2 1])
 %legend('All','Large','Medium','Small')
 legend('Large','Small')
 title('Spatial Covariances')
 hold off;

 filename1 = [ 'MSDA_B' ];
 print(filename1,'-dpng')
 print(filename1,'-dpdf')

 figure;
 subplot(2,2,1);
 contourf(L_l), shading flat;
 title('Large Scale Localization')

 subplot(2,2,2);
 contourf(L_s), shading flat;
 title('Small Scale Localization')

 subplot(2,2,[ 3 4]);
 plot(L_l(:,480),'k','Linewidth',1);
 hold on;
 plot(L_s(:,480),'r','Linewidth',1);
 axis([1 960 -0.1 1.1])
 legend('Large','Small')
 title('Spatial Localization Functions')
 hold off;

 filename2 = [ 'MSDA_L' ];
 print(filename2,'-dpng')
 print(filename2,'-dpdf')

 
