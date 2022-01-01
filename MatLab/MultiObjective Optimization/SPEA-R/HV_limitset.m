function [q] = HV_limitset(p, k, ref)
    s = size(p);
    q = ones(s(1) - k, s(2));
    for i = 1:(s(1) - k)
        for j = 1:s(2)
            q(i,j) = HV_worse(p(k, j), p(k + i, j), ref(j));
        end
    end
    q = unique(q,'rows');
end