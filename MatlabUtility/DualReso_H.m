
function H_ens = DualReso_H(prefix,obs,reduced_factor) 
 H_ens =  zeros(obs.numbers,prefix.main.resolution);

% factors
 x1 = fix((fix(obs.positions)-1)/reduced_factor);
 x1 = x1 * reduced_factor + 1;

 x2 = x1 + reduced_factor;
 x2 = mod(x2,prefix.main.resolution) ; 
 x2(x2==0)=prefix.main.resolution ; 

 f2 = (obs.positions - x1)/reduced_factor;
 f1 =  1 - f2;

% observation opperator
 for i = 1 : obs.numbers 
  H_ens(i,x1(i))=f1(i);
  H_ens(i,x2(i))=f2(i);
 end

