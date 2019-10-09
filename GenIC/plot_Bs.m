
  prefix.model.main.resolution=960; 

  load data_GenBsPool_.mat
  %maxBs=max(diag(B)); minBs=min(diag(B));
  
  maxBs=max(max(B)); minBs=min(min(B));
  Bs1=(B/(maxBs-minBs))*2;

  load data_GenBs_.mat
  %maxBs=max(diag(B)); minBs=min(diag(B));
  maxBs=max(max(B)); minBs=min(min(B));
  Bs2=(B/(maxBs-minBs))*2;

  load data_GenBsRich_.mat
  %maxBs=max(diag(B)); minBs=min(diag(B));
  maxBs=max(max(B)); minBs=min(min(B));
  Bs3=(B/(maxBs-minBs))*2;

  % frame 1
  subplot(2,3,1);
  factor=1.0;
  LR=15;
  Bs_L = L05_genL(prefix.model.main.resolution,LR);
  tmp=Bs1*factor;
  Bs1=Bs_L.*tmp;

  contourf(Bs1),  shading flat;
  caxis([0 1.0]);

  title('Bs Poor')
  colorbar

  % frame 1
  subplot(2,3,2);
  factor=1.0;
  LR=15;
  Bs_L = L05_genL(prefix.model.main.resolution,LR);
  tmp=Bs2*factor;
  Bs2=Bs_L.*tmp;

  contourf(Bs2),  shading flat;
  caxis([0 1.0]);

  title('Bs')
  colorbar

  % frame 1
  subplot(2,3,3);
  factor=1.0;
  LR=15;
  Bs_L = L05_genL(prefix.model.main.resolution,LR);
  tmp=Bs3*factor;
  Bs3=Bs_L.*tmp;

  contourf(Bs3),  shading flat;
  caxis([0 1.0]);

  title('Bs Rich')
  colorbar
 
  subplot(2,3,[4 5 6]);
  plot(diag(Bs1),'-r');
  hold all;
  plot(diag(Bs2),'-g');
  plot(diag(Bs3),'-b');
  plot(Bs1(:,480),'or');
  plot(Bs2(:,480),'og');
  plot(Bs3(:,480),'ob');
  axis([1 960 0 1.0 ]);
 
  legend('Bs Poor', 'Bs' ,'Bs Rich') 

  hold off
 
 filename = [ 'BsExp' ];
 print(filename,'-dpng')
 print(filename,'-dpdf')

