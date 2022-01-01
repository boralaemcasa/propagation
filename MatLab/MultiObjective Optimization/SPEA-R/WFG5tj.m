function [t] = WFG5tj(y, j, k)
    M = size(y,1);
    if j == 1
        t = ones(M, 1);
        for i = 1:M
            t(i) = WFG_sdecept(y(i), 0.35, 0.001, 0.05);
        end
    elseif j == 2
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