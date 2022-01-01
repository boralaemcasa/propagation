function [y] = WFG_objective(z, f)
    z = z/max(z);
    y = z;
    k = 3;
    ft = f + "t";
    t = feval(ft, y, k);
    M = size(t,1);
    A = ones(M, 1);
    if f == "WFG3"
        A(2:end) = 0;
    end
    x = t; % x(M) = t(M)
    for i = 1:M-1
        x(i) = max(t(M),A(i)) * (t(i) - 0.5) + 0.5;
    end
    S = ones(M, 1);
    for i = 1:M
        S(i) = 2 * i;
    end
    h = feval(f, x);
    h = S .* x;
    y = h;
    D = 1;
    y(M) = D * x(M);
end
