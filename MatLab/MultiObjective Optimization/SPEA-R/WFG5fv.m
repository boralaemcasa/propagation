function [PV] = WFG5fv(N, M)
    %Gerar Pareto Verdadeira na esfera unitária, uniformemente distribuída
    PV = UniformPoint(N, M);
    PV = PV./repmat(sqrt(sum(PV.^2,2)),1,M);
end