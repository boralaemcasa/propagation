function [RETORNO] = RUN3(dim, isa_FV)

a = 0.0263;

for Imetqn = 0:3
% ALGORITMO QUASE NEWTON:
% Imetqn = 0 --> Algoritmo DFP (tetha = 0.0 , pho = 1.0)
% Imetqn = 1 --> Algoritmo BFGS(tetha = 1.0 , pho = 1.0)
% Imetqn = 2 --> Adapta��o de Huang
% Imetqn = 3 --> Adapta��o de Biggs
%Imetqn = 0;
if Imetqn==0
    AQN = 'Algoritmo Quase-Newton: DFP';
elseif Imetqn==1
    AQN = 'Algoritmo Quase-Newton: BFGS';
elseif Imetqn==2
    AQN = 'Algoritmo Quase-Newton: Adapta��o Huang';
elseif Imetqn==3
    AQN = 'Algoritmo Quase-Newton: Adapta��o Biggs';
end    

% PRECIS�O:
epslon = 1e-6;

% DEFINI��O DA FUN��O A SER ESTUDADA:
% teste 1 --> fex1(a=0), fexlivro(a=0) e fex3
% teste 2 --> fexlivro
% teste 3 --> fex3
% teste 4 --> fun_rosensuzuki_irr e fex1 (a~=0)
% teste 5 --> f_tiltednormcond
% teste 6 --> fexlivro
%-------------------------------------------------
% icaso = 1 --> fex1
% icaso = 2 --> fexlivro
% icaso = 3 --> fex3
% icaso = 4 --> fun_rosensuzuki_irr
% icaso = 5 --> f_tiltednormcond
icaso = 1;
if icaso==1
    F = 'Fun��o objetivo: fex1';
elseif icaso==2
    F = 'Fun��o objetivo: fexlivro';
elseif icaso==3
    F = 'Fun��o objetivo: fex3';
elseif icaso==4
    F = 'Fun��o objetivo: fun_rosensuzuki_irr';
elseif icaso==5
    F = 'Fun��o objetivo: f_tiltednormcond';
end    

if icaso == 1
    funcao = 'fex1';
    xstar = ones(dim,1);
    fobjstar = fex1(xstar, a);
    dmax = 1;
end

% DEFINI��O DOS LIMITES INF E SUP DE x (Xmax E xMin) E DO PONTO INICIAL x0:
Xmin = - 10 * ones(dim,1);
Xmax = 10 * ones(dim,1);
if dim < 30
	x0 = 8 * ones(dim,1);
else
	x0 = -10 + rand(dim,1)*(10-(-10));
end

%.........................................................................%
% for i1 =1:dim                                                           %
%     Xmin(i1,1) =-1*10.0^dmax;                                           %
%     Xmax(i1,1) = 1*10.0^dmax;                                           %
%     x0(i1,1) = Xmin(i1,1) + rand(1)*(Xmax(i1,1)-Xmin(i1,1));            %
% end                                                                     %
%.........................................................................%

% DEFINI��O DO N�MERO M�XIMO DE ITERA��ES:
MAXITER = 2*dim*100;

% DEFINI��O DA OPERA��O A SER REALIZADA DA SE��O �UREA:
% 0 --> Falsa se��o aurea
% 1 --> Verdadeira se��o aurea
if isa_FV==0
    TEC = 'Aproxima��o quadr�tica de f(x) em cada itera��o';
else
    TEC = 'T�cnica da se��o �urea feita atrav�s da avalia��o direta de f(x)';
end

% RESOLU��O E RESULTADOS:
% funcao --> Fun��o a ser aproximada
% Imetqn --> M�todo quase Newton Escolhido
% MAXITER --> N�mero m�ximo de iterac�es
% x0 --> Ponto inicial
% [Xmin Xmax] --> Limites da fun��o
% epslon --> Precis�o
% Hfobj --> Armazena valor fun��o objetivo
% XK1 --> Armazena as vari�veis
for exe=1:10
    tic
    [XK1,Hfobj,k,kgold,icfunc] = otqnmat_a77(funcao,isa_FV,Imetqn,MAXITER,x0,Xmin,Xmax,epslon,a);
    tempo(exe) = toc;
    %clc
end
tmedio = mean(tempo);
ni = length(Hfobj - 1);
err_per_x = 100*norm(xstar - XK1(:,end))/max(1,norm(xstar));
err_per_fobj = 100*norm(fobjstar - Hfobj(end))/max(1,norm(fobjstar));
disp('----------------------------------------------')
disp(AQN)
disp(F)
fprintf('a = %f\n',a)
fprintf('dim = %d\n',dim)
disp(TEC)
%disp(['Precis�o = ',num2str(epslon)])
fprintf('Ponto inicial = %f\n',x0)
%disp(['Limite inferior = ',num2str(Xmin(1))])
%disp(['Limite superior = ',num2str(Xmax(1))])
%disp(['N�mero m�ximo de itera��es = ',num2str(MAXITER)])
disp(['Tempo de processamento = ',num2str(tmedio)])
disp(['N�mero final de itera��es = ',num2str(ni)])
disp(['N�mero final de avalia��es de fobj = ',num2str(icfunc)])
disp(['Erro percetual xsol = ',num2str(err_per_x)])
disp(['Erro percetual fobj = ',num2str(err_per_fobj)])
disp('----------------------------------------------')

% SALVAR VARI�VEIS PARA GERAR GR�FICOS:
if Imetqn==0 % DFP
    XK1_DFP = XK1;
    Hfobj_DFP = Hfobj;
    save DFP XK1_DFP Hfobj_DFP
elseif Imetqn==1 % BFGS
    XK1_BFGS = XK1;
    Hfobj_BFGS = Hfobj;
    save BFGS XK1_BFGS Hfobj_BFGS
elseif Imetqn==2 % Huang
    XK1_Huang = XK1;
    Hfobj_Huang = Hfobj;
    save Huang XK1_Huang Hfobj_Huang
elseif Imetqn==3 % Biggs
    XK1_Biggs = XK1;
    Hfobj_Biggs = Hfobj;
    save Biggs XK1_Biggs Hfobj_Biggs 
end
end
end