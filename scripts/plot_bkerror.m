 prefix.model.main.resolution =960; 
 prefix.model.main.I          =12;
 prefix.da.observation_error  =1.0;
 prefix.da.LR                 =15;
 
 datapath='/Users/dschen/Matlab_LorenzModel/data/';
 file.input.B = [ datapath 'L05_climo_B_' num2str(prefix.model.main.I) '.mat'];

 load(file.input.B);

 [Bs_L] = L05_genL(prefix.model.main.resolution,prefix.da.LR);
 Bs.new = sqrt(diag(B))*sqrt(diag(B))';
 wgt = prefix.da.observation_error / mean(diag(Bs.new));
 Bs.new = Bs.new * wgt;

 [Bs_L] = L05_genL(prefix.model.main.resolution,prefix.da.LR);
 Bs.old = Bs_L.*B;
 wgt = prefix.da.observation_error / mean(diag(Bs.old));
 Bs.old = Bs.old * wgt; 

 % plot 
 figure;
 [X,Y] = meshgrid(1:960,1:960);
 s = surf(X,Y,B,'FaceAlpha',0.5);
 s.EdgeColor = 'none';
 axis([1 prefix.model.main.resolution 1 prefix.model.main.resolution ]);

 figure;
 [X,Y] = meshgrid(1:960,1:960);
 s = surf(X,Y,Bs.old,'FaceAlpha',0.5);
 s.EdgeColor = 'none';
 axis([1 prefix.model.main.resolution 1 prefix.model.main.resolution ]);

 figure;
 [X,Y] = meshgrid(1:960,1:960);
 s = surf(X,Y,Bs_L,'FaceAlpha',0.5);
 s.EdgeColor = 'none';
 axis([1 prefix.model.main.resolution 1 prefix.model.main.resolution ]);
  
