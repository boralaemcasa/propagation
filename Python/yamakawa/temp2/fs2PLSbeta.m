function [n, cols, V] = fs2PLSbeta(nVariaveis, xt, ydt, constContribGlobal, h)
    V = [];
    [n, cols] = metodoPLSbetaOnline(nVariaveis, xt, ydt, h, constContribGlobal);
end