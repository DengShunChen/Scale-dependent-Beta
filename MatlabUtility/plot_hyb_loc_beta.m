 clc;
 clear all;

figure
xtick = 5:5:50 ;
ytick = 0:0.1:1.0 ; 

% Imperfect model from prob(x,y) , x : inflation factor ; y : localization length
%prob(1:6,1) = [ 0.2227    0.1874    0.1784    0.1799    0.1889    0.2020 ]';
%prob(1:6,2) = [ 0.2116    0.1762    0.1670    0.1660    0.1708    0.1786 ]';
%prob(1:6,3) = [ 0.2132    0.1797    0.1675    0.1649    0.1687    0.1736 ]';
%prob(1:6,4) = [ 0.2169    0.1797    0.1699    0.1667    0.1693    0.1743 ]';
%prob(1:6,5) = [ 0.2255    0.1876    0.1730    0.1702    0.1726    0.1756 ]';
%prob(1:6,6) = [ 0.2328    0.1925    0.1785    0.1746    0.1743    0.1785 ]';
%prob(1:6,7) = [ 0.2426    0.1987    0.1838    0.1762    0.1787    0.1804 ]';
%prob(1:6,8) = [ 0.2532    0.2055    0.1872    0.1814    0.1816    0.1842 ]'; 

% Imperfect model from prob(x,y) , x : hybrid weights ; y : localization length
prob(1:11,1) = [ 0.6110    0.5935    0.5804    0.5670    0.5322    0.5269    0.4877    0.4663    0.4262    0.3995   0.4641 ]';
prob(1:11,2) = [ 0.4799    0.4701    0.4871    0.4735    0.4535    0.4401    0.4146    0.4017    0.3851    0.3693   0.4641 ]';
prob(1:11,3) = [ 0.4326    0.4490    0.4369    0.4426    0.4307    0.4108    0.4105    0.3979    0.3809    0.3764   0.4641 ]';
prob(1:11,4) = [ 0.4258    0.4152    0.4171    0.4118    0.4124    0.4038    0.3853    0.3797    0.3789    0.3788   0.4641 ]';
prob(1:11,5) = [ 0.3937    0.4103    0.3986    0.3977    0.3962    0.3946    0.3914    0.3772    0.3728    0.3912   0.4641 ]';
prob(1:11,6) = [ 0.3785    0.3775    0.3966    0.3865    0.3928    0.3873    0.3890    0.3760    0.3855    0.3885   0.4641 ]';
prob(1:11,7) = [ 0.3715    0.3658    0.3892    0.3837    0.3906    0.3922    0.3710    0.3816    0.3762    0.3971   0.4641 ]';
prob(1:11,8) = [ 0.3751    0.3528    0.3839    0.3764    0.3893    0.3801    0.3770    0.3822    0.3980    0.4029   0.4641 ]';
prob(1:11,9) = [ 0.3649    0.3615    0.3692    0.3731    0.3791    0.3812    0.3733    0.3728    0.3826    0.3912   0.4641 ]';
prob(1:11,10) = [0.3529    0.3631    0.3612    0.3723    0.3856    0.3784    0.3753    0.3847    0.3831    0.3963   0.4641 ]';

imagesc(xtick,ytick,prob)
%colormap(flipud(summer))
%colormap(flipud(hot))
%colormap(flipud(gray))
colormap(hot)
	colorbar

set(gca, ...
    'XAxisLocation','bottom', ...
    'XTick',xtick, ...
    'YTick',ytick, ...
    'Ydir','normal')

[rows,cols] = size(prob);

for i = 1:rows
  for j =  1:cols
    text(xtick(j),ytick(i),sprintf('%1.3f',prob(i,j)),...
      'FontSize', 12, ...
      'Color','green', ...
      'HorizontalAlignment','center',...
      'FontWeight','bold');
  end
end
  
xlabel('Localization Length (grid)')
ylabel('Hybrid Weights')

print('hybtune_loc_beta','-dpng')
print('hybtune_loc_beta','-dpdf')

figure;

newpoints = 100;
[xq,yq] = meshgrid(...
            linspace(min(min(xtick,[],2)),max(max(xtick,[],2)),newpoints ),...
            linspace(min(min(ytick,[],1)),max(max(ytick,[],1)),newpoints )...
          );
probq = interp2(xtick,ytick,prob,xq,yq,'cubic');

[c,h]=contourf(xq,yq,probq,25);
title('Hybrid 3DEnVar Senstivity Test')
%[c,h]=contourf(xtick,ytick,prob,100,'LineColor','none');
clabel(c,h);
h.LineWidth = 2;

colormap(flipud(hot))
colorbar

set(gca, ...
    'XAxisLocation','bottom', ...
    'XTick',xtick, ...
    'YTick',ytick, ...
    'Ydir','normal')

xlabel('Localization Length (grid)')
ylabel('Hybrid Weights')

print('hybtune_loc_beta','-dpng')
print('hybtune_loc_beta','-dpdf')
