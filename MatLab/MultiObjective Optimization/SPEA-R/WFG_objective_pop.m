function [PopObj] = WFG_objective_pop(Population, f, M)
	N = size(Population, 1);
    PopObj = ones(N, M);
    for i = 1:N
        PopObj(i,:) = feval(f, Population(i,:)')';
    end
end