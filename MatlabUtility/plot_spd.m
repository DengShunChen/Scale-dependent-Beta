clear all;

%expname='h3dw10'
%name.data1 ='h3dw10l05m10';
%name.data2 ='h3dw10l10m10';
%name.data3 ='h3dw10l15m10';
%name.data4 ='h3dw10l20m10';
%name.data5 ='h3dw10l25m10';
%name.data6 ='h3dw10l30m10';
%name.data7 ='h3dw10l35m10';

 expname='SDB'
% name.data1='3dvar';
 name.data1='h3dctl';
 name.data2='h3dsdb';
 name.data3='h3dfull';


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
 
  fname = fields(name);
  nexps = length(fname) ; 

%== Uper panel ================================================================% 
figure;

for exps=1:length(fname)
  % Define file name
  file_spd    =[ name.(fname{exps}) '/output_spd.txt']
 
  % Get Truth
  fid=fopen(file_spd,'r'); SPD=fscanf(fid,'%f'); fclose(fid);

  t_end=size(SPD,1); 
  time.(fname{exps})=t_end
    
  hplot(exps)=plot(SPD,'Color',color.(fname{exps}),'LineStyle',LineStyle.fram1,'LineWidth',1.5)
  hold on 
 
  if final_end<t_end
    final_end=t_end;
  end 
end
 
legend(hplot,upper(Labels),'Location','NorthEast','Orientation','horizontal')
axis([begin_start final_end 0.0 1.5]); 
title('Ensemble Spread')
xlabel('Time Steps')
ylabel('Values')

filename = [ 'SPREAD_' expname ];
print(filename,'-dpng')
 print(filename,'-dpdf')




