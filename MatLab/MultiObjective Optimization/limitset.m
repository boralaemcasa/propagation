function [q] = limitset(p, k)
    s = size(p);
    q = ones(s(1) - k, s(2));
    for i = 1:(s(1) - k)
        for j = 1:s(2)
            q(i,j) = worse(p(k, j), p(k + i, j));
        end
    end
end