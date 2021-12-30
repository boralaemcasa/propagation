clc
clear

% 1) Gerar uma Pareto Verdadeira PV com V pontos x_i;
% *) Rodar o SPEA-R;
%    2) UniformPoint := Reference_Generation();
%    3) Global.Initialization := Muitos pontos de pareto para filtrar;
%    4) Global.NotTermination := Quando é que está ótimo?
%    5) Global.Variation := BCEIBEA - simulated binary crossover (SBX), Polynomial mutation
%    6) ObjectiveNormalization := Função objetivo;
%    7) Depois do EnvironmentalSelection, o size mudou.
%    8) O uso do NDSort simplificado.
% *) Gerar uma Pareto Aproximada PA com A pontos y_j;
% *) Calcular IGD e Hypervolume := Cuidado com o (2,2);
% 2) MOP1-7 := H. Liu, F. Gu, and Q. Zhang, “Decomposition of a multiobjective optimization problem into a number of simple multiobjective subproblems,” IEEE Trans. Evol. Comput., vol. 18, no. 3, pp. 450–455, 2014.
% 3) WFG1-9 := S. Huband, P. Hingston, L. Barone, and L. While, “A review of multiobjective test problems and a scalable test problem toolkit,” IEEE Trans. Evol. Comput., vol. 10, no. 2, pp. 477–506, 2006.
%    SPEA-R vs 4) MOEA/D-M2M 
%              5) MOEA/D-ACD => 6) gráfico f1, f2, f3, MOP7
%              7) HypE
%              8) PICEA-g
%              9) MOEA-D
%             10) NSGA-III => 11) gráfico f1, f2, f3, scaled WFG5
%             12) SPEA2+SDE => 13) gráfico objective nro vs objective value, WFG4, ndim = 20, 40
%             14) MOEA-D ou NSGA-III, gráfico sample size vs pop size, M = 3, 5, 7, 8, 15, 30
%             15) gráfico generation vs % of dominated solutions, WFG5, comparar com os outros
    
Global = GlobalClass;
Global.N = 10;
Global.M = 2;
Global.Lower = 0;
Global.Upper = 1000;
SPEAR(Global)