function [P2, theta, vartheta, RSE, saida] = fsContribSemLoopCumsumInit(nVariaveis, X, sfun)
	P2 = zeros(nVariaveis,nVariaveis);
	theta = zeros(nVariaveis,1);
	vartheta = [];
	RSE = 0;
	saida = [];	
end