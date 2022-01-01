function SPEAR(Global)
% <algorithm> <O-Z>
% A Strength Pareto Evolutionary Algorithm Based on Reference Direction for
% Multi-objective and Many-objective Optimization

%--------------------------------------------------------------------------
% Copyright (c) 2016-2017 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB Platform
% for Evolutionary Multi-Objective Optimization [Educational Forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    Global.K = 20;
    Global.Layers = 3;
    %% Generate the reference directions (general approach)
    [W, Global.N] = SP_ReferenceGeneration(Global.N,Global.M,Global.Layers);
    % Largest acute angle between two neighbouring reference directions
    cosine = 1 - pdist2(W,W,'cosine');
    cosine(logical(eye(length(cosine)))) = 0;
    theta  = max(min(acos(cosine),[],2));
    
    %% Generate random population
    Population = Global.Initialization();

    %% Optimization
	Global.Epoca = 0;
    while Global.NotTermination(Population)
        PopObj     = WFG5Pop(Population);
        MatingPool = SP_MatingSelection(PopObj,Global.K);
        Offspring  = Global.Variation(Population([1:Global.N,MatingPool]),Population(MatingPool,:));
        QObj       = SP_ObjectiveNormalization([Population;Offspring]);
        [Ei,Angle] = SP_Associate(QObj,W);
        FV         = SP_FitnessAssignment(Ei,QObj,Angle,theta);
        Population = SP_EnvironmentalSelection([Population;Offspring],Ei,FV,Global.N);
        Global.Epoca = Global.Epoca + 1;
    end
    
    %Gerar Pareto Verdadeira na esfera unitária, uniformemente distribuída
    V = 2 * Global.N;
    PV = rand(V, Global.M);
    for i = 1:V
        PV(i,:) = PV(i,:)/norm(PV(i,:));
    end
    [igd, hv] = SP_IGD(PV, Population);
    fprintf("%d pontos. Após %d épocas, %d pontos.\n", Global.N, Global.Epoca, size(Population,1));
    fprintf("IGD = %f\nHyperVolume = %f\n", igd, hv);
end