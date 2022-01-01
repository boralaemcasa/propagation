function [result] = WFG_sdecept(y, A, B, C)
    result = 1 + (abs(y - A) - B) * ( floor(y - A + B) * (1 - C + (A - B)/B)/(A - B) + floor(A + B - y) * (1 - C + (1 - A - B)/B)/(1 - A - B) + 1/B );
end