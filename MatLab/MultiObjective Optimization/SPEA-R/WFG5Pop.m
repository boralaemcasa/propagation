function [PopObj] = WFG5Pop(Population)
    [N, M] = size(Population);
    PopObj = ones(N, M);
    for i = 1:N
        PopObj(i,:) = WFG5(Population(i,:)')';
    end
end