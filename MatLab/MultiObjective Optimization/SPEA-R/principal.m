clc
clear
p = [1.5;2.5;3.5;4.5;5.5];
WFG_objective(p, "WFG3");
WFG_objective(p, "WFG5");

% 1) Rodar o SPEA-R;
%    *) Gerar Pareto Verdadeira na esfera unitária, uniformemente distribuída;
%    *) Global.NotTermination := stops after 300, 600, 1000, 1500, and 2000 generations for 2, 3, 5, 8, 12-objective cases, respectively
%    *) Global.Variation := simulated binary crossover, polynomial mutation. CVEA3 = DOI: 10.1109/CEC.2018.8477649
%    *) ObjectiveNormalization := função objetivo == string;
%    *) Conferir com as tabelas de IGD e HV;
%    *) Gráficos 10,11,13,14;
% 2) MOP1-7 := DOI: 10.1109/TEVC.2013.2281533 contém MOEA/D-M2M
% 3) WFG1-9 := DOI: 10.1109/TEVC.2005.861417 contém MOP1-7
%    SPEA-R vs 4) MOEA/D-M2M 
%              5) MOEA/D-ACD := DOI: 10.1109/TEVC.2015.2457616 => 6) gráfico f1, f2, f3, MOP7, (4,5)
%              7) HypE := DOI: 10.1162/EVCO_a_00009
%              8) PICEA-g := DOI: 10.1109/TEVC.2012.2204264
%              9) NSGA-III := DOI: 10.1109/TEVC.2013.2281535 => 10) gráfico f1, f2, f3, scaled WFG5, (9)
%                 => 11) gráfico sample size vs pop size, M = 3, 5, 7, 8, 15, 30, (9)
%             12) SPEA2+SDE := DOI: 10.1109/TEVC.2013.2262178 => 13) gráfico objective nro vs objective value, WFG4, ndim = 20, 40, (7,8,9,12)
%             14) gráfico generation vs % of dominated solutions, WFG5, comparar com os outros
%    Relevar: SPEA-R, WFG5, NSGA-III, 9, 10, 11, 13, 14, MOP7, MOEA/D-M2M, 6, [Add MOEA/D-ACD], [Add HypE, PICEA-g, SPEA2+SDE]. 
%             Tabela de IGD, HV, MOP1-7, 4,5. WFG1-9, 7,8,9,12, M = 2,3,5,8,12.
%             Tabela de HV, K = 2,5,10,20,40,50, WFG5-8, M = 2,3,5,8,12.
    
Global = GlobalClass;
Global.N = 1;
Global.M = 3;
Global.Lower = 0;
Global.Upper = 1000;
SPEAR(Global)