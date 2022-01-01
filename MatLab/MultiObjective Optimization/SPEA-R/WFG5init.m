function [pop] = WFG5init(N, M)
    % como vai convergir para S^M, que tal o plano sum(x) = constante?
    pop = rand(N, M);
    pop(:, M) = 3 - sum(pop(:,1:M-1),2);
end