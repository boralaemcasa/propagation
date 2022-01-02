function [y] = WFG_concave(x)
    M = size(x, 1);
    y = ones(M, 1);
    for m = 1:M-1
        for i = 1:M-m
            y(m) = y(m) * sin(x(i) * pi/2); 
        end
        if m >= 2
            y(m) = y(m) * cos(x(M - m + 1) * pi/2);
        end
    end
    y(M) = cos(x(1) * pi/2);
end