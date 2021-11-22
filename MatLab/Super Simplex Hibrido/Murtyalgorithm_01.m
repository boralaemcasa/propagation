  function [x, B] = Murtyalgorithm_01(A,c,x)
% MURTYALGORITHM Projection of interior point onto vertex.
%
%   Prototypes:
%      [x,B] = Murtyalgorithm(A,c,x)
%
%   Input arguments:
%      A: linear equality constraint matrix
%      c: linear objective function coefficients
%      x: a starting feasible point
%
%   Output arguments:
%      x: a vertex of {z | A*z = b, z >= 0}
%      B: set of basic variables
%
%   Example 1:  book's example
%      A = [1 0 0 1 0 1 -1; 0 1 0 0 -1 2 -1; 0 0 1 -1 1 1 -2];
%      c = [-10 4 6 2 4 8 10];
%      x = [5/2; 6; 13/2; 1/2; 1; 0; 0];
%      [xopt, B] = Murtyalgorithm(A,c,x);
%
%   Example 2:  
%      n = 2; % number of variables
%      op = oplpball(n,10,1);
%      A = [op.A; eye(op.inputdimension); -eye(op.inputdimension)];
%      b = [op.b; op.xmax; -op.xmin];
%      Aeq = op.Aeq;
%      c = op.C;
%      op.startingpoint = .75*rand(n,1);
%      x = op.startingpoint;
%      [mo,no] = size(A);
% 
%      % free variables to positive variables
%      A = [A -A];
%      Aeq = [Aeq -Aeq];
%      c = [c -c];
%      x = [max(0,x); min(0,x)];
% 
%      % slack variables
%      x = [x; b-A*x];
%      A = [A eye(size(A,1))];
%      Aeq = [Aeq zeros(size(Aeq,1),size(A,1))];
%      c = [c zeros(1,size(A,1))];
% 
%      % equality constraints
%      A = [A; Aeq];
% 
%      xopt = Murtyalgorithm(A,c,x);
% 
%      % map to original variables
%      M = [eye(no) -eye(no) zeros(no,mo)];
%      xopt = M*xopt
%      xopt2 = M*xopt2

% Updates:
%    2015/07/30 Amanda Dusse: initial version
%    2016/09/24 Igor Baratta:  Alteração das condições de entrada no while,
%    e operação dos pivots

% References:
% [1] Katta G. Murty. "Linear complementarity, linear and non linear 
%    programming", pag 474-477, 1997.



% cardinalities
  [m,n] = size(A); % number of inequality constraints of variables
% starting tableau
  B = find(x>0);  % index set of basic variables
  [R,jb] = rref(A(:,B));  % reduced row echelon form

  while length(B) > rank(A(:,B))
   % calculate search direction
   d = zeros(n,1);
   a = 1:size(R,2);  
   a(jb) = [];  % columns that are not part of eye matrix
   teste = B(jb);
   for ii = 1:size(teste)
     d(teste(ii)) = - R(ii, a(1));
   end
   % d(B(jb)) = -R(:,a(1));
   d(B(a(1))) = 1;

   % calculate step
   z = sum(c.*d');
   rate = x(B)./d(B);
   if z <= 0
      f = find(d(B) < 0 & rate <= 0);
      [lambda,i] = min(-rate(f));
   else
      f = find(d(B) > 0 & rate >= 0);
      [lambda,i] = max(-rate(f));
   end
   i = f(i);
   
   % stop criterion: unbounded optimal solution
   if isempty(i)
      break % optimal solution
   end
   
   % step towards search direction (d = tetha)
   x = x + lambda*d;

   %update basis
   B(i) = [];

   %update 
   if all(jb ~= i)
      R(:,i) = []; 
   else
      % pivotal operation
      ib = find(R(:,i));
      [~,in] = max(abs(R(ib,a)));  %column index
      in = a(in);
      R(ib,:) = R(ib,:)/R(ib,in);
      inp = find((1:m) ~= ib);
      R(inp,:) = R(inp,:) - R(inp,in)*R(ib,:);
      R(:,i) = []; %remove column
      jb(jb == i) = in; %update index of eye matrix
   end
   jb(jb>i) = jb(jb>i)-1;  
end