function [soma] = HV_referenced(p)
    soma = 0;
    N = size(p,1);
    if size(p, 2) > 0
       for k = 1:N
          soma = soma + HV_exclusive(p, k);
       end
    end
end