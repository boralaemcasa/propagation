% =============================================================
  function [a,b,c,rel,xmin,xmax] = fklemint_pi_splx(n,ncode,valb)
% Klee-Minty Problem (1972)
% *************
% The problem
% maximizar  f(x) = C'*x
% subject to
%            A*x <= B
%            Xmin < X < Xmax.
% A   -> Matriz de restricoes.
% B   -> Vetor do sistema.
% *************
% Example para dimens�o n = 3:
% maximize 4x1 + 2x2 + x3
% subj. to
%          x1             <= 1
%         4x1 +  x2       <= 100
%         8x1 + 4x2 + x3  <= 10000
%              x1, x2, x3 >= 0
% *************
% valb : define o valor do vetor b
  for i1 = 1:n
    % Determina��o de C
      c(i1,1) = 2^(n-i1);

    % Determina��o de A
      a(i1,i1) = 1.0;
      for j1 = 1:n
          if j1 < i1
             a(i1,j1) = 2^(i1+1-j1);
          end
      end
      
    % Determina��o de b
      b(i1,1) = valb^(i1-1);
  
    % REL -> Relacoes de desigualdade: -1 = "Ax <= B".
      rel(i1,1) = -1;
      
    % Limits of X. Xmax and Xmin.
      xmin(i1,1) = 0.0;
      xmax(i1,1) = b(i1,1);
  end
% --------------------------- 
% Constru��o problema Pontos Interiores
  if ncode == 1
   % Determina��o de A
     for i1 =1:n
         a(n+i1,i1) = -1;
         b(n+i1,1)  =  0;
         rel(n+i1,1)= -1;
     end
  end
% --------------------------- 
% Constru��o problema Simplex
  if ncode == 2 
   % Determina��o de C
     c = [c; zeros(n,1)];
  
   % Determina��o de A com o acr�scimo das vari�veis slacks
     for i =1:n
         a(i,n+i) = 1;
     end
  end
% =============================================================