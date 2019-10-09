clear all;

set_expname

%name.data5='letkf';
Labels = struct2cell(name);
% Labels = { '3DENV' '3MSDA'}

modelresolution=960;
reduced_factor=1;
modelresolution_ens=modelresolution/reduced_factor;

forcing=15;
zero=zeros(modelresolution/2);
nfram = 4 ;

final_end = 0;   % initialized

path.data1='./' ;
path.data2='./' ;
path.data3='./' ;
path.data4='./' ;
path.data5='./' ;

ensemblesize.data1=20;
ensemblesize.data2=20;
ensemblesize.data3=20;
ensemblesize.data4=20;
ensemblesize.data5=10;

color.data1=[0.0 ,0.0 ,0.0 ];
color.data2=[0.0 ,0.0 ,1.0 ];
color.data3=[1.0 ,0.0 ,0.0 ];
color.data4=[0.0 ,0.8 ,0.0 ];
color.data5=[1.0 ,0.75,0.75];
color.data6=[1.0 ,0.0 ,1.0 ];
color.data7=[0.5 ,0.5 ,0.0 ];
color.data8=[0.0 ,0.5 ,0.5 ];

LineStyle.fram1='-';
LineStyle.fram2='--';

fname = fields(name);
nexps = length(fname) ; 

t_ini=500
t_bin=20
%======================== Read data ===================
for exps=1:length(fname)
  % Define file name
  %file_truth    =[ name.(fname{exps}) '/output_truth.txt']
  file_truth    =[ './output_truth.txt']
  file_analy    =[ name.(fname{exps}) '/output_analy.txt']
  file_analy_ens=[ name.(fname{exps}) '/output_analy_ens.txt']
  file_bckgd    =[ name.(fname{exps}) '/output_bckgd.txt']
  file_bckgd_ens=[ name.(fname{exps}) '/output_bckgd_ens.txt']

  % Get Truth
  fid=fopen(file_truth,'r'); Truth=fscanf(fid,'%f',[modelresolution Inf]); fclose(fid);
  t_end=size(Truth,2); 
  if t_end ~= 5000 && t_end ~= 8000; t_end=t_end-1 ; end
  if strcmp(name.(fname{exps}),'h3dfull'); t_end=5000 ; end

  time.(fname{exps})=t_end

  % Get Analysis
  if  strcmp(name.(fname{exps})(1:5),'letkf') || strcmp(name.(fname{exps})(1:4),'LETK') || strcmp(name.(fname{exps})(1:2),'KF')
    fid=fopen(file_bckgd_ens,'r');
    Bckgrd_ens=fscanf(fid,'%f',[modelresolution_ens Inf]);
    Bckgrd_ens=reshape(Bckgrd_ens,modelresolution_ens,ensemblesize.(fname{exps}),[]);
    fclose(fid);
   
    Bckgrd=mean(Bckgrd_ens,2);
    Bckgrd=reshape(Bckgrd,modelresolution_ens,[]);
    if reduced_factor ~= 1 
      Bckgrd=interpft(Bckgrd,modelresolution);
    end 

    fid=fopen(file_analy_ens,'r');
    Analysis_ens=fscanf(fid,'%f',[modelresolution_ens Inf]);
    Analysis_ens=reshape(Analysis_ens,modelresolution_ens,ensemblesize.(fname{exps}),[]);
    fclose(fid);

    Analysis=mean(Analysis_ens,2);
    Analysis=reshape(Analysis,modelresolution_ens,[]);
    if reduced_factor ~= 1
      Analysis=interpft(Analysis,modelresolution);
    end
  else
    fid=fopen(file_bckgd,'r');
    Bckgrd=fscanf(fid,'%f',[modelresolution Inf]);
    fclose(fid);

    fid=fopen(file_analy,'r');
    Analysis=fscanf(fid,'%f',[modelresolution Inf]);
    fclose(fid);
  end

  % error 
  xa_err.(fname{exps}) =    Truth(1:modelresolution,t_ini:t_bin:time.(fname{exps})) - Analysis(1:modelresolution,t_ini:t_bin:time.(fname{exps}));
  xb_err.(fname{exps}) =    Truth(1:modelresolution,t_ini:t_bin:time.(fname{exps})) -   Bckgrd(1:modelresolution,t_ini:t_bin:time.(fname{exps}));
  xa_inc.(fname{exps}) = Analysis(1:modelresolution,t_ini:t_bin:time.(fname{exps})) -   Bckgrd(1:modelresolution,t_ini:t_bin:time.(fname{exps}));

  if final_end<t_end
    final_end=t_end;
  end
end

% Convert to power spectrum 
for exps=1:length(fname)
  %------------------------------------------------
  field_fft = fft(xa_inc.(fname{exps}));

  field_fft = field_fft(1:modelresolution/2+1,:);
  ps_field_fft = abs(field_fft).^2.;
  ps_field_fft(2:end-1,:) = 2*ps_field_fft(2:end-1,:); 

  ps_xa_inc.(fname{exps}) = mean(ps_field_fft,2); 

  %------------------------------------------------
  field_fft = fft(xb_err.(fname{exps}));

  field_fft = field_fft(1:modelresolution/2+1,:);
  ps_field_fft = abs(field_fft).^2.;
  ps_field_fft(2:end-1,:) = 2*ps_field_fft(2:end-1,:); 

  ps_xb_err.(fname{exps}) = mean(ps_field_fft,2); 

  %------------------------------------------------
  field_fft = fft(xa_err.(fname{exps}));

  field_fft = field_fft(1:modelresolution/2+1,:);
  ps_field_fft = abs(field_fft).^2.;
  ps_field_fft(2:end-1,:) = 2*ps_field_fft(2:end-1,:); 

  ps_xa_err.(fname{exps}) = mean(ps_field_fft,2); 
end

%------------------------------------------------
figure

for exps=1:length(fname)
  for fram=1:nfram 
    subplot(2,2,fram)
    if fram==1
      loglog(ps_xa_inc.(fname{exps}),'Color',color.(fname{exps}),'LineStyle',LineStyle.fram1,'LineWidth',1.5)
      hold on
    elseif fram==2
      loglog(ps_xb_err.(fname{exps}),'Color',color.(fname{exps}),'LineStyle',LineStyle.fram1,'LineWidth',1.5)
      hold on
    elseif fram==3
      loglog(ps_xa_err.(fname{exps}),'Color',color.(fname{exps}),'LineStyle',LineStyle.fram1,'LineWidth',1.5)
      hold on
    elseif fram==4
        %loading settings
        home = cd(sdb_dir)
        L05_namelist
        cd (home)

        semilogx(prefix.da.sd_beta1_inv,'b-o');
        hold on
        semilogx(prefix.da.sd_beta2_inv,'r-o')

        xlabel('Total Wavenumber')
        ylabel('Weights')
        title([ 'Scale-dependent Weighting - ' prefix.expname ])
        legend('Static','Ensemble','Location','best')
        axis([1 481 -0.2 1.2])
        hold off
    end
  end  % FRAMS LOOP
end  % CASES LOOP

% draw legend 
subplot(2,2,1)
legend(upper(Labels),'Location','best','Orientation','vertical')


% draw labels 
for fram=1:nfram
 subplot(2,2,fram)
 
  xlabel('Total Wavenumber')
 if fram==1
  axis([1 481 10^0 10^5 ])
  title('Power Spectral Density of Ana. Inc.')
 elseif fram==2
  axis([1 481 10^1.8 10^4.5 ])
  title('Power Spectral Density of BG Error')
 elseif fram==3
  axis([1 481 10^1.8 10^4.5 ])
  title('Power Spectral Density of Ana. Error')
 elseif fram==4
%  title('Power Spectral Density of Background Error - Analysis Increment')
 end

 hold off
end 

% hardcopy   
print(['PWS_' upper(expname) ] ,'-dpng')
print(['PWS_' upper(expname) ] ,'-dpdf')

