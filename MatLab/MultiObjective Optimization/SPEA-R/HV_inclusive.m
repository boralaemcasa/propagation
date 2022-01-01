function [prod] = HV_inclusive(p, ref)
    prod = 1;
    N = size(p,2);
    for j = 1:N
        p(1,j) = min(p(1,j), ref(j)); % min(~,2) resolve o problema de 0.5, 2.5
        prod = prod * abs(p(1,j) - ref(j));
    end
end