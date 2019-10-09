
%loading settings
prefix.model.main.resolution=960;
prefix.da.beta1_inv=0.10;
prefix.expname='SDB'
[prefix.da.sd_beta1_inv, prefix.da.sd_beta2_inv] = ...
              GenSDBeta(prefix.da.beta1_inv,prefix.model.main.resolution);


figure(1)
semilogx(prefix.da.sd_beta1_inv,'b-o');
hold on
semilogx(prefix.da.sd_beta2_inv,'r-o')

xlabel('Total Wavenumber')
ylabel('Weights')
title([ 'Scale-dependent Weighting - ' prefix.expname ])
legend('Static','Ensemble','Location','Northwest')
axis([1 481 -0.2 1.2])
print(['SDBeta_' prefix.expname ],'-dpng')
print(['SDBeta_' prefix.expname ],'-dpdf')


hold off
