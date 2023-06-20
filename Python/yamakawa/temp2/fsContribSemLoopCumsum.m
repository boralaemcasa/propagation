function [n, cols, V] = fsContribSemLoopCumsum(nVariaveis, xt, ydt, constContribGlobal, h)
	global P2;
	global theta;
	global vartheta;
	global RSE;
	global saida;
	x = 1:nVariaveis;
	s = size(x,2);
	constPCA = 0.90;
	
	[theta, P2, RSE] = regressores2(s, nVariaveis, xt, ydt, P2, theta, RSE);
    if h > 1
        contribuicao = abs(theta);
        contribuicao = contribuicao/sum(contribuicao); % ou sobre o max
        [a,b] = sort(contribuicao,'desc');
        m = min(find(cumsum(a) >= constPCA));
        for i = m+1:s
            x(b(i)) = 0;
        end		
    end
    
    cols = notnull(x);
    n = size(cols,2);
    V = [];
end