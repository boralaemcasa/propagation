function [y] = MOP4(x)
    y = [1; 1];
    y(1) = - 10 * exp(- 0.2 * sqrt(x(1)^2 + x(2)^2)) - 10 * exp(- 0.2 * sqrt(x(2)^2 + x(3)^2));
    y(2) = abs(x(1))^0.8 + 5 * sin(x(1)^3) + abs(x(2))^0.8 + 5 * sin(x(2)^3) + abs(x(3))^0.8 + 5 * sin(x(3)^3);
end