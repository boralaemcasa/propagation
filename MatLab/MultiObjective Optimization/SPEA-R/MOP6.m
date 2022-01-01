function [y] = MOP6(x)
    y = [1; 1];
    z = 1 + 10 * x(2);
    y(1) = x(1);
    y(2) = z * (1 - (x(1)/z)^2 - x(1)/z * sin(8 * pi * x(1)));
end