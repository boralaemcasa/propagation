function [P2, theta, vartheta, RSE, saida] = fsContribInit(nVariaveis, X, sfun)
	P2 = zeros(nVariaveis,nVariaveis,1);
	theta = zeros(nVariaveis,1);
	vartheta = zeros(1,nVariaveis);
	RSE = 0;
	saida = [0 -1];
end