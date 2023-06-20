function [n, cols, V] = fsContribSemLoopMax(nVariaveis, xt, ydt, constTheta, h)
	global P2;
	global theta;
	global vartheta;
	global RSE;
	global saida;
	x = 1:nVariaveis;
	s = size(x,2);
    constTheta = 0.10; % 10% do máximo
	
	[theta, P2, RSE] = regressores2(s, nVariaveis, xt, ydt, P2, theta, RSE);
    if h > 1
        contribuicao = abs(theta);
        contribuicao = contribuicao/max(contribuicao);
        for i = 1:s
            if contribuicao(i) <= constTheta
                x(i) = 0;
            end
        end		
    end
    
    cols = notnull(x);
    n = size(cols,2);
    V = [];
end