function [soma] = WFG_rnonsep(y, A)
    soma = 0;
    n = size(y,1);
    for j = 1:n
        soma = soma + y(j);
        for k = 0:A-2
            soma = soma + abs(y(j) - y(1 + rem(j + k, n)));
        end
    end
    soma = soma/( n/A * ceil(A/2) * (1 + 2 * A - 2 * ceil(A/2)) );
end