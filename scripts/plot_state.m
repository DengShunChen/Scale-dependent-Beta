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
%for t=3500:t_end-1
  if  strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
    nsamp = size(Bckgrd_ens(:,:,t),2); disp(['number of samples: ' int2str(nsamp)])
    % ensemble mean
    xm = mean(Bckgrd_ens(:,:,t),2);
    % remove the mean from teh ensemble (XbM is a matrix version of xbm)
    [tmp Xm] = meshgrid(ones(nsamp,1),xm);
    Xp = Bckgrd_ens(:,:,t) - Xm;
    spd = diag(sqrt(Xp*Xp'/(nsamp-1)));
  end

  figure(1)
  %-------------------------- 
  subplot(3,1,1);
  disp(['time loop t=' num2str(t)])

  % Ensemble
  if  strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
    %for j=1:prefix.ensemblesize
      %plot(Analysis_ens(:,j,t),'c-')
      plot(prefix.model.ens.bins,Bckgrd_ens(:,:,t),'c-')
      hold all
    %end
  end

  % Truth
  plot(Truth(:,t),'k-')
  axis([1 prefix.model.main.resolution -prefix.model.main.forcing*1 prefix.model.main.forcing*1]);

  % Analysis
  if  strcmp(prefix.da.system,'LETKF')
    Analysis(:,t)=mean(Analysis_ens(:,:,t),2);
    plot(prefix.model.ens.bins,Analysis(:,t),'r-')
  else
    plot(Analysis(:,t),'r-')
  end

  % Bckgrd
  if  strcmp(prefix.da.system,'LETKF')
     Bckgrd(:,t)=mean(Bckgrd_ens(:,:,t),2);
     plot(prefix.model.ens.bins,Bckgrd(:,t),'b-')
  end
  if strcmp(prefix.da.system,'3DHYB') || strcmp(prefix.da.system,'3DVAR')
    plot(Bckgrd(:,t),'b-')
  end

  % Observations 
  plot(ObsPositions(:,t),Observations(:,t),'g*');

  % label stuff
  plot(zeros(prefix.model.main.resolution,1),'k-');
  t_str=[ 'time=' num2str(t) ];
  text(10,5,t_str);

  %legend('Truth','Analysis','Bckgrd','Location','northoutside','Orientation','horizontal')
  hold off

  %===================================================================================%
  subplot(3,1,2);

  % Analysis Error Variance
  if  strcmp(prefix.da.system,'LETKF')
    xa_err=Truth(prefix.model.ens.bins,t)-Analysis(:,t);
    plot(prefix.model.ens.bins,xa_err(:),'r-'); 
  else
    xa_err=Truth(:,t)-Analysis(:,t);
    plot(xa_err(:),'r-'); 
  end
 
  % xa_err_var=sqrt(xa_err.*xa_err);
  % plot(xa_err_var(:),'r-'); 

  hold on

  if strcmp(prefix.da.system,'3DHYB') || strcmp(prefix.da.system,'3DVAR')
  % Analysis Increment (A-B) 
   inc=Analysis(:,t)-Bckgrd(:,t);
   plot(inc(:),'b-'); 
  %inc_var=sqrt(inc.*inc);
  %plot(inc_var(:),'b-'); 

  % Background Error  
   fcst_err=Truth(:,t)-Bckgrd(:,t);
   plot(fcst_err(:),'g-'); 
  %fcst_err_var=sqrt(fcst_err.*fcst_err);
  %plot(fcst_err_var(:),'g-');
   axis([1 prefix.model.main.resolution -1.0 1.0 ]);
  end
  if  strcmp(prefix.da.system,'LETKF') || strcmp(prefix.da.system,'3DHYB')
    plot(prefix.model.ens.bins,spd(:),'c-'); 
  % xa_var_bar=repmat(mean(xa_var),prefix.model.main.resolution);
  % plot(xa_var_bar(:),'r-');
   axis([1 prefix.model.main.resolution -1.0 1.0 ]);
   %axis([1 prefix.model.main.resolution -0.5 0.5 ]);
  end

  if  strcmp(prefix.da.system,'LETKF') 
   legend('AnaErr','Spread','Location','northoutside','Orientation','horizontal')
  elseif strcmp(prefix.da.system,'3DHYB') || strcmp(prefix.da.system,'3DVAR')
   %legend('AnaErr','AnaInc','BackErr','Spread','Location','northoutside','Orientation','horizontal')
  end   

  hold off
  %===================================================================================%
  subplot(3,1,3);
  if  strcmp(prefix.da.system,'LETKF')
    Xbinc(:,t)=0.;
    Xeinc(:,t)=0.;
  end 
 
  plot(Xbinc(:,t),'b-');
  hold on
  
  plot(Xeinc(:,t),'r-');
  axis([1 prefix.model.main.resolution -0.5 0.5 ]);

  hold off

  pause;
end  %end of time loop

