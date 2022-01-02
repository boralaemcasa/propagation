function [t] = WFG6tj(y, j, k)
    M = size(y,1);
    if j == 1
        t = y;
        for i = k+1:M
            t(i) = WFG_slinear(y(i), 0.35);
        end
    elseif j == 2
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