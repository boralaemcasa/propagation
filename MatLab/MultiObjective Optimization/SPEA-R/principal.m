clc
clear

% Rodar o SPEA-R;
% *) Stops after 300, 600, 1000, 1500, and 2000 generations for 2, 3, 5, 8, 12-objective cases, respectively
% 1) Conferir com as tabelas de IGD e HV;
% 2) Gráficos 6, 10,11,13,14;
% 3) Global.Variation := simulated binary crossover, polynomial mutation. CVEA3 = DOI: 10.1109/CEC.2018.8477649
% SPEA-R vs 4) MOEA/D-M2M 
%           5) MOEA/D-ACD := DOI: 10.1109/TEVC.2015.2457616 => 6) gráfico f1, f2, f3, MOP7, (4,5)
%           7) HypE := DOI: 10.1162/EVCO_a_00009
%           8) PICEA-g := DOI: 10.1109/TEVC.2012.2204264
%           9) NSGA-III := DOI: 10.1109/TEVC.2013.2281535 => 10) gráfico f1, f2, f3, scaled WFG5, (9)
%              => 11) gráfico sample size vs pop size, M = 3, 5, 7, 8, 15, 30, (9)
%          12) SPEA2+SDE := DOI: 10.1109/TEVC.2013.2262178 => 13) gráfico objective nro vs objective value, WFG4, ndim = 20, 40, (7,8,9,12)
%          14) gráfico generation vs % of dominated solutions, WFG5, comparar com os outros
% Relevar: SPEA-R, WFG5, NSGA-III, 9, 10, 11, 13, 14, MOP7, MOEA/D-M2M, 6, [Add MOEA/D-ACD], [Add HypE, PICEA-g, SPEA2+SDE]. 
%          Tabela de IGD, HV, MOP1-7, 4,5. WFG1-9, 7,8,9,12, M = 2,3,5,8,12.
%          Tabela de HV, K = 2,5,10,20,40,50, WFG5-8, M = 2,3,5,8,12.
    
Global = GlobalClass;
Global.N = 1;
Global.Mx = 3;
Global.My = 3;
Global.MaxGen = 10;
Global.Lower = 0;
Global.Upper = 1000;
Global.F = "WFG5";
SPEAR(Global)
Global.Mx = 2;
Global.F = "MOP7"; %*** fv
SPEAR(Global)
Global.F = "MOP5"; %*** fv
SPEAR(Global)
Global.My = 2;
Global.N = 16;
Global.F = "MOP3"; %*** fv
SPEAR(Global)
Global.F = "MOP6"; %*** fv
SPEAR(Global)
Global.Mx = 1;
Global.F = "MOP1"; %*** fv
SPEAR(Global)
Global.Mx = 4;
Global.F = "MOP2"; %*** fv
SPEAR(Global)
Global.Mx = 3;
Global.F = "MOP4"; %*** fv
SPEAR(Global)
Global.My = 3;
Global.F = "WFG1"; %*** fv
SPEAR(Global)
Global.F = "WFG2"; %*** fv
SPEAR(Global)
Global.F = "WFG3"; %*** fv
SPEAR(Global)
Global.F = "WFG4"; %*** fv
SPEAR(Global)
Global.F = "WFG6"; %*** fv
SPEAR(Global)
Global.F = "WFG7"; %*** fv
SPEAR(Global)
Global.F = "WFG8"; %*** fv
SPEAR(Global)
Global.F = "WFG9"; %*** fv
SPEAR(Global)