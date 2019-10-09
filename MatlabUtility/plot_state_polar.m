clear all;

%prefix.model.main.resolution=960;
%prefix.ensemblesize=20;
%prefix.model.main.forcing=15;
%lens=1;

%prefix.da.system='3DVAR';
%prefix.da.system='LETKF';
% prefix.da.system='';

 L05_namelist

% Define file name
file_truth    = file.output.truth;
file_analy    = file.output.analy.main;
file_bckgd    = file.output.bckgd.main;

file_obsdata  = file.output.obsdata;
file_obsposi  = file.output.obsposi;

file_analy_ens= file.output.analy.ens;
file_bckgd_ens= file.output.bckgd.ens;
file_xbinc    = file.output.xbinc;
file_xeinc    = file.output.xeinc;

%----------------------------------------------------------
fid=fopen(file_truth,'r');
Truth=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
t_end=size(Truth,2)
fclose(fid);

fid=fopen(file_obsdata,'r');
Observations=fscanf(fid,'%f',[obs.numbers Inf]);
fclose(fid);

fid=fopen(file_obsposi,'r');
ObsPositions=fscanf(fid,'%d',[obs.numbers Inf]);
fclose(fid);

if  strcmp(prefix.da.system,'3DVAR') || strcmp(prefix.da.system,'3DHYB')
 fid=fopen(file_bckgd,'r');
 Bckgrd=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
 fclose(fid);

 fid=fopen(file_analy,'r');
 Analysis=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
 fclose(fid);
 
 fid=fopen(file_xbinc,'r');
 Xbinc=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
 fclose(fid);
 
 fid=fopen(file_xeinc,'r');
 Xeinc=fscanf(fid,'%f',[prefix.model.main.resolution Inf]);
 fclose(fid);
end

if  strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
 fid=fopen(file_bckgd_ens,'r');
 Bckgrd_ens=fscanf(fid,'%f',[prefix.model.ens.resolution Inf]);
 Bckgrd_ens=reshape(Bckgrd_ens,prefix.model.ens.resolution,prefix.ensemblesize,[]);
 fclose(fid);

 fid=fopen(file_analy_ens,'r');
 Analysis_ens=fscanf(fid,'%f',[prefix.model.ens.resolution Inf]);
 Analysis_ens=reshape(Analysis_ens,prefix.model.ens.resolution,prefix.ensemblesize,[]);
 fclose(fid);
end

for t=1:t_end
  if  strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
    nsamp = size(Bckgrd_ens(:,:,t),2); disp(['number of samples: ' int2str(nsamp)])
    % ensemble mean
    xm = mean(Bckgrd_ens(:,:,t),2);
    % remove the mean from teh ensemble (XbM is a matrix version of xbm)
    [tmp Xm] = meshgrid(ones(nsamp,1),xm);
    Xp = Bckgrd_ens(:,:,t) - Xm;
    spd = diag(sqrt(Xp*Xp'/(nsamp-1)));
  end

  disp(['time loop t=' num2str(t)])

  figure(1)
  theta = (360./prefix.model.ens.resolution).*linspace(0,prefix.model.ens.resolution,prefix.model.ens.resolution+1);
  theta_radians = deg2rad(theta);
 
   
  for imem=1:prefix.ensemblesize
    plotdata(2:prefix.model.ens.resolution+1) = Bckgrd_ens(1:prefix.model.ens.resolution,imem,t);
    plotdata(1) = Bckgrd_ens(prefix.model.ens.resolution,imem,t);
  
    plt_b_ens=polarplot(theta_radians,plotdata,'c-');

    rlim([-30 20])
    hold all
  end

  theta = (360./prefix.model.main.resolution).*linspace(0,prefix.model.main.resolution,prefix.model.main.resolution+1);
  theta_radians = deg2rad(theta);

  plotdata(2:prefix.model.main.resolution+1) = Truth(:,t);
  plotdata(1) = Truth(prefix.model.main.resolution,t);
  plt_t=polarplot(theta_radians,plotdata,'k-','LineWidth',2);

  plotdata(2:prefix.model.main.resolution+1) = Bckgrd(:,t);
  plotdata(1) = Bckgrd(prefix.model.main.resolution,t);
  plt_b=polarplot(theta_radians,plotdata,'b-','LineWidth',2);

  if mod(t,20) == 0 
   plotdata(2:prefix.model.main.resolution+1) = Analysis(:,t);
   plotdata(1) = Analysis(prefix.model.main.resolution,t);
   plt_a=polarplot(theta_radians,plotdata,'r-','LineWidth',2);
  end

  theta = (360./prefix.model.main.resolution).*ObsPositions(:,t);
  theta_radians = deg2rad(theta);
  plt_o=polarscatter(theta_radians,Observations(:,t),'m*');

  t_str=[ 'Time Steps =' num2str(t) ];
  text(1,30,t_str,'FontSize',14);

  if mod(t,20) == 0 
    legend([plt_b_ens([1]),plt_t,plt_b,plt_a,plt_o],'Ensemble','Truth','Bckgrd','Analysis','Obs.','Location','northoutside','Orientation','horizontal')
  else
    legend([plt_b_ens([1]),plt_t,plt_b,plt_o],'Ensemble','Truth','Bckgrd','Obs.','Location','northoutside','Orientation','horizontal')
  end

  hold off
  drawnow

  pause;
end  %end of time loop

