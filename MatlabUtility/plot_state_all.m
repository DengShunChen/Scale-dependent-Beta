clear all;

  expname='SDB'

  name.data1='3dvar';
  name.data2='h3dctl';
  name.data3='h3dfull';
  name.data4='h3dsdb';
%  name.data5='letkf';

% expname='SDL'
% name.data1='3dvar';
% name.data2='h3dctl';
% name.data3='h3dsdb';
% name.data4='h3dsdl';

% expname='MSDA'
% name.data1='3dvar';
% name.data1='h3dctl';
% name.data2='h3dsdb';
% name.data3='h3dsdl';
% name.data4='h3dmsda';

  Labels = struct2cell(name);
% Labels = { '3DVAR' 'H3DENV' 'H3DSDB'}
%Labels = { '3DVAR' 'H3DENV' 'H3DSDB' 'H3DSDL'}

  begin_start = 500;
% begin_start =  20;

  final_end = 0;   % initialized
  modelresolution=960;
  reduced_factor=1;
  modelresolution_ens=modelresolution/reduced_factor;
  bins.ens = [1:reduced_factor:modelresolution]';
  bins.main = [1:modelresolution]';
  
  zeroline=zeros(960,1);

  ensemblesize.data1=20;
  ensemblesize.data2=20;
  ensemblesize.data3=20;
  ensemblesize.data4=20;
  ensemblesize.data5=20;
 
  forcing=15;
 
  color.data1=[0.0 ,0.0 ,0.0 ];
  color.data2=[0.0 ,0.0 ,1.0 ];
  color.data3=[1.0 ,0.0 ,0.0 ];
  color.data4=[0.0 ,1.0 ,0.0 ];
  color.data5=[1.0 ,0.75,0.75];
  color.data6=[1.0 ,0.0 ,1.0 ];
  color.data7=[0.5 ,0.5 ,0.0 ];
  color.data8=[0.0 ,0.5 ,0.5 ];
 
  LineStyle.fram1='-';
  LineStyle.fram2='--';
 
  fname = fields(name);
  nexps = length(fname) ; 

%======================== Read data ===================
for exps=1:length(fname)
  % Define file name
  file_truth    =[ name.(fname{exps}) '/output_truth.txt']
  file_analy    =[ name.(fname{exps}) '/output_analy.txt']
  file_analy_ens=[ name.(fname{exps}) '/output_analy_ens.txt']
 
  % Get Truth
  fid=fopen(file_truth,'r'); Truth=fscanf(fid,'%f',[modelresolution Inf]); fclose(fid);

  t_end=size(Truth,2);
  if t_end == 5000 || t_end == 8000
    t_end=t_end;
  else
    t_end=t_end-1;
  end
 
  time.(fname{exps})=t_end
 
  % Get Analysis
  if  strcmp(name.(fname{exps})(1:5),'letkf') || strcmp(name.(fname{exps})(1:4),'LETK') || strcmp(name.(fname{exps})(1:2),'KF')
    fid=fopen(file_analy_ens,'r');
    Analysis_ens=fscanf(fid,'%f',[modelresolution_ens Inf]); 
    Analysis_ens=reshape(Analysis_ens,modelresolution_ens,ensemblesize.(fname{exps}),[]);
    fclose(fid);
  
    Analysis=mean(Analysis_ens,2);
    Analysis=reshape(Analysis,modelresolution_ens,[]);
    if reduced_factor ~= 1 
      Analysis=interpft(Analysis,modelresolution);
    end
  else
    fid=fopen(file_analy,'r');
    Analysis=fscanf(fid,'%f',[modelresolution Inf]);
    fclose(fid);
  end

  % error 
  xa_err.(fname{exps})=Truth(1:modelresolution,1:time.(fname{exps}))-Analysis(1:modelresolution,1:time.(fname{exps}));  
 
  if final_end<t_end
    final_end=t_end;
  end 
end

figure;

%== Uper panel ================================================================% 
subplot(2,1,1)
plot(zeroline,'-k');
hold on

for exps=2:length(fname)
  base_values=mean(abs(xa_err.(fname{1})),2);
  exps_values=mean(abs(xa_err.(fname{exps})),2);
  hplot(exps-1)=plot(exps_values-base_values,'Color',color.(fname{exps}),'LineStyle',LineStyle.fram1,'LineWidth',1.5)
  hold on 
end
 
legend(hplot,upper(Labels(2:length(fname))),'Location','NorthOutside','Orientation','horizontal')
axis([1 modelresolution -0.2 0.1]); 
hold off

xlabel('Model Grids')
ylabel('Mean Abs. Error')

%======== lower panel  ==========================================================% 
subplot(2,1,2)
plot(zeroline,'-k');
hold on

for exps=2:length(fname)
  base_values=sqrt(mean(xa_err.(fname{1}).^2.0,2));
  exps_values=sqrt(mean(xa_err.(fname{exps}).^2.0,2));
  hplot(exps-1)=plot(exps_values-base_values,'Color',color.(fname{exps}),'LineStyle',LineStyle.fram1,'LineWidth',1.5)
  hold on 
end
 
legend(hplot,upper(Labels(2:length(fname))),'Location','NorthOutside','Orientation','horizontal')
axis([1 modelresolution -0.2 0.1 ]); 
hold off

xlabel('Model Grids')
ylabel('RMS Error')


 filename = [ 'ME_RMSE_' expname ];
 print(filename,'-dpng')
 print(filename,'-dpdf')


