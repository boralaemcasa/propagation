function [y] = WFG3(x)
    M = size(x, 1);
    y = ones(M, 1);
    for m = 1:M-1
        for i = 1:M-m
            y(m) = y(m) * x(i); 
        end
        if m >= 2
            y(m) = y(m) * (1 - x(M - m + 1));
        end
    end
    y(M) = 1 - x(1);
end