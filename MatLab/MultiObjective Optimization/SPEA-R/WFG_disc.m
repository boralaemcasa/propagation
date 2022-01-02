function [result] = WFG_disc(M, x, alpha, beta, A)
    result = 1 - x^alpha * cos(A * x^beta * pi)^2;
end
