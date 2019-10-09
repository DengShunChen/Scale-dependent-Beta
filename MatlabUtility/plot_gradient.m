clear all;

L05_namelist
expname='SDB'
name.data1='h3dctl';
name.data2='h3dsdb';

fname = fields(name);
nexps = length(fname) ;

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

Labels = struct2cell(name);
for exps=1:length(fname)
  file_gsta    =  [ name.(fname{exps}) '/' file.output.gsta];
  file_gens    =  [ name.(fname{exps}) '/' file.output.gens];

  %----------------------------------------------------------
  fid=fopen(file_gsta,'r');
  gsta.(fname{exps})=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
  fclose(fid);

  t_end.(fname{exps})=size(gsta.(fname{exps}),2)

  fid=fopen(file_gens,'r');
  gens.(fname{exps})=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
  gens.(fname{exps})=reshape(gens.(fname{exps}),prefix.model.main.resolution,prefix.ensemblesize,[]);
  fclose(fid);
end

figure(1)
for exps=1:length(fname)
  for t=t_end.(fname{exps}):t_end.(fname{exps})
  %for t=1:1

    subplot(2,1,1);
    disp(['time loop t=' num2str(t)])

    plot(gsta.(fname{exps})(:,t),'Color',color.(fname{exps}),'LineStyle',LineStyle.fram1,'LineWidth',1.5);
    hold all 

  end  %end of time loop
end %end of cases
hold off

for exps=1:length(fname)
  for t=t_end.(fname{exps}):t_end.(fname{exps})
  %for t=1:1

    subplot(2,1,2);
    plot(gens.(fname{exps})(:,:,t),'Color',color.(fname{exps}),'LineStyle',LineStyle.fram1,'LineWidth',1.5);
%  axis([1 prefix.model.main.resolution -prefix.model.main.forcing*1 prefix.model.main.forcing*1]);
    hold all

  end  %end of time loop
end %end of cases
hold off
