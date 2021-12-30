function [soma,HV] = IGD(V, y)
    [A, ndim] = size(y);
    x = rand(V, ndim);
    soma = 0;
    for i = 1:V
        for j = 1:A
            d(j,:) = norm(x(i,:) - y(j,:));
        end
        soma = soma + min(d);
    end
    soma = soma/V;
    HV = hypervolume(y);
end