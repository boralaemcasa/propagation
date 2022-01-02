function [result] = WFG_mixed(M, x, alpha, A)
    result = (1 - x - cos(2*A*pi*x + pi/2)/(2*A*pi))^alpha;
end
