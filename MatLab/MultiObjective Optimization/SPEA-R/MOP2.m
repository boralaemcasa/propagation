function [y] = MOP2(x)
    y = [0; 0];
    n = size(x, 1);
    for i = 1:n
        y(1) = y(1) + (x(i) - 1/sqrt(n))^2;
        y(2) = y(2) + (x(i) + 1/sqrt(n))^2;
    end
    y(1) = 1 - exp(- y(1));
    y(2) = 1 - exp(- y(2));
end