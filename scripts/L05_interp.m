
function  y.val = L05_interp(modelreso_lo,x.val,modelreso_hi)
%	spectra interpolation 

	% convert to spectra
	x.fft = fft(x.val(1:modelreso_lo));

	% initial y
    y.val = zeros(modelreso_hi,1);
    y.fft = fft(y.val);

    y.tmp(1:modelreso_hi/2+1) = 0.
    y.tmp(1:modelreso_lo/2+1) = x.fft(1:modelreso_lo/2+1);  

    y.tmpflip = fliplr(y.tmp);

    y.fft = [ y.tmp y.tmpflip(2:end-1) ]';
    y.val = ifft(y.fft);

