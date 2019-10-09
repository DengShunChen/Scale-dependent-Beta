
clc; 
clear all;

% configuration
 L05_config

 prefix.model.maxtime = 5000;
 rand('seed',20);

% Generating arrays
 truth1    =ones(prefix.model.main.resolution,1)*prefix.model.main.forcing;
 truth2    =ones(prefix.model.main.resolution,1)*prefix.model.main.forcing;
 truth3    =ones(prefix.model.main.resolution,1)*prefix.model.main.forcing;

% Apply perturbation
 truth1(prefix.model.main.resolution/2)=truth1(prefix.model.main.resolution/2)+initial_model_perturbation1;
 truth2(prefix.model.main.resolution/2)=truth2(prefix.model.main.resolution/2)+initial_model_perturbation1;
 truth3(prefix.model.main.resolution/2)=truth3(prefix.model.main.resolution/2)+initial_model_perturbation1;
 

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
% writerObj = VideoWriter('lorenz2005_demo.avi','Uncompressed AVI');
% open(writerObj);
% Need to change from the default renderer to zbuffer to get it to work right.
% openGL doesn't work and Painters is way too slow.
%set(gcf, 'renderer', 'zbuffer');
axis tight manual
set(gca,'nextplot','replacechildren'); 

% Forward model 
 for t=1:prefix.model.maxtime 
   disp(['Spin up model, looping ' num2str(prefix.model.maxtime) ' time steps ....' num2str(t) ]) 
   % Runge-Kutta coefficients

   truth1 = L05_model_1(truth1,prefix.model.main,prefix.model.timestep);
   truth2 = L05_model_2(truth2,prefix.model.main,prefix.model.timestep);
   truth3 = L05_model_3(truth3,prefix.model.main,prefix.model.timestep);

  theta = (360./prefix.model.main.resolution).*linspace(0,prefix.model.main.resolution,prefix.model.main.resolution+1);
  theta_radians = deg2rad(theta);

  plotdata(2:prefix.model.main.resolution+1) = truth1;
  plotdata(1) = truth1(prefix.model.main.resolution);
  plt_m1=polarplot(theta_radians,plotdata,'k-','LineWidth',2);

  hold on;
  plotdata(2:prefix.model.main.resolution+1) = truth2;
  plotdata(1) = truth2(prefix.model.main.resolution);
  plt_m2=polarplot(theta_radians,plotdata,'b-','LineWidth',2);

  plotdata(2:prefix.model.main.resolution+1) = truth3;
  plotdata(1) = truth3(prefix.model.main.resolution);
  plt_m3=polarplot(theta_radians,plotdata,'r-','LineWidth',2);

  axis('tight')
  rlim([-30 20])

  t_str=[ 'TimeStep=' num2str(t) ];
  text(1,30,t_str,'FontSize',14);

  legend([plt_m1,plt_m2,plt_m3],'Model I','Model II','Model III','Location','northoutside','Orientation','horizontal')
  
 %drawnow
  hold off
 % thisFrame = getframe(gcf);
 % writeVideo(writerObj, thisFrame);
 % myMovie(t) = thisFrame;
 end


%close(writerObj);
%message = sprintf('Done creating movie\nDo you want to play it?');
%button = questdlg(message, 'Continue?', 'Yes', 'No', 'Yes');
%drawnow;  % Refresh screen to get rid of dialog box remnants.
%close(hFigure);
%if strcmpi(button, 'No')
%   return;
%end

%hFigure = figure;
% Enlarge figure to full screen.
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%title('Playing the movie we created', 'FontSize', 15);
% Get rid of extra set of axes that it makes for some reason.
%axis off;
% Play the movie.
%movie(myMovie);

%uiwait(helpdlg('Done with demo!'));

%close(hFigure);
