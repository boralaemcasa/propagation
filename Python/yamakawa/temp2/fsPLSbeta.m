function [n, cols, V] = fsPLSbeta(nVariaveis, xt, ydt, constContribGlobal, h)
    V = [];
    [n, cols] = metodoPLSbetaOnline(nVariaveis, xt, ydt, h, constContribGlobal);
end