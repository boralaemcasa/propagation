function [x,A] = pivotear(V, b, z)
  flagIgual = (size(b,1) == size(V,1));
  if flagIgual
      A = [V b];
  else
      A = V;
  end
  if size(z,2) > 0
	  inicio = size(A,1) + 1;
      A = [A; z'];
  else
      inicio = 1;
  end
  [n, cols] = size(A);
  m = min(n,cols);
  for pivoti = inicio:m
     pivotj = pivoti;
     while abs(A(pivoti, pivotj)) < 1e-9 & pivoti < m
        pivoti = pivoti + 1;
     end

     %if (pivoti >= n) throw new Exception("Singular matrix.")

     for i = inicio:n
       if abs(A(i, pivotj)) > 1e-9
          for j = 1:cols
            if j ~= pivotj
               A(i, j) = A(i, j) / A(i, pivotj); % column pivotj = 1
            end
          end               
          A(i, pivotj) = 1;
       end
     end

     for i = pivoti + 1: n
        if i ~= pivoti & abs(A(i, pivotj)) > 1e-9
           for j = 1:cols
              % line i -= line pivoti. column pivotj become full of zeroes
              A(i, j) = A(i, j) - A(pivoti, j);
           end
        end
     end
  end
  
  lines = [];
  if flagIgual
      r = [];
      for i = 1:n
          if norm(A(i,:)) ~= 0
              r = [r norm(A(i,:))]; 
              lines = [lines i];
          end
      end
      if size(lines,2) == 0
          lines = 1;
      end
      A = V(lines,:);
      b = b(lines);

      while true
        x = pinv(A) * b;
        if sum(isnan(x)) == 0
            break;
        end
        [p,q] = min(r);
        A(q,:) = [];
        b(q) = [];
      end
  else
      for i = 1:n
          if norm(A(i,:)) == 0
              lines = [lines i];
          end
      end
      x = lines;
      A(x,:) = [];
  end
end