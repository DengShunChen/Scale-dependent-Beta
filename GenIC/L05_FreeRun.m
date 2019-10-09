
 clc;
 clear all;

% Initialization of Model Variables
 prefix.expname='FreeRun';
%------------------------------------------------------------

 prefix.model.maxtime		= 10000;

 prefix.reduced_factor		= 2;		% reduced resolution of ensemble 
 prefix.ensemblesize		= 10;

 prefix.model.reduced_factor	= prefix.reduced_factor; 
 prefix.model.timestep  	= 0.0025

 % Truth
 prefix.model.main1.resolution	= 960;
 prefix.model.main1.I		= 12;
 prefix.model.main1.K		= prefix.model.main1.resolution/30;
 prefix.model.main1.b		= 10.;          %  Lorez96_model_III
 prefix.model.main1.c		= 2.5;          %  Lorez96_model_III
 prefix.model.main1.forcing	= 15.0;

 % Model Error
 prefix.model.main2.resolution	= 960;
 prefix.model.main2.I		= 12;
 prefix.model.main2.K		= prefix.model.main2.resolution/30;
 prefix.model.main2.b		= 10.;          %  Lorez96_model_III
 prefix.model.main2.c		= 2.5;          %  Lorez96_model_III
 prefix.model.main2.forcing	= 14.0;

%------------------------------------------------------------

 % Define file name
 file.input.ColdStart	=['data_ColdStart.mat'];

 % Load array in
 load(file.input.ColdStart)

%----------------------------------------------------------------------------------%
 zero=zeros(prefix.model.main1.resolution,1);
 prefix.model.main1.index = [1:prefix.model.main1.resolution]';
 prefix.model.main2.index = [1:prefix.model.main2.resolution]';
%----------------------------------------------------------------------------------%
 field.truth1 = field.truth;
 field.truth2 = field.truth;

% Begin time cycle portion of the code
 for t=1:prefix.model.maxtime
 
   % Forward model 
    disp(['model integral from time ' num2str(t) ' to ' num2str(t+1)])
    field.truth1=L05_model_3(field.truth1,prefix.model.main1,prefix.model.timestep);
    field.truth2=L05_model_3(field.truth2,prefix.model.main2,prefix.model.timestep);
    X1(:,t)=field.truth1 ;
    X2(:,t)=field.truth2 ;
 end

 nsamp = size(X1,2); disp(['number of samples: ' int2str(nsamp)])
 save data_ModelErr.mat X1 X2
 
 X1_bar=mean(X1,1);
 X2_bar=mean(X2,1);
 diff=mean(X2-X1,1);

 % frame 1
 subplot(2,1,1);
 plot(X1_bar,'-r');
 hold all;
 plot(X2_bar,'-b');

 xlabel('Time Steps')
 ylabel('Values')
 Labels = {'Truth(F=15)' 'Model(F=14)'}
 legend(Labels,'Location','North','Orientation','horizontal')

 % frame 2
 subplot(2,1,2);
 plot(diff,'-g');

 xlabel('Time Steps')
 ylabel('Values')
 Labels = { 'Model-Truth'}
 legend(Labels,'Location','North','Orientation','horizontal')


 filename = [ 'FreeRun' ];
 print(filename,'-dpng')
 print(filename,'-dpdf')

