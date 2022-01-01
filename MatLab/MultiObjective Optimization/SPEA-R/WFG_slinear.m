function [result] = WFG_slinear(y, A)
    result = abs(y - A)/abs(fix(A - y) + A);
end