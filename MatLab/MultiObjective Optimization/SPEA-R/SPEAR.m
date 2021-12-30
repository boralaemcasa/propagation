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

    %% Generate the reference directions (general approach)
    [W,Global.N] = UniformPoint(Global.N,Global.M);
    % Largest acute angle between two neighbouring reference directions
    cosine = 1 - pdist2(W,W,'cosine');
    cosine(logical(eye(length(cosine)))) = 0;
    theta  = max(min(acos(cosine),[],2));
    
    %% Generate random population
    Population = Global.Initialization();

    %% Optimization
	Global.Epoca = 0;
    while Global.NotTermination(Population)
        MatingPool = MatingSelection(Population,20);
        Offspring  = Global.Variation(Population([1:Global.N,MatingPool]),Population(MatingPool,:));
        QObj       = ObjectiveNormalization([Population;Offspring]);
        [Ei,Angle] = Associate(QObj,W);
        FV         = FitnessAssignment(Ei,QObj,Angle,theta);
        Population = EnvironmentalSelection([Population;Offspring],Ei,FV,Global.N);
        s = size(Population);
        Population = reshape(Population, s(2)/Global.M, s(1)*Global.M);
        Global.Epoca = Global.Epoca + 1;
    end
    [igd, hv] = IGD(2 * Global.N, Population);
    fprintf("%d linhas. Após %d épocas, %d linhas.\n", Global.N, Global.Epoca, size(Population,1));
    fprintf("IGD = %f\nHyperVolume = %f\n", igd, hv);
end