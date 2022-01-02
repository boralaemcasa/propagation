function [t] = WFG1tj(y, j, k)
    M = size(y,1);
    if j == 1
        t = y;
        for i = k+1:M
            t(i) = WFG_slinear(y(i), 0.35);
        end
    elseif j == 2
        t = y;
        for i = k+1:M
            t(i) = WFG_bflat(y(i), 0.8, 0.75, 0.85);
        end
    elseif j == 3
        t = ones(M, 1);
        for i = 1:M
            t(i) = WFG_bpoly(y(i), 0.02);
        end
    elseif j == 4
        t = ones(M, 1);
        for i = 1:M-1
            index = fix((i - 1) * k/(M - 1)) + 1;
            fim = fix(i*k/(M - 1));
            if fim < index
                fim = index;
            end
            w = index:fim;
            t(i) = WFG_rsum(y(index:fim), 2 * w');
        end
        w = k+1:M;
        t(M) = WFG_rsum(y(k+1:M), 2 * w');
    else
        t = 0;
    end
end