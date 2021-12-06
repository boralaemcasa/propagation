function [RETORNO] = RUNHIBRID2(ndim, gap, KALPHA, separar)
  ncode = 1;
  valb = 10;
  tic
% Pontos Interiores
  [A,B,C,REL,XMIN,XMAX] = fklemint_pi_splx(ndim,ncode,valb);
% ------------------------------------------------------------
  
% ------------------------------------------------------------
% The calculated rank of matrix A.
% A      : A matrix of dimensions LINHA x COLUNA.  
% IRANK  : The calculated rank of matrix A.
% IR     : Its first IRANK elements  contain the row
%           indices of the linearly independent rows of A.
% IC     : Its first IRANK elements  contain the columns
%           indices of the linearly independent columns of A.
  [IRANK,IR,IC] = otcrank(A);
% ----------------------------------------------------------
% Number of linearly independent rows. 
% Verify the rank(A) = N or not. 
  if IRANK < length(XMIN)
     disp('  ---------------------------------------------------------'); 
     disp('    Rank (A) < dim. vet X. The problem is not consistent. '),
     disp('  ---------------------------------------------------------');
     return
  end
  
% --------------------------
% Specified value considered
  valzero = sqrt(eps)^3;
  
% ----------------------------------------------------
% Define o primeiro ponto interior próximo da origem;
% Xini = (1.0e-07 + 1.0e-06*rand(1))*(XMAX./norm(XMAX));
  Xini = (1.0e-11 + 1.0e-08*rand(1))*(XMAX./norm(XMAX));
% ----------------------------------------------------

% ---------------------------------  
% Algoritmo de pontos interiores.
% Definicao dos parametros PI
% gap = 1e-1;                           % Gap de Dualidade

% Numero maximo de iteracoes do PI - Se o numero for muito alto o
% algoritmo se aproxima muito do ponto Ã³timo
% Maxiter = input('  Numero Maximo de Iteracoes Pontos Interiores  = ');                                 
% KALPHA  = input('  Fator KALPHA :    0 < KALPHA < 1              = ');
  Maxiter = 20*ndim;
  %KALPHA  = 0.5; % passo
  [ITER,EVOLX,EVOLFOBJ,Xsol_pi,FOBJ,yk,gap_final] = algpint_01(A,B,C,REL,...
                                     Xini,XMIN,XMAX,gap, KALPHA, Maxiter);
% [ITER,EVOLX,EVOLFOBJ,Xsol_pi,FOBJ] = algpint(A,B,C,REL,Xini,XMIN,XMAX,[]);
  Xsol_pi(ndim)= Xsol_pi(ndim) - valb^(ndim-1);
  erro_xpi = 100*norm(Xsol_pi)/valb^(ndim-1);
  Xsol_pi(ndim)= Xsol_pi(ndim) + valb^(ndim-1);
  erro_fobjpi = 100*abs(FOBJ - valb^(ndim-1))/valb^(ndim-1);
  %disp('  ---------------------------------------------------------  ');
  %fprintf('    Pi number of iterations is                      = %d\n',ITER);
  if separar
      disp('  -------------------------------------------------------------------  ');
      fprintf('    Dim                                                  = %d\n',ndim);
      fprintf('    Gap                                                  = %d\n',gap);
      fprintf('    Alpha                                                = %f\n',KALPHA);
      fprintf('    Pi erro porcentual  optimal objective value is       = %f\n',erro_fobjpi);
      fprintf('    Pi erro porcentual vetor x solucao                   = %f\n    ',erro_xpi);
      toc
      tic
  end
  %disp('  ---------------------------------------------------------  ');
  %disp('  ---------------------------------------------------------  ');
  %pause(1);
% ==========================================================================
% ==========================================================================  
  %disp('  ');
  %disp('  -------------------------------------------------  ');
  %disp('     Utilizando o metodo de Murty : Amanda & Igor     ');
  %disp('  -------------------------------------------------  ');
  %disp('  ');
% [1] Katta G. Murty. "Linear complementarity, linear and non linear 
% programming", pag 474-477, 1997.
% -------------------------------------------
% Construção problema Pontos Interiores : ncode == 1
% Construção problema Simplex           : ncode == 2 
% Construção do problema com as variáveis slacks (simplex).
  ncode = 2;

% Construcaoo do problema ja com as variaveis slacks.
  [As,bs,cs,REL,XMIN,XMAX] = fklemint_pi_splx(ndim,ncode,valb);
% ------------------------------------------------------------
  [~, FBS] = Murtyalgorithm_01(As,-cs',yk);
 
% --------------------------------------------------------------------------
% Klee-Minty problem shows that: Largest-coefficient rule can take 2^n - 1 
% pivots to solve a problem in n variables and constraints.
% --------------------------------------------------------------------------
% Revised Simplex Method : Solves: Maximize cs^Tx subject to As.x = b, x >= 0
% We will assume that the LP is nondegenerate. We are given an initial feasible
% basis FBS utilizando o metodo de K G Murty.
% eps11 = 1e-3;
  eps11 = 1e-6;
  
% Y eh a variavel Primal -  X eh a variavel DUAL (Em conformidade com
% lançamento do Pontos Interiores)
  [obj,x,y,iter_spx,evolx,xb1,B] = revised_simplex_01(cs,As,bs,eps11,FBS);

  Xsol_splx = x(1:ndim);
  Xsol_splx(ndim) = Xsol_splx(ndim) - valb^(ndim-1);
  erro_xsplx = 100*norm(Xsol_splx)/valb^(ndim-1);
  erro_fobjsplx = 100*abs(obj - valb^(ndim-1))/valb^(ndim-1);
  if ~ separar
     disp('  -------------------------------------------------------------------  ');
     fprintf('    Dim                                                  = %d\n',ndim);
     fprintf('    Gap                                                  = %d\n',gap);
     fprintf('    Alpha                                                = %f\n',KALPHA);
  end
  fprintf('    Theoretical number of iterations for the simplex is  = %d\n',2^ndim);
  fprintf('    Pi number of iterations is                           = %d\n',ITER);
  fprintf('    Simplex number of iterations is                      = %d\n',iter_spx);
  fprintf('    Simplex erro porcentual optimal objective value is   = %f\n',erro_fobjsplx);
  fprintf('    Simplex erro porcentual vetor x solucao              = %f\n    ',erro_xsplx);
  toc
  disp('  -------------------------------------------------------------------  '); 
end