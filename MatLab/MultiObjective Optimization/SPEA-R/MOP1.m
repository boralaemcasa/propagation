function [y] = MOP1(x)
    y = [1; 1];
    y(1) = x;
    y(2) = (x - 2)^2;
end