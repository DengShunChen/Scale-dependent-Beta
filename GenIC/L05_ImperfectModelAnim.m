
clc; 
clear all;

% configuration
 L05_config

 prefix.model.maxtime = 500;
 rand('seed',20);

% Read in initial truth state (spin up) 
 load(file_Init_Truth);

% Generating arrays
 bckgd = truth;

 prefix2=prefix;
 prefix2.model.main.forcing=14.0;
%--------------------------------------------------------------------------------
 hFigure = figure;
 set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
 numberOfFrames = prefix.model.maxtime;
% Set up the movie structure.
% Preallocate recalledMovie, which will be an array of structures.
% First get a cell array with all the frames.
allTheFrames = cell(numberOfFrames,1);
vidHeight = 500;
vidWidth = 500;
allTheFrames(:) = {zeros(vidHeight, vidWidth)};
% Next get a cell array with all the colormaps.
allTheColorMaps = cell(numberOfFrames,1);
allTheColorMaps(:) = {zeros(256)};
% Now combine these to make the array of structures.
 myMovie = struct('cdata', allTheFrames, 'colormap',allTheColorMaps);
% Create a VideoWriter object to write the video out to a new, different file.
 writerObj = VideoWriter('lorenz2005_imperfect_demo.avi','Uncompressed AVI');
 open(writerObj);
% Need to change from the default renderer to zbuffer to get it to work right.
% openGL doesn't work and Painters is way too slow.
%set(gcf, 'renderer', 'zbuffer');
axis tight manual
set(gca,'nextplot','replacechildren'); 

% Forward model 
 for t=1:prefix.model.maxtime 
   disp(['Spin up model, looping ' num2str(prefix.model.maxtime) ' time steps ....' num2str(t) ]) 
   % Runge-Kutta coefficients
   if prefix.model.type == 3
     truth = L05_model_3(truth,prefix.model.main,prefix.model.timestep);
     bckgd = L05_model_3(bckgd,prefix2.model.main,prefix.model.timestep);
   elseif prefix.model.type == 2
     truth = L05_model_2(truth,prefix.model.main,prefix.model.timestep);
     bckgd = L05_model_2(bckgd,prefix2.model.main,prefix.model.timestep);
   elseif prefix.model.type == 1
     truth = L05_model_1(truth,prefix.model.main,prefix.model.timestep);
     bckgd = L05_model_1(bckgd,prefix2.model.main,prefix.model.timestep);
   end

  theta = (360./prefix.model.main.resolution).*linspace(0,prefix.model.main.resolution,prefix.model.main.resolution+1);
  theta_radians = deg2rad(theta);

  plotdata(2:prefix.model.main.resolution+1) = truth;
  plotdata(1) = truth(prefix.model.main.resolution);
  plt_t=polarplot(theta_radians,plotdata,'k-','LineWidth',2);

  hold on;
  plotdata(2:prefix.model.main.resolution+1) = bckgd;
  plotdata(1) = bckgd(prefix.model.main.resolution);
  plt_b=polarplot(theta_radians,plotdata,'b-','LineWidth',2);

  axis('tight')
  rlim([-30 20])

  t_str=[ 'TimeStep=' num2str(t) ];
  text(1,30,t_str,'FontSize',14);

  legend([plt_t,plt_b],'Perfect (F=15)','Imperfect (F=14)','Location','northoutside','Orientation','horizontal')
  
  drawnow
  hold off
  thisFrame = getframe(gcf);
  writeVideo(writerObj, thisFrame);
  myMovie(t) = thisFrame;
 end


close(writerObj);

pause

message = sprintf('Done creating movie\nDo you want to play it?');
button = questdlg(message, 'Continue?', 'Yes', 'No', 'Yes');
drawnow;  % Refresh screen to get rid of dialog box remnants.
close(hFigure);
if strcmpi(button, 'No')
   return;
end

hFigure = figure;
% Enlarge figure to full screen.
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%title('Playing the movie we created', 'FontSize', 15);
% Get rid of extra set of axes that it makes for some reason.
axis off;
% Play the movie.
movie(myMovie);

uiwait(helpdlg('Done with demo!'));

close(hFigure);
