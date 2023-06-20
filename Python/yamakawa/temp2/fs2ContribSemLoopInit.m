function [P2, theta, vartheta, RSE, saida] = fs2ContribSemLoopInit(nVariaveis, X, sfun)
	P2 = zeros(nVariaveis,nVariaveis,2);
	theta = zeros(nVariaveis,2);
	vartheta = [];
	RSE = [0 0];
	saida = [];	
end