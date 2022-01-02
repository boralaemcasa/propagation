function [result] = WFG_bflat(y, A, B, C)
    result = A + min(0, floor(y - B)) * A * (B - y)/B - min(0, floor(C - y)) * (1 - A) * (y - C)/(1 - C);
end