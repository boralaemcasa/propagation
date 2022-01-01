function [soma,HV] = SP_IGD(x, Population, f, ref, M)
    y = WFG_objective_pop(Population, f, M);
    A = size(y, 1);
    V = size(x, 1);
    soma = 0;
    for i = 1:V
        for j = 1:A
            d(j,:) = norm(x(i,:) - y(j,:));
        end
        soma = soma + min(d);
    end
    soma = soma/V;
    HV = HV_referenced(y, ref);
end