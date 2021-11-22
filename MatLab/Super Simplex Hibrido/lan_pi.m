% =============================================================
% =============================================================
% Lan�ador para o Algoritmo Pontos Interiores-Simplex
% Disciplina Otimiza��o em Engenharia
% Prof. Rodney Rezende Saldanha
% 15/04/207
% ==========================
% Deleta todas as vari�veis.
  clear;
  close all;
  format long;
  
% -------------------------------------------
% Turn off warning : 'Matrix is close to singular or badly scaled.
% Results may be inaccurate.'
  warning('off','all') 
% -------------------------------------------

% -------------------------------------------
% First call to the problem.
% Klee-Minty Problem (1972)
% Construction of the optimization problem.
% ------------------------------------------
  disp('  ------------------------------------------------------') 
  ndim = input('             Dimens�o  do  espa�o          =  ');
  disp('  ------------------------------------------------------')
 
% --------------------------------------------------
% Constru��o problema Pontos Interiores : ncode == 1
% Constru��o problema Simplex           : ncode == 2 
% Constru��o do problema com as vari�veis slacks (simplex).
  ncode = 1;
% --------------------------------------------------

  disp('  ------------------------------------------------------') 
  valb = input('      Define o vetor b (10 < valb < 100)   =  ');
  disp('  ------------------------------------------------------')
  tic
  [A,B,C,REL,XMIN,XMAX] = fklemint_pi_splx(ndim,ncode,valb);
       
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
    disp('  ------------------------------------------------------------'); 
    disp('     Rank (A) < dim. vet X . The problem is not consistent.   '),
    disp('  ------------------------------------------------------------');
    return;
  end
  
% ----------------------------------------------------
% Define o primeiro ponto interior pr�ximo da origem;
  Xini = (1.0e-11 + 1.0e-08*rand(1))*(XMAX./norm(XMAX)) 
% [Xini,A1,b1,g] = findintp(A,B,REL);   
% ----------------------------------------------------

% ----------------------------------------------------
% Algoritmo de pontos interiores.
% Definicao dos parametros PI
% gap = 1e-1;                           % Gap de Dualidade
  gap = 1.0e-02;                        % Gap de Dualidade
% ----------------------------------------------------

% ---------------------------------  
% Algoritmo de pontos interiores.
% Numero maximo de iteracoes do PI - Se o numero for muito alto o
% algoritmo se aproxima muito do ponto ótimo
% Maxiter = input('  Numero Maximo de Iteracoes Pontos Interiores  = ');                                 
% KALPHA  = input('  Fator KALPHA :    0 < KALPHA < 1              = ');
  Maxiter = 20*ndim;
  KALPHA  = 0.5; % passo
  [iter,EVOLX,EVOLFOBJ,Xsol_pi,FOBJ,yk,gap_final] = algpint_01(A,B,C,REL,...
                                     Xini,XMIN,XMAX,gap, KALPHA, Maxiter);
% -------------------------------------------------------------------------
  Xsol_pi
  Xsol = [zeros(ndim-1,1);valb^(ndim-1)];
  erro_xpi = 100*norm(Xsol_pi - Xsol)/valb^(ndim-1);
  erro_fobjpi = 100*abs(FOBJ/(valb^(ndim-1)) - 1);
  disp('  ----------------------------------------------------------------  ');
  fprintf('  Theoretical number of iterations for the simplex is = %d\n',2^ndim);
  fprintf('  PI number of iterations is                          = %d\n',iter);
  fprintf('  PI erro porcentual optimal objective value is       = %f\n',erro_fobjpi);
  fprintf('  PI erro porcentual vetor x solu�ao                  = %f\n',erro_xpi);
  disp('  -----------------------------------------------------------------  '); 
  toc
% -------------------------------------------------------------------------
% =============================================================
% =============================================================
