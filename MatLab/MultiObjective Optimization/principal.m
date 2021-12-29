clc
clear

p = [1,1;0.5,2.5]
hypervolume(p)

[A, hvA] = IGD(2, 10, 5)
[B, hvB] = IGD(2, 10, 5)
if A < B
    disp('Ganhou o A')
elseif B < A
    disp('Ganhou o B')
else
    disp('A = B')
end

% TestarFuncao('MaF1')
% TestarFuncao('MaF2')
% TestarFuncao('MaF3')
% TestarFuncao('MaF4')
% TestarFuncao('MaF5')
% TestarFuncao('MaF6')
% TestarFuncao('MaF7')
% TestarFuncao('MaF8')
% figure
% TestarFuncao('MaF9')
% TestarFuncao('MaF10')
% TestarFuncao('MaF11')
% TestarFuncao('MaF12')
% TestarFuncao('MaF13')
% TestarFuncao('MaF14')
% TestarFuncao('MaF15')
