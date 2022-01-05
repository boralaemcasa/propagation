function [PopObj] = WFG_objective_pop(Population, f, M)
	N = size(Population, 1);
    PopObj = ones(N, M);
	Population = Population';
    for i = 1:N
        PopObj(i,:) = WFG_objective(Population(:,i), f, M);
    end
end