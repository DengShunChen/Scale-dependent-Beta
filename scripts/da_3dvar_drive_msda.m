
function [analysis,xb_inc,xe_inc]=da_3dvar_drive_msda(field,obs,prefix)

  % Create observation operator 
  reduced_factor = 1;
  H = DualReso_H(prefix.model,obs,reduced_factor);
 
  % Generating Ensemble Pertubations
  if  strcmp(prefix.da.system,'3DHYB')
    % ft interp : lo to hi resolution
    for j=1:prefix.ensemblesize
       ensemble_h(:,j)=interpft(field.ensemble(:,j),prefix.model.main.resolution);
    end    

    nsamp = size(ensemble_h,2); disp(['number of samples: ' int2str(nsamp)])
    % ensemble mean
    xb_bar = mean(ensemble_h,2);
    xb_bar_m = repmat(xb_bar,1,prefix.ensemblesize);
    % remove the mean from teh ensemble (XbM is a matrix version of xbm)
    Xp_all = (ensemble_h - xb_bar_m) / sqrt(nsamp-1);

    modelresolution = prefix.model.main.resolution ;
    long_vector = prefix.model.main.resolution*prefix.ensemblesize ; 

    [ Xp ] = SpectDecom(Xp_all,modelresolution);
    Xp_v.l = reshape(Xp.l,[ long_vector 1]);
    Xp_v.s = reshape(Xp.s,[ long_vector 1]);
  end

  % Minimizations 
  tinny = 1e-5;   % size of step in direction of normalized J
  end_inner=[ 100 ]; % inner loop iteration times
  end_outer=size(end_inner,2);

  % initializing control vector 
  control_x_all = zeros(prefix.model.main.resolution*(2*(prefix.ensemblesize+1)),1);
  control_y_all = zeros(prefix.model.main.resolution*(2*(prefix.ensemblesize+1)),1);

  % start from 
  analysis = field.bckgd; 
    
  for j=1:end_outer
    niters = 1;

    Jold = 1e6; J = 0;

    % Initializing 
    control_d_x = zeros(prefix.model.main.resolution*(2*(prefix.ensemblesize+1)),1) ;
    control_d_y = zeros(prefix.model.main.resolution*(2*(prefix.ensemblesize+1)),1) ;
    control_f 	= zeros(prefix.model.main.resolution*(2*(prefix.ensemblesize+1)),1) ; 
    state_xtinc	= zeros(prefix.model.main.resolution*(2*(prefix.ensemblesize+1)),1) ;
   
    % Innovation 
    innov = obs.values - H*analysis ;

    [increment, control ] = Control2State_msda(control_y_all,Xp,prefix);

    [Jb, Jo, Je] = CostFunc2_msda(control.x,control.y,increment.total,innov,prefix.da.R_inv,H);
    J = Jo + Jb + Je;
    disp(['initial   cost = ' num2str(J) ...
          ' Jo = ' num2str(Jo)  ' Jb = ' num2str(Jb) ' Je = ' num2str(Je)  ])

    for i=1:end_inner(j)
         if abs(Jold - J) <= tinny ; break ; end
         Jold = J;
         
         [increment, control ] = Control2State_msda(control_y_all,Xp,prefix);

         % gradient of x 
         gradient.x.static.l = H'*prefix.da.R_inv*(H*increment.total-innov);
         gradient.x.static.s = H'*prefix.da.R_inv*(H*increment.total-innov);
         gradient.x.ensemble.l = Xp_v.l.*repmat(gradient.x.static.l,prefix.ensemblesize,1);        
         gradient.x.ensemble.s = Xp_v.s.*repmat(gradient.x.static.s,prefix.ensemblesize,1);        

         % apply bkerror, bkerror_a_en and beta12mult
         gradient.y.static.l 	= prefix.da.beta1_inv.l * prefix.da.Bs.l * gradient.x.static.l;
         gradient.y.static.s 	= prefix.da.beta1_inv.s * prefix.da.Bs.s * gradient.x.static.s;
         gradient.y.ensemble.l 	= prefix.da.beta2_inv.l * prefix.da.L.l  * ...
                  reshape(gradient.x.ensemble.l,[prefix.model.main.resolution prefix.ensemblesize]);
         gradient.y.ensemble.s 	= prefix.da.beta2_inv.s * prefix.da.L.s  * ...
                  reshape(gradient.x.ensemble.s,[prefix.model.main.resolution prefix.ensemblesize]);
          
         % gradients of new control variable y=(B^-1)x
         gradient.y.static.l 	= control.x.static.l 	+ gradient.y.static.l;
         gradient.y.static.s 	= control.x.static.s 	+ gradient.y.static.s;
         gradient.y.ensemble.l 	= control.x.ensemble.l	... 
                      + reshape(gradient.y.ensemble.l,[prefix.model.main.resolution*prefix.ensemblesize 1]);
         gradient.y.ensemble.s 	= control.x.ensemble.s	... 
                      + reshape(gradient.y.ensemble.s,[prefix.model.main.resolution*prefix.ensemblesize 1]);
        
         % gradients of control variable  x
         gradient.x.static.l 	= control.y.static.l 	+ gradient.x.static.l;
         gradient.x.static.s 	= control.y.static.s 	+ gradient.x.static.s;
         gradient.x.ensemble.l 	= control.y.ensemble.l	+ gradient.x.ensemble.l;
         gradient.x.ensemble.s 	= control.y.ensemble.s	+ gradient.x.ensemble.s;

         gradient_y_all = [ gradient.y.static.l; gradient.y.static.s; gradient.y.ensemble.l; gradient.y.ensemble.s ];
         gradient_x_all = [ gradient.x.static.l; gradient.x.static.s; gradient.x.ensemble.l; gradient.x.ensemble.s ];

         control_f = gradient_y_all - control_f;
         if niters == 1 % first iteration do a line search
           beta=0.;
         else
           beta = (gradient_y_all'*gradient_x_all)/(control_f);
           beta = (control_f'*gradient_y_all)/(control_f'*control_d_x);
         end
         control_f = gradient_y_all;

         control_d_x = - gradient_y_all + beta*control_d_x;
         control_d_y = - gradient_x_all + beta*control_d_y;

         % calculate step size
         options = optimset('MaxFunEvals',100000000);
         [alpha,minCostFunc]= fminsearch(@CostFunc_msda,0,options,control_y_all,control_d_y,Xp,prefix,innov,H); 
        
         % updating control variable 
         control_y_all = control_y_all + alpha*control_d_y;

         % update 
         [increment, control ] = Control2State_msda(control_y_all,Xp,prefix);

         % cost function
         [Jb, Jo, Je] = CostFunc2_msda(control.x,control.y,increment.total,innov,prefix.da.R_inv,H);
         J = Jo + Jb + Je;
         disp([' outer = ' num2str(j) '  iter = ' num2str(niters) ...
               ' cost = ' num2str(J) ' Jb = ' num2str(Jb) ' Je = ' num2str(Je) ' Jo = ' num2str(Jo) ...
               ' alpha = ' num2str(alpha) ' beta = ' num2str(beta) ]);

         niters = niters + 1;
    end
    [increment, control ] = Control2State_msda(control_y_all,Xp,prefix);
    [Jb, Jo, Je] = CostFunc2_msda(control.x,control.y,increment.total,innov,prefix.da.R_inv,H);

    J = Jo + Jb + Je;
    disp(['final     cost = ' num2str(J)  ...
          ' Jo = ' num2str(Jo)  ' Jb = ' num2str(Jb) ' Je = ' num2str(Je)  ' after ' int2str(niters) ' iterations' ])
    analysis = analysis + increment.total;
  end

  xb_inc = increment.static.total;
  xe_inc = increment.ensemble.total;
