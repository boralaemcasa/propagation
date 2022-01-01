function [soma,HV] = SP_IGD(x, y)
    [A, ndim] = size(y);
    V = size(x, 1);
    soma = 0;
    for i = 1:V
        for j = 1:A
            d(j,:) = norm(x(i,:) - y(j,:));
        end
        soma = soma + min(d);
    end
    soma = soma/V;
    PopObj = WFG5Pop(y);
    HV = HV_referenced(PopObj);
end