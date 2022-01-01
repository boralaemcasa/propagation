function [soma] = HV_referenced(p, ref)
    soma = 0;
    N = size(p,1);
    if size(p, 2) > 0
       for k = 1:N
          soma = soma + HV_exclusive(p, k, ref);
       end
    end
end