function [t] = WFG3tj(y, j, k)
    M = size(y,1);
    if j == 1
        t = y;
        for i = k+1:M
            t(i) = WFG_slinear(y(i), 0.35);
        end
    elseif j == 2
        t = y;
        fim = fix((M + k)/2);
        for i = k+1:fim
            index = k + 2 * (i - k) - 1;
            t(i) = WFG_rnonsep(y(index:index+1), 2);
        end
    elseif j == 3
        t = ones(M, 1);
        for i = 1:M-1
            index = fix((i - 1) * k/(M - 1)) + 1;
            fim = fix(i*k/(M - 1));
            if fim < index
                fim = index;
            end
            w = ones(fim-index+1, 1);
            t(i) = WFG_rsum(y(index:fim), w);
        end
        w = ones(M-k, 1);
        t(M) = WFG_rsum(y(k+1:M), w);
    else
        t = 0;
    end
end