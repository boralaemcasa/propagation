function [result] = WFG_bparam(y, z, A, B, C)
    M = size(z, 1);
    u = WFG_rsum(z, ones(M, 1)); % u = reduction function
    v = A - (1 - 2*u) * abs(floor(0.5 - u) + A);
    result = y^(B + (C - B)*v);
end