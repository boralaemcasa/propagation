%  ---------------------------------------------------
%  Algoritmos de PONTOS INTERIORES
%  Vannelli.(1993). "Teaching Large-Scale Optimization
%  by an Interior Point Approach"; IEEE Trans. on Education. (36)1:204-209
%  Solve the linear programming problem
%  min  c'x
%  s.t. Ax < b
%  and returns the path x to the solution with respective
%  objective function values fx.
%  ---------------------------------------------------
% Algoritmo de pontos interiores.
  function [ITER,EVOLX,EVOLFOBJ,X,FOBJ,yk, gap_final] = algpint_01(A,B,C,REL,X0,XMIN,XMAX,epslon, KALPHA,MAXITER)

% ------------------------------------------------------------
% Specified tolerance such that a calculated DELTAX = X - XOLD
% is considered zero if abs(max(DELTAX)) < epslon .
  if isempty(epslon)
     epslon = 1.0e-08;
  end
% -------------------------------------------
% Specified value considered zero = epslon^2;
  valzero= epslon^3;

% ------------------------------------
% Specified value considered infinite (eps = 2.2204e-016).
  INFMAX = 1/(eps^4);

% ----------------------------------------------------
% KALPHA = input('fator KALPHA :  0 < KALPHA < 1 = ');
  if isempty(KALPHA)
     KALPHA = 0.9;
  end

% ------------------------------------------------
% Verifica se ponto X0 é um ponto interior ou nï¿½o.
  if (sign(A*X0 - B) ~= REL)
     disp('   ----------------------------------'); 
     disp('       X0 não é um ponto interior! ');
     disp('                ' );
     return
  end
  
% Define os valores de N e M.
  [M,N] = size(A);

% ------------------------------------
% Stockage the initial trial solution.
  X = X0;
  EVOLX = X0;
  
% ---------------------------
% Evaluate objectif function.
  FOBJ = C'*X0;
  EVOLFOBJ = FOBJ;

% -------------------------------------------------------
% Loop do arquivo de Demonstração do método de Pontos Interiores.
  ITER =1;
  FLAG1=0;
  Dk = sparse(M,M);
  while ITER <= MAXITER && FLAG1 == 0  
      % Step I.
           % Calculate the slack (how far point is from each constraint).
	         Vk = B - A*X;
	         Vk = max(Vk,eps^4);
	
	       % Calculate the diagonal matrix.
	         Dk = diag(1./Vk);

      % Step II.
           % Calculate the projection of the current guess onto the boundary of the
	       % sphere. Solve the system of equations for dk. Gaussian elimination.
           % dk = (A'*Dk*Dk*A)\C;
             
           % linsolve - Solves the linear system A*X=B using LU factorization
           % with partial pivoting when A is square, and QR factorization with
           % column pivoting otherwise. Warning is given if A is ill conditioned
           % for square matrices and rank deficient for rectangular matrices.
             opts.POSDEF = false;
             dk  = linsolve(A'*Dk*Dk*A,C,opts);
                
           % Pseudoinverse. pinv Produces a matrix X of the same dimensions as A' so that
           % A*X*A = A, X*A*X = X and A*X and X*A are Hermitian. The computation is based
           % on SVD(A) and any singular values less than a tolerance are treated as zero.
           % dk = pinv(A'*Dk*Dk*A)*C;
            
           % Tikhonov regularization.
           % dk = reg_tikhonov((A'*Dk*Dk*A),C);
             
	       % Scale the projected direction.
  	         dv = -A*dk;

      % Step III.
           % Identify the negative component.
             for I1=1:M
                 if dv(I1,1) > - valzero
                    Vaux(I1,1)=-INFMAX;
		         else
                    Vaux(I1,1)= Vk(I1,1)/dv(I1,1);
		         end
             end
 	         Valpha = max(Vaux);

	       % ----------------------------------------------------
	       % The current coordenates move from the current trial
	       % solution X to the next solution. The value of ALPHA
 	       % is defined :  0 < ALPHA < 1).
	         ALPHA(ITER) = KALPHA;
  	         X = X - ALPHA(ITER)*Valpha*dk;

      % Step IV.
     	   % Calculate X = D*XR as the trial solution for the next
	       % iteration (STEP I). IF this solution is virtually
	       % unchanged from the preceding one, then the algorithm
	       % has virtually converged to an optimal solution, so STOP.
           % Limits to X verified.
             for J1 = 1 : N
                 if X(J1,1) < XMIN(J1,1)
		            X(J1,1) = XMIN(J1,1);
		         end
                 if X(J1,1) > XMAX(J1,1)
		            X(J1,1) = XMAX(J1,1);
		         end
		     end

	       % Calculate DELTAX.
             if ITER ~= 1
                DELTAX = X  - XOLD;
	          % If the solution X is EPSLON unchanged from the the
		      % preceding one, then the algorithm has an optimal solution.
	            if max(abs(DELTAX)) < epslon
                   XOLD = X;
                   FLAG1 = 1;
		        end

	          % Evaluate objectif function.
                FOBJ = C'*X; 
                EVOLFOBJ = [EVOLFOBJ FOBJ];

	          % Calculate the candidate primal solution.
		        yk = -Dk*Dk*dv;
                
                gap_final = abs((B'*yk - FOBJ)/max([1,abs(FOBJ)]));
              % The algorithm has an optimal solution X.
                if abs((B'*yk - FOBJ)/max([1,abs(FOBJ)])) < epslon
		           FLAG1 = 1;                
                 % disp('  ------------------------------------------------------'); 
                 % disp('      Calculate   the   candidate   primal   solution.           ')
                 % disp(['           Bt*yk-Ct*X               = ', num2str(B'*yk - FOBJ)]),
                 % disp('  ------------------------------------------------------'); 
                end
            end            
         
          % ------------------           
	      % Storage EVOLX.
		    EVOLX = [EVOLX X];
           
	      % Storage XOLD as X.
            XOLD = X;

	      % Evaluate the number of iterations.
	        if ITER >= MAXITER
		       FLAG1 = 1;
            else
               if FLAG1 == 0
                  ITER = ITER + 1;
               end
            end
   end