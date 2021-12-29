function [prod] = inclusiveHV(p)
    prod = 1;
    N = size(p,2);
    for j = 1:N
        p(1,j) = min(p(1,j), 2);       % resolve o problema de 0.5, 2.5
        prod = prod * abs(p(1,j) - 2); % ref = (2, 2, ..., 2)
    end
end