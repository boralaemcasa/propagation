function [PV] = WFG5fv(N, M)
    %Gerar Pareto Optimal Front Verdadeira na esfera unitária, uniformemente distribuída
    PV = FastCar_UniformPoint(N, M);
    PV = PV./repmat(sqrt(sum(PV.^2,2)),1,M);
end