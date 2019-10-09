
%  load L05_climo_B_12.mat
  load L05_true_B_12.mat
  B=Bs;

  prefix.model.main.resolution=960; 
  maxBs=max(max(B)); minBs=min(min(B));
  Bs=(B/(maxBs-minBs));

  % frame 1
  subplot(2,2,1);
  factor=1;
  LR=15;
  Bs_L = L05_genL(prefix.model.main.resolution,LR);
  tmp=Bs*factor;
  Bs1=Bs_L.*tmp;

  contourf(Bs1),  shading flat;
  caxis([0 0.6]);

  colorbar

  % frame 1
  subplot(2,2,2);
  factor=1;
  LR=7;
  Bs_L = L05_genL(prefix.model.main.resolution,LR);
  tmp=Bs*factor;
  Bs2=Bs_L.*tmp;

  contourf(Bs2),  shading flat;
  caxis([0 0.6]);

  colorbar

  % frame 1
% subplot(2,2,3);
% factor=1.0;
% LR=7;
% Bs_L = L05_genL(prefix.model.main.resolution,LR);
% tmp=Bs*factor;
% Bs3=Bs_L.*tmp;

% contourf(Bs3),  shading flat;

% colorbar
 
 
  subplot(2,2,[3  4]);
  plot(diag(Bs1),'-k');
  hold all
  plot(Bs1(:,480),'-b');
  plot(Bs2(:,480),'-r');
  axis([1 960 0 0.6]);
  

  hold off
 
 filename = [ 'BsTrue' ];
 print(filename,'-dpng')
 print(filename,'-dpdf')

