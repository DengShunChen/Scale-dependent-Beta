 modelresolution = 960;
 load L05_climo_B_12_new.mat;
 figure;
 observation_error = 1; 

 % Localization
 Local = L05_genL(modelresolution,20);

 % Background Error Covariance
 wgt=mean(diag(Bs))/observation_error;
 BEV=(diag(Bs)/wgt);
 L = L05_genL(modelresolution,15);
 Bs_origin=Bs/wgt;
 Bs_modify=L*diag(BEV);

 cMap=jet(256);

 subplot(3,4,[1 2 5 6]);
 [c,h]=contourf(Bs_origin);
 shading interp;
 set(h, 'edgecolor','none');
 colormap(cMap);
 caxis([-2, 2]);
 title('Original Spatial Covariances')

 subplot(3,4,[3 4 7 8]);
 [c,h]=contourf(Bs_modify);
 shading interp;
 set(h, 'edgecolor','none');
 caxis([-2, 2]);
 colormap(cMap);
 title('Modified Spatial Covariances')

 subplot(3,4,[9 10 11 12]);
 plot(Local(:,480),'k','Linewidth',1);
 hold on;
 plot(L(:,480),'r','Linewidth',1);
 axis([1 modelresolution -0.2 1.1])
 xticks([1 80 180 280 380 480 580 680 780 880 960])
 xticklabels({'-480','-400','-300','-200','-100','0','100','200','300','400','480'})
 xlabel('model grids')
 ylabel('values')
 legend('Localization, L=20','Bs decorr. length=15')
 title('Localization')
 hold off;

 filename1 = [ 'Bs_L' ];
 print(filename1,'-dpng')
 print(filename1,'-dpdf')


 
