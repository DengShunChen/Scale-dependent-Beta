 load data_ModelErr.mat

 X1_bar=mean(X1,1);
 X2_bar=mean(X2,1);
 diff=mean(X2-X1,1);

 % frame 1
 subplot(2,1,1);
 plot(X1(:,1000),'-r','LineWidth',1.5);
 hold all;
 plot(X2(:,1000),'-b','LineWidth',1.5);
 plot(X2(:,1000)-X1(:,1000),'-g','LineWidth',1.5);

 axis([1 960 -20  20]);
 title('A Snapshot of Model States (Time Steps = 1000)');
 xlabel('Model Grids')
 ylabel('Values')
 Labels = {'Truth(F=15)' 'Model(F=14)' 'Model-Truth'}
 legend(Labels,'Location','North','Orientation','horizontal')

 % frame 2
 subplot(2,1,2);
 plot(std(X2(:,:)-X1(:,:)),'-g','LineWidth',1.5);

 xlabel('Time Steps')
 ylabel('Values')
 Labels = { 'STD of Model-Truth'}
 legend(Labels,'Location','North','Orientation','horizontal')

 hold off

 filename = [ 'ModelErr' ];
 print(filename,'-dpng')
 print(filename,'-dpdf')

