clear all;

 L05_config

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

for t=1:t_end

  figure(1)
  %-------------------------- 
  disp(['time loop t=' num2str(t)])

  % Truth
  plot(Truth(:,t),'k-')
  axis([1 prefix.model.main.resolution -prefix.model.main.forcing*1 prefix.model.main.forcing*1]);
  hold on

  % Observations 
  plot(ObsPositions(:,t),Observations(:,t),'g*');
  hold on

  % label stuff
  plot(zeros(prefix.model.main.resolution,1),'k-');
  t_str=[ 'time=' num2str(t) ];
  text(10,5,t_str);
  hold on

  drawnow
  hold off

end  %end of time loop

