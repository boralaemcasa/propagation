function [soma] = hypervolume(p)
    soma = 0;
    N = size(p,1);
    if size(p, 2) > 0
       for k = 1:N
          soma = soma + exclusiveHV(p, k);
       end
    end
end