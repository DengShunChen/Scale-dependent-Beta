function [Jb, Jo, Je] = CostFunc2(x,y,xt_inc,innov,R_inv,H)

  % Coset function 
  Jb = 0.5*x.static'*y.static;
  Je = 0.5*x.ensemble'*y.ensemble;
  Jo = 0.5*(H*xt_inc-innov)'*R_inv*(H*xt_inc-innov);

