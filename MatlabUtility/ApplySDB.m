function [ x ] = ApplySDB(y,prefix)
	
 % convert from physical to spectra
  x_static_fft	 = fft(y.static);
  x_ensemble_fft = fft(y.ensemble);
  
 % apply scal-dependent weighting
  x_static_fft	 = diag(prefix.da.sd_beta1_inv)*x_static_fft;
  x_ensemble_fft = diag(prefix.da.sd_beta2_inv)*x_ensemble_fft;

 % convert back from spectra to physical
  x.static	= ifft(x_static_fft);
  x.ensemble	= ifft(x_ensemble_fft);

