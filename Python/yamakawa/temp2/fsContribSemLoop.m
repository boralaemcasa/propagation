function [n, cols, V] = fsContribSemLoop(nVariaveis, xt, ydt, constContribGlobal, h)
	global P2;
	global theta;
	global vartheta;
	global RSE;
	global saida;
	x = 1:nVariaveis;
	s = size(x,2);
	constContrib = constContribGlobal/s;
	
	[theta, P2, RSE] = regressores2(s, nVariaveis, xt, ydt, P2, theta, RSE);
    if h > 1
        contribuicao = abs(theta);
        contribuicao = contribuicao/sum(contribuicao); % ou sobre o max
        for i = 1:s
            if contribuicao(i) <= constContrib
                x(i) = 0;
            end
        end		
    end
    
    cols = notnull(x);
    n = size(cols,2);
    V = [];
end