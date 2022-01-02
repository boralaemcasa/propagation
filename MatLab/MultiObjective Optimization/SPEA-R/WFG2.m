function [y] = WFG2(x)
    M = size(x, 1);
    y = ones(M, 1);
    for m = 1:M-1
        for i = 1:M-m
            y(m) = y(m) * (1 - cos(x(i) * pi/2)); 
        end
        if m >= 2
            y(m) = y(m) * (1 - sin(x(M - m + 1) * pi/2));
        end
    end
    y(M) = WFG_disc(M, x(1), 1, 1, 5);
end