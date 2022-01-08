function [RETORNO] = RUN3(dim, isa_FV)

a = 0.0263;

for Imetqn = 0:3
% ALGORITMO QUASE NEWTON:
% Imetqn = 0 --> Algoritmo DFP (tetha = 0.0 , pho = 1.0)
% Imetqn = 1 --> Algoritmo BFGS(tetha = 1.0 , pho = 1.0)
% Imetqn = 2 --> Adaptação de Huang
% Imetqn = 3 --> Adaptação de Biggs
%Imetqn = 0;
if Imetqn==0
    AQN = 'Algoritmo Quase-Newton: DFP';
elseif Imetqn==1
    AQN = 'Algoritmo Quase-Newton: BFGS';
elseif Imetqn==2
    AQN = 'Algoritmo Quase-Newton: Adaptação Huang';
elseif Imetqn==3
    AQN = 'Algoritmo Quase-Newton: Adaptação Biggs';
end    

% PRECISÃO:
epslon = 1e-6;

% DEFINIÇÃO DA FUNÇÃO A SER ESTUDADA:
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
    F = 'Função objetivo: fex1';
elseif icaso==2
    F = 'Função objetivo: fexlivro';
elseif icaso==3
    F = 'Função objetivo: fex3';
elseif icaso==4
    F = 'Função objetivo: fun_rosensuzuki_irr';
elseif icaso==5
    F = 'Função objetivo: f_tiltednormcond';
end    

if icaso == 1
    funcao = 'fex1';
    xstar = ones(dim,1);
    fobjstar = fex1(xstar, a);
    dmax = 1;
end

% DEFINIÇÃO DOS LIMITES INF E SUP DE x (Xmax E xMin) E DO PONTO INICIAL x0:
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

% DEFINIÇÃO DO NÚMERO MÁXIMO DE ITERAÇÕES:
MAXITER = 2*dim*100;

% DEFINIÇÃO DA OPERAÇÃO A SER REALIZADA DA SEÇÃO ÁUREA:
% 0 --> Falsa seção aurea
% 1 --> Verdadeira seção aurea
if isa_FV==0
    TEC = 'Aproximação quadrática de f(x) em cada iteração';
else
    TEC = 'Técnica da seção áurea feita através da avaliação direta de f(x)';
end

% RESOLUÇÃO E RESULTADOS:
% funcao --> Função a ser aproximada
% Imetqn --> Método quase Newton Escolhido
% MAXITER --> Número máximo de iteracões
% x0 --> Ponto inicial
% [Xmin Xmax] --> Limites da função
% epslon --> Precisão
% Hfobj --> Armazena valor função objetivo
% XK1 --> Armazena as variáveis
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
%disp(['Precisão = ',num2str(epslon)])
fprintf('Ponto inicial = %f\n',x0)
%disp(['Limite inferior = ',num2str(Xmin(1))])
%disp(['Limite superior = ',num2str(Xmax(1))])
%disp(['Número máximo de iterações = ',num2str(MAXITER)])
disp(['Tempo de processamento = ',num2str(tmedio)])
disp(['Número final de iterações = ',num2str(ni)])
disp(['Número final de avaliações de fobj = ',num2str(icfunc)])
disp(['Erro percetual xsol = ',num2str(err_per_x)])
disp(['Erro percetual fobj = ',num2str(err_per_fobj)])
disp('----------------------------------------------')

% SALVAR VARIÁVEIS PARA GERAR GRÁFICOS:
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