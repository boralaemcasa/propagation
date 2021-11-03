close all;
clear all;
clc;
% Inicializa gerador de números pseudorandômicos
rand('state', sum(100*clock));
% Definindo a dimensão da matriz
m = 200; % número de linhas
n = 200; % número de colunas
% Probabilidade de cura
Pc=0.6;
% Probabilidade de morte por causa da doença
Pd=0.3;
% Probabilidade de morte devido outra causa (não a doença)
Pn=0.1;
% Parâmetro relacionado com a infecciosidade da doença
beta=3.5;
% Número total de indivíduos
N=m*n;
% Célula = 0 -> preto - indivíduo infectado
% Célula = 1 -> cinza - indivíduo suscetível
% Célula = 2 -> branco - indivíduo recuperado
% Colocando os indivíduos na matriz
% Gerando os suscetíveis
% S(0)=99,5%;
A=ones(m,n);
% Gerando os infectados
% I(0)=0,5%;
pa=randperm(N);
I0=floor(0.005*N);
A(pa(1:I0))=0;
% Gerando séries temporais
inf(1) = length(find(A == 0));
sus(1) = length(find(A == 1));
rec(1) = length(find(A == 2));
z=zeros(m,n);
% Criando a imagem MBI
imh = image(cat(3,A*30));
colormap(gray)
%%%set(imh, 'erasemode', 'none')
axis equal
axis tight
% Desativa os labels e marcas
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'XTickLabel',{});
set(gca,'YTickLabel',{});
% Distância máxima de deslocamento para o contato não-local
Dmax = 200;
A_tudo=[];
%------------- Atualizando as células------------
% "L" representa o numero da linhas e "Co" representa
% o numero de colunas.
% Definindo uma matriz vazia para receber a matriz A atualizada.
Niter=5;
MA=A;
for k = 1 : Niter
k
for L=1:m
for Co=1:n
% Comparando os extremos da matriz com relação ao limite periodico.
aa=L-1;
bb=Co+1;
cc=Co-1;
dd=L+1;
if aa == 0
aa = m;
end
if bb > n
bb = 1;
end
if cc == 0
cc = n;
end
if dd > m
dd = 1;
end
% Suscetivel=>Infectado (contato local)
% Números de vizinhos infectados
if A(aa,cc)==0
v1=1;
else
v1=0;
end
if A(aa,Co)==0
v2=1;
else
v2=0;
end
if A(aa,bb)==0
v3=1;
else
v3=0;
end
if A(L,cc)==0
v4=1;
else
v4=0;
end
if A(L,bb)==0
v5=1;
else
v5=0;
end
if A(dd,cc)==0
v6=1;
else
v6=0;
end
if A(dd,Co)==0
v7=1;
else
v7=0;
end
if A(dd,bb)==0
v8=1;
else
v8=0;
end
v= v1+v2+v3+v4+v5+v6+v7+v8;
Pi=(beta*v)/8;
Prand_s=rand;
if A(L,Co)==1 && Prand_s<=Pi
MA(L,Co)=0;
end
% Probabilidade de contato não-local para cada indivíduo.
Pnl=rand;
% Taxa de reprodutividade basal
Ro=3.142;
% Obtendo o parâmetro fuzzy D (Distância) para o deslocamento
%%%param = readfis('ca_epidemia.fis');
%%%D = round(evalfis([Ro Pnl],param) * Dmax);
D = randi(Dmax) - 1;
% Suscetivel=>Infectado (contato nao local)
if (A(L,Co) == 0 && Pnl ~= 0 && D ~= 0)
p1 = Pnl; % Probabilidade de contato não-local
p2 = rand; % Probabilidade aleatória
if (p1 >= p2)
% Sorteia uma direção de deslocamento
if (rand > 0.5)
Ldir = 1;
else
Ldir = -1;
end
if (rand > 0.5)
Cdir = 1;
else
Cdir = -1;
end
% Calcula o deslocamento
DL = (D * Ldir) + L;
DCo = (D * Cdir) + Co;
% Verifica os limites do deslocamento
if (DL < 1)
DL = DL + m;
end
if (DCo < 1)
DCo = DCo + n;
end
if (DL > m)
DL = DL - m;
end
if (DCo > n)
DCo = DCo - n;
end
% Verifica se o vizinho não local é suscetível
if (A(DL,DCo) == 1)
% Comparando os extremos da matriz com relaçao ao limite periodico.
ee=DL-1;
ff=DCo+1;
gg=DCo-1;
hh=DL+1;
if ee == 0
ee = m;
end
if ff > n
ff = 1;
end
if gg == 0
gg = n;
end
if hh > m
hh = 1;
end
% Números de vizinhos infectados
if A(ee,gg)==0
v1nl=1;
else
v1nl=0;
end
if A(ee,Co)==0
v2nl=1;
else
v2nl=0;
end
if A(ee,ff)==0
v3nl=1;
else
v3nl=0;
end
if A(L,gg)==0
v4nl=1;
else
v4nl=0;
end
if A(L,ff)==0
v5nl=1;
else
v5nl=0;
end
if A(hh,gg)==0
v6nl=1;
else
v6nl=0;
end
if A(hh,Co)==0
v7nl=1;
else
v7nl=0;
end
if A(hh,ff)==0
v8nl=1;
else
v8nl=0;
end
vnl=v1nl+v2nl+v3nl+v4nl+v5nl+v6nl+v7nl+v8nl;
p1 =(beta*vnl)/8; % Probabilidade de infecção
p2 = rand; % Probabilidade aleatória
if (p1 >= p2)
MA(DL,DCo) = 0;
end
end
end
end
% Recuperação
Prand_ic=rand;
if A(L,Co)==0 && Prand_ic<=Pc % Cura
MA(L,Co)=2;
end
% Morte por doença
Prand_im=rand;
if A(L,Co)==0 && Prand_im<=Pd % Morte
MA(L,Co)=1;
end
% Morte natural
p1=rand;
if p1<=Pn
MA(L,Co)=1;
end
end % for Co
end % for L
% Atualiza matriz
A = MA;
% Plota matriz
%%%set(imh, 'cdata', cat(3,A*30));
imh = image(cat(3,A*30));
title(['Tempo = ',num2str(k)]);
drawnow;
% Gerando séries temporais
inf(k+1) = length(find(A == 0));
sus(k+1) = length(find(A == 1));
rec(k+1) = length(find(A == 2));
A_tudo=[A_tudo;A];
end
figure
plot(sus,'k');
hold on;
plot(inf,'g');
hold on
plot(rec,'r');
axis([0 100 0 40000]);
legend('Suscetível','Infectado', 'Recuperado');
xlabel('Tempo');
ylabel('Indivíduos');