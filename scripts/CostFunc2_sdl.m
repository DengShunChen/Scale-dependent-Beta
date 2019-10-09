function [Jb, Jo, Je] = CostFunc2_sdl(x,y,xt_inc,innov,R_inv,H)

  % Coset function 
  Jb_l = 0.5*x.static.l'*y.static.l;
  Jb_s = 0.5*x.static.s'*y.static.s;
  Jb = Jb_l + Jb_s ;

  Je_l = 0.5*x.ensemble.l'*y.ensemble.l;
  Je_s = 0.5*x.ensemble.s'*y.ensemble.s;
  Je = Je_l + Je_s ;

  Jo   = 0.5*(H*xt_inc-innov)'*R_inv*(H*xt_inc-innov);

