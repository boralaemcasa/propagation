function [t] = WFG9tj(y, j, k)
    M = size(y,1);
    if j == 1
        t = y;
        for i = 1:M-1
            t(i) = WFG_bparam(y(i), WFG_rsum(y(i+1:M), ones(M-i,1)), 0.98/49.98, 0.02, 50);
        end
    elseif j == 2
        t = ones(M, 1);
        for i = 1:k
            t(i) = WFG_sdecept(y(i), 0.35, 0.001, 0.05);
        end
        for i = k+1:M
            t(i) = WFG_smulti(y(i), 30, 95, 0.35);
        end
    elseif j == 3
        t = ones(M, 1);
        for i = 1:M-1
            index = fix((i - 1) * k/(M - 1)) + 1;
            fim = fix(i*k/(M - 1));
            if fim < index
                fim = index;
            end
            t(i) = WFG_rnonsep(y(index:fim), k/(M - 1));
        end
        t(M) = WFG_rnonsep(y(k+1:M), M);
    else
        t = 0;
    end
end