  function [fobj,dfobj]=fex1(x, a)
  % Fun��o objetivo.
dim = length(x);
A1 = diag(1:dim);

 c1 = ones(dim,1);

% c1 = zeros(dim,1);

fobj = 0.5*(x - c1)'*A1*(x - c1);

% Gradiente da fun��o objetivo.
dfobj = A1*(x - c1); 

% Corrige termos n�o quadr�ticos
if a~=0
   for i=1:dim   
       fobj = fobj + a*((x(i,1)-1)^3);  
       dfobj(i,1) = dfobj(i,1) + 3*a*(x(i,1)-1)^2;      
   end    
end
