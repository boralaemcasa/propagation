% Autor: Gledson Melotti
% Calculando o autômato celular regra 18
% s(t+1,x)=(s(t,x-1))xor(s(t,x))xor(s(t,x+1))
clear all;
close all;
clc
% Tamanho do vetor
constante = 100;
tv=constante;
% O estado atual das celulas
a=zeros(1,tv);
% O novo estado das celulas
newa=zeros(1,tv);
% Iniciar o processo com pelo menos uma celula viva.
a=round(rand(1,tv));
g=1; % geração atual.
max=constante; % número máximo de geração.
B(1,:)=a;
while (g<max),
for i=1:tv,
% i e a posiçao atual
e=i-1; % 1 posiçao anterior
f=i+1; % 1 posição posterior
% utilizando limite periodico
if e==0
e=tv;
end
if f==tv+1
f=1;
end
% atualizando o automato a cada instante
if a(e)==1 && a(i)==1 && a(f)==1
newa(i)=0;
end
if a(e)==1 && a(i)==1 && a(f)==0
newa(i)=0;
end
if a(e)==0 && a(i)==1 && a(f)==1
newa(i)=0;
end
if a(e)==0 && a(i)==1 && a(f)==0
newa(i)=0;
end
if a(e)==1 && a(i)==0 && a(f)==1
newa(i)=0;
end
if a(e)==1 && a(i)==0 && a(f)==0
newa(i)=1;
end
if a(e)==0 && a(i)==0 && a(f)==1
newa(i)=1;
end
if a(e)==0 && a(i)==0 && a(f)==0
newa(i)=0;
end
end
g=g+1;
a=newa;
B(g,:)=a;
end
spy(B,'k')
title('Autômato Celular Rule 18','fontsize',20)
