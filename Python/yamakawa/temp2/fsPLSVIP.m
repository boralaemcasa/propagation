function [n, cols, V] = fsPLSVIP(nVariaveis, xt, ydt, constContribGlobal, h)
    V = [];
    [n, cols] = metodoPLS_VIPOnline(nVariaveis, xt, ydt, h);
end