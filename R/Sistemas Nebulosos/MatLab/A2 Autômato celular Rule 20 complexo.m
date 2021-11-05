% Autor: Gledson Melotti
% Calculando o aut�mato celular regra 20 complexo
% s(t+1,x)=(s(t,x-1))xor(s(t,x))xor(s(t,x+1))
clear all
close all
clc
constante = 100;
tv=constante; % tamanho do vetor
% O estado atual das celulas
a=zeros(1,constante);
% O novo estado das celulas
newa=zeros(1,tv);
% Iniciar o processo com pelo menos uma celula viva.
a=round(rand(1,tv));
g=1; % definam a gera��o atual
max=constante; % n�mero m�ximo de gera��es
B(1,:)=a;
while (g<max)
for i=1:tv,
% i e a posi�ao atual
e=i-1; % 1 posi�ao anterior
k=i-2; % 2 posi��es anteriores
f=i+1; % 1 posi��o posterior
h=i+2; % 2 posi��es posteriores
% utilizando limite periodico
if e==0
e=tv;
end
if k==-1
k=tv-1;
end
if k==0
k=tv;
end
if f==tv+1
f=1;
end
if h==tv+2
h=2;
end
if h==tv+1
h=1;
end
% atualizando o automato a cada instante
%s=xor(xor(xor(xor(a(k), a(e)), a(i)), a(f)), a(h));
%switch s
%case{1}
%newa(i)=1;
%case{0}
%newa(i)=0;
%end
s=a(k)+a(e)+a(i)+a(f)+a(h);
switch s
case{5}
anew(i)=0;
case{4}
newa(i)=1;
case{3}
newa(i)=0;
case{2}
newa(i)=1;
case{1}
newa(i)=0;
case{0}
newa(i)=0;
end
end
g=g+1;
a=newa;
B(g,:)=a;
end
spy(B,'k')
title('Aut�mato Celular Rule 20 Complexo','fontsize',20)
