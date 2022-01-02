function [result] = WFG_smulti(y, A, B, C)
    z = abs(y - C)/2/(floor(C - y) + C);
    result = (1 + cos((4*A + 2)*pi*(0.5 - z)) + 4 * B * z^2)/(B + 2);
end