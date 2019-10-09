 load data_ModelErr.mat

 X1_bar=mean(X1,1);
 X2_bar=mean(X2,1);
 diff=mean(X2-X1,1);

 % frame 1
 subplot(2,1,1);
 plot(X1(480,:),'-r','LineWidth',1.5);
 hold all;
 plot(X2(480,:),'-b','LineWidth',1.5);

 title('The Model States at Middel Point');
 xlabel('Time Steps')
 ylabel('Values')
 Labels = {'Truth(F=15)' 'Model(F=14)'}
 legend(Labels,'Location','North','Orientation','horizontal')

 % frame 2
 subplot(2,1,2);
 plot(X2(480,:)-X1(480,:),'-g','LineWidth',1.5);
 hold on;
 ave = mean(X2(480,:)-X1(480,:));
 spd = std(X2(480,:)-X1(480,:));
 meanval(1:size(X1_bar,2)) = ave;
 stdval(1:size(X1_bar,2)) = spd;
 plot(meanval,'-k','LineWidth',1.5);
 plot(meanval+stdval,'--k','LineWidth',1.5);
 plot(meanval-stdval,'--k','LineWidth',1.5);

 title(['MEAN = ' num2str(ave) ', STD = ' num2str(spd) ])
 xlabel('Time Steps')
 ylabel('Values')
 Labels = { 'Global Mean of Model-Truth'}
 legend(Labels,'Location','North','Orientation','horizontal')

 hold off

 filename = [ 'FreeRun2' ];
 print(filename,'-dpng')
 print(filename,'-dpdf')

