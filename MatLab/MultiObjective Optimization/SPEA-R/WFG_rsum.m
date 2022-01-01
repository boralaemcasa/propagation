function [result] = WFG_rsum(y, w)
    result = w' * y / sum(w);
end