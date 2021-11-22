function [RETORNO] = RUNSIMPLEX(ndim)
  ncode = 2;
  valb = 10;
  tic
  [AS,b,CS,REL,XMIN,XMAX] = fklemint_pi_splx(ndim,ncode,valb);
  
% ------------------------------------------------------------
% The calculated rank of matrix A.
% A      : A matrix of dimensions LINHA x COLUNA.  
% IRANK  : The calculated rank of matrix A.
% IR     : Its first IRANK elements  contain the row
%           indices of the linearly independent rows of A.
% IC     : Its first IRANK elements  contain the columns
%           indices of the linearly independent columns of A.
  [IRANK,IR,IC] = otcrank(AS);
% ----------------------------------------------------------
% Number of linearly independent rows. 
% Verify the rank(A) = N or not. 
  if IRANK < length(XMIN)
    disp('  -----------------------------------------------------------'); 
    disp('     Rank (A) < dim. vet X . The problem is not consistent. '),
    disp('  -----------------------------------------------------------');
  end
% --------------------------------------------------------------------------
% Revised Simplex Method : Solves: Maximize cs^Tx subject to As.x = b,
% x >= 0. We will assume that the LP is nondegenerate. We are given an 
% initial feasible basis FBS
% eps_x = 1e-6;
  eps_x = eps;
  
% ---------------------------------
% Define o primeiro ponto;
  Xini = 0.00*XMAX;
% -------------------------------------------------------------------
% Simplex parte do vértice xini = origem.
  FBS = [find(Xini ~= 0)];
  aux = find(Xini == 0) + length(b);
  FBS = [FBS; aux];
  
% -------------------------------------------------------------------
% method simplex.
% Y eh a variavel Primal -  X eh a variavel DUAL (Em conformidade com
% lançamento do Pontos Interiores)
  [obj,x,y,iter,~,~,~] = revised_simplex_01(CS,AS,b,eps_x,FBS);
% -------------------------------------------------------------------
  x = x(1:ndim);
  Xsol = [zeros(ndim-1,1);valb^(ndim-1)];
  erro_xsplx    = 100*norm(x - Xsol)/valb^(ndim-1);
  erro_fobjsplx = 100*abs(obj/(valb^(ndim-1)) - 1);
  disp('  ---------------------------------------------------------------  ');
  fprintf('    Dim                                                  = %d\n',ndim);
  fprintf('    Theoretical number of iterations for the simplex is  = %d\n',2^ndim);
  fprintf('    Theoretical number of iterations for the simplex is  = %d\n',2^ndim);
  fprintf('    Simplex number of iterations is                      = %d\n',iter-1);
  fprintf('    Simplex erro porcentual optimal objective value is   = %f\n',erro_fobjsplx);
  fprintf('    Simplex erro porcentual vetor x soluçao              = %f\n',erro_xsplx);
  toc
  disp('  ---------------------------------------------------------------  '); 
%==========================================================================
  end