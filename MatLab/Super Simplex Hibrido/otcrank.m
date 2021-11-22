%  The calculated rank of matrix MATRIZ.
   function [IRANK,IR,IC]=otcrank(MATRIZ)
%
%  Interface d'entree
%  -------------------
%  MATRIZ : A matrix of dimensions LINHA x COLUNA. 
%
%  Interface de sortie.
%  -------------------  
%  IRANK  : The calculated rank of matrix MATRIZ.
%  IR     : Its first IRANK elements  contain the row
%           indices of the linearly independent rows of MATRIZ.
%  IC     : Its first IRANK elements  contain the columns
%           indices of the linearly independent columns of MATRIZ.
%
%  Variable de travail.
%  -------------------
%  EPSLON : A specified tolerance such that calculated number X is 
%           considered zero if abs(X) < EPSLON. EPSLON is usually taken 1.E-8 
%           1.E-16 for single and double precision respectively.
%
% *** 
%  LINHA : An integer equal to the number of rows.
%  COLUNA: An integer equal to the number of columns.

%  ----------------------------------------------------
%  Flag define inicialmente sistema com LINHA < COLUNA.
   FLAG2 = 0;
   
%  --------------------------------------------------
%  Definição do número de linhas e colunas da matriz.
   [LINHA,COLUNA]=size(MATRIZ);
   if (LINHA > COLUNA)
    % -----------------------------------------
    % Matriz possue número de Linhas > Colunas.
      MATRIZ = MATRIZ';
      aux = LINHA;
      LINHA = COLUNA;
      COLUNA = aux;
      FLAG2 = 1;
   end

%  ----------------------
%  A specified tolerance.
   EPSLON = 1.0e-17;
%  ----------------------

%  -----------------------------
%  Início do processo iterativo.
   IRANK = LINHA;
   IC = 1:COLUNA;
   IR = 1:LINHA;   
   FLAG1 = 0;
   IOUT = 0;
   while (~FLAG1)
         IOUT = IOUT + 1;
         if IOUT > IRANK
            FLAG1 =1;
         else
            PIV = 0.0;
            for j = IOUT : COLUNA
                ICJ = IC(j);
                for i = IOUT : IRANK
                    D = MATRIZ(i,ICJ); 
                    if D < 0.0 
                       D = -D;
                    end
                    if D > PIV
                       LI = i;
                       JIN = ICJ;
                       LJ = j;
                       PIV = D;
                    end
                end
            end
             
         %  Detection of rank deficiency.
            if PIV <= EPSLON 
               IRANK = IOUT - 1;
            elseif (LI ~= IOUT)  
               G=MATRIZ(LI,1:COLUNA);
               MATRIZ(LI,1:COLUNA)= MATRIZ(IOUT,1:COLUNA);
               MATRIZ(IOUT,1:COLUNA)=G;
               K = IR(LI);
               IR(LI) = IR(IOUT);
               IR(IOUT) = K;
            end  
                     
         %  --------------------------------       
         %  A Gauss-Jordan elimination step.
            PIVOT = MATRIZ(IOUT,JIN);
            if PIVOT~=0
               MATRIZ(IOUT,1:COLUNA)=MATRIZ(IOUT,1:COLUNA)/PIVOT;
            end
            for i=1:IRANK
                if i ~= IOUT
                   D = MATRIZ(i,JIN); 
                   MATRIZ(i,1:COLUNA) = MATRIZ(i,1:COLUNA) - D*MATRIZ(IOUT,1:COLUNA);
                end 
            end      
            K = IC(LJ);
            IC(LJ)= IC(IOUT);
            IC(IOUT) = K;                         
          % -----------------
      
      % Return to another iteration.          
        end % fim if IOUT > IRANK  
   
  end % fim do while 

% -----------------------------------------------------
% In case the matrix is transposed, exchange IR and IC.
  if FLAG2  
     aux = IC;
     IC = IR;
     IR = aux; 
  end 
% ------------------------------------------------






