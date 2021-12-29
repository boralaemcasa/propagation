function [soma,HV] = IGD(ndim, V, A)
    % de acordo com o paper de Cheng,
    % sabemos quem é cada x^* = (?)
    % 1) Gerar uma Pareto Verdadeira PV com V pontos x_i;
    % 2) Gerar uma Pareto Aproximada PA com A pontos y_j;
    % 3) Calcular Distância Geracional Invertida IGD = 1/V * sum i = 1 to V, d(x_i, PA)
    %    Onde a distância euclideana d = min[1 <= j <= A] dist(x_i, y_j)
    % 4) Comparar IGD de algoritmo tal com algoritmo qual.

    x = rand(V, ndim);
    y = rand(A, ndim);
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