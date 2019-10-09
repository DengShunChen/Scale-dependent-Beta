clear all;


set_expname

%==================================================%
 ensemblesize.data1=10;
 ensemblesize.data2=10;
 ensemblesize.data3=10;
 ensemblesize.data4=10;
 ensemblesize.data5=10;
 ensemblesize.data6=10;
 ensemblesize.data7=10;
 ensemblesize.data8=10;
 
 color.data1=[0.0 ,0.0 ,0.0 ];
 color.data2=[0.0 ,0.0 ,1.0 ];
 color.data3=[1.0 ,0.0 ,0.0 ];
 color.data4=[0.0 ,1.0 ,0.0 ];
 color.data5=[1.0 ,0.75,0.75];
 color.data6=[1.0 ,0.0 ,1.0 ];
 color.data7=[0.5 ,0.5 ,0.0 ];
 color.data8=[0.0 ,0.5 ,0.5 ];
 color.data9=[0.0 ,0.5 ,0.75 ];
 color.data10=[0.25 ,0.25 ,0.5 ];

 
   Labels = struct2cell(name)
% Labels = { '3DVAR' 'H3DENV' 'H3DSDB'}
%  Labels = { 'L05' 'L10' 'L15' 'L20' 'L25' 'L30' 'L35'}

%  begin_start = 500;
  begin_start =  20;
  assimilate_interval = 20;
  begin_start =  1;
  assimilate_interval = 1;

  final_end = 0;   % end of verify period 0: depends on the data set
  modelresolution=960;
  reduced_factor=4;
  modelresolution_ens=modelresolution/reduced_factor;
  bins.ens = [1:reduced_factor:modelresolution]';
  bins.main = [1:modelresolution]';

  forcing=15;
 
  LineStyle.fram1='-';
  LineStyle.fram2='--';
  LineStyle.fram3='-.';
 
  fname = fields(name);
  nexps = length(fname) ; 

%== Uper panel ================================================================% 
figure;

subplot(3,1,[1 2])

for exps=1:length(fname)
  % Define file name
  file_truth    =[ './output_truth.txt']
 % file_truth    =[ name.(fname{exps}) '/output_truth.txt']
  file_analy    =[ name.(fname{exps}) '/output_analy.txt']
  file_analy_ens=[ name.(fname{exps}) '/output_analy_ens.txt']
  file_spd      =[ name.(fname{exps}) '/output_spd.txt']
 
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
  xa_err=Truth(1:modelresolution,1:time.(fname{exps}))-Analysis(1:modelresolution,1:time.(fname{exps}));

  % squre (error variance)
  xa_err_var=xa_err.*xa_err;

  % spatial average  
  xa_err_var_t=mean(xa_err_var,1);
 
  % root
  xa_rms_err_t=sqrt(xa_err_var_t);

  % time averaged rms error 
  xa_rms_err_bar(exps)=mean(xa_rms_err_t(begin_start:assimilate_interval:time.(fname{exps})))
  xa_rms_err_mean(1:time.(fname{exps}))=xa_rms_err_bar(exps);
 
  % 
  xa_err_var_bar(exps)=mean(xa_err_var_t(begin_start:assimilate_interval:time.(fname{exps})))
  xa_err_var_std(exps)= std(xa_err_var_t(begin_start:assimilate_interval:time.(fname{exps})))

  if strcmp(name.(fname{exps})(1:5),'3dvar') 
    fid=-999  
  else
    if isfile(file_spd)
      fid=fopen(file_spd,'r'); Spread=fscanf(fid,'%f'); fclose(fid);
      hold on 
      spd(exps)=plot(Spread,'Color',color.(fname{exps}),'LineStyle',LineStyle.fram2,'LineWidth',0.5,'DisplayName',append(upper(Labels{exps}),' Ens. spread'))
    end
  end
    
  hold on 
  rms(exps)=plot(xa_rms_err_t,'Color',color.(fname{exps}),'LineStyle',LineStyle.fram1,'LineWidth',1.2,'DisplayName',append(upper(Labels{exps}),' RMSE'))


  if final_end<t_end
    final_end=t_end;
  end 
end

for exps=1:length(fname)  
  xa_rms_err_mean(:)=xa_rms_err_bar(exps);
  subplot(3,1,[1 2])
%  plot(xa_rms_err_mean,'Color',color.(fname{exps}),'LineStyle',LineStyle.fram2,'LineWidth',1.5)
  hold on
end
 
%legend('Location','NorthOutside','Orientation','horizontal')
legend()
axis([begin_start final_end 0. 1.5]); 
hold off

xlabel('Time Steps')
ylabel('RMS Error')

%======== lower panel  ==========================================================% 
frame=subplot(3,1,3);
frame.Position=[0.1300 0.0800 0.7750 0.2157];
%bar(xa_err_var_bar);
%hold all;
x=1:exps;
for i1=1:numel(xa_err_var_bar)
%   bar(x(i1),xa_err_var_bar(i1),'facecolor',color.(fname{i1}));
 %h = errorbar(x(i1),xa_err_var_bar(i1),xa_err_var_std(i1),'Color',color.(fname{i1}),'Marker','.','MarkerSize',20);
  plot(x(i1),xa_rms_err_bar(i1),'Color',color.(fname{i1}),'Marker','.','MarkerSize',20);
  hold all;
%  errorbarT(h,0.1,2);  
% t = text(x(i1)+0.15,xa_err_var_bar(i1),num2str(xa_err_var_bar(i1),'%0.3f'),...
  t = text(x(i1)+0.15,xa_rms_err_bar(i1),num2str(xa_rms_err_bar(i1),'%0.4f'),...
              'HorizontalAlignment','center',...
              'VerticalAlignment','bottom','FontWeight', 'bold');
end

 set(gca, 'XTick', 1:length(fname), 'XTickLabel', upper(Labels));
 axis([0.5 length(fname)+0.5 0.4 0.65]); 
 title('Time Averaged RMS Errors')
 hold off

 filename = [ 'RMSE_' expname ];
 print(filename,'-dpng')
 print(filename,'-dpdf')




