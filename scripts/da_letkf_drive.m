
function ensemble = da_letkf_drive(field,obs,prefix)

 ensemble = field.ensemble;

 H = DualReso_H(prefix.model,obs,prefix.reduced_factor);
 H = H(:,prefix.model.ens.bins);

% Using medium scale localization 
 if strcmp(prefix.da.type,'sdl') || strcmp(prefix.da.type,'msda')
    L = prefix.da.L.l(prefix.model.ens.bins,prefix.model.ens.bins);
 else
    L = prefix.da.L(prefix.model.ens.bins,prefix.model.ens.bins);
 end

% This is LETKF Data Assimilation Script
 disp(['letkf starting ...'])
 wai	=zeros(prefix.ensemblesize,prefix.ensemblesize);
 xai	=zeros(prefix.model.ens.resolution,prefix.ensemblesize);
 xb_bar	=zeros(prefix.model.ens.resolution,1);
 Xb	=zeros(prefix.model.ens.resolution,prefix.ensemblesize);

% LETKF Steps 1 and 2
 xb_bar	= mean(ensemble,2);	
 xb_bar_m = repmat(xb_bar,1,prefix.ensemblesize);
 Xb = ensemble - xb_bar_m;

 yb_bar = H*xb_bar;
 Yb	=H*Xb; 

 HL = H*L;

 innov=obs.values-yb_bar;
 
 parfor i=1:prefix.model.ens.resolution
   % LETKF Step 3 : From Hunt et. al: This step selects the necessary data for a given grid point
   R_inv_loc=diag(HL(:,i))*prefix.da.R_inv ;
   
   % LETKF Step 4 : From Hunt et. al: Compute the matrix C=Yb'*R^-1
   C=Yb'*R_inv_loc;
   
   % LETKF Step 5 : From Hunt et. al: Compute the matrix. "prefix.da.rho" : multiplicative inflation
   Pa_bar=(((prefix.ensemblesize-1)*eye(prefix.ensemblesize))/prefix.da.rho+C*Yb)^-1;
   
   % LETKF Step 6
   Wa=((prefix.ensemblesize-1)*Pa_bar)^0.5;
   
   % LETKF Step 7
   wa_bar=Pa_bar*C*innov;
   wa_bar_m=repmat(wa_bar,1,prefix.ensemblesize);
   wai = Wa + wa_bar_m;

   % LETKF Step 8
   temp=Xb*wai;
   
   xai(i,:)=xb_bar_m(i,:)+temp(i,:);
 end
 
 % LETKF Step 9
 ensemble=real(xai);

 % Generate Analysis Ensmeble Mean and Pertubations
 xa_bar	= mean(ensemble,2);	
 xa_bar_m = repmat(xa_bar,1,prefix.ensemblesize);
 Xa = ensemble - xa_bar_m;

 % Relaxation-To-Prior-Spread, RTPS (Whitaker and Hamill, 2012 )
 if strcmp(prefix.da.RTPS,'true')
    XbSTD = std(Xb,0,2) ; 
    XaSTD = std(Xa,0,2) ;
    wgt = (prefix.da.RTPSalpha*((XbSTD-XaSTD)./XaSTD)+1) ;
    wgt_m = repmat(wgt,1,prefix.ensemblesize);

    Xa = Xa.*wgt_m;  
 end 

 % Relaxation-To-Prior-Perturbations, RTPP (Zhang et al. 2004)
 if strcmp(prefix.da.RTPP,'true')
    Xa = (1-prefix.da.RTPPalpha)*Xa + prefix.da.RTPPalpha*Xb ;  
 end 

 if strcmp(prefix.da.system,'3DHYB')
   % GSI analysis with ensemble resolution: Recentering
   xa_ens   = interpft(field.bckgd,prefix.model.ens.resolution);
   xa_ens_m = repmat(xa_ens,1,prefix.ensemblesize);
   ensemble = xa_ens_m + Xa;
 else
   ensemble = xa_bar_m + Xa ;
 end

 XaSpread = mean(std(Xa,0,2)) ;
 disp(['ensemble spread: ' num2str(XaSpread)])
% fprintf(prefix.fid7, '%10.6f',XaSpread );
 
 % cubic spline/fft interpolation
% for j=1:prefix.ensemblesize
   %ensemble_h(:,j)=spline(prefix.model.ens.bins,ensemble(:,j),prefix.model.main.index);
%   ensemble_h(:,j)=interpft(ensemble(:,j),prefix.model.main.resolution);
% end
 
 disp(['letkf finished ...'])
   
   
