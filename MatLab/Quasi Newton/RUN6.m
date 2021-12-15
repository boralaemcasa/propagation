function [RETORNO] = RUN6(a, isa_FV)
dados = 50;
for aval=1:dados
    for pa=1:4
        % ALGORITMO QUASE NEWTON:
        % 0 --> Algoritmo DFP (tetha = 0.0 , pho = 1.0)
        % 1 --> Algoritmo BFGS(tetha = 1.0 , pho = 1.0)
        % 2 --> Adapta��o de Huang
        % 3 --> Adapta��o de Biggs
        Imetqn = pa-1;
        
        % PRECIS�O:
        epslon = 1e-6;
        
        % DEFINI��O DA FUN��O A SER ESTUDADA:
        funcao = 'fexlivro_ex6';
        
        % DIMENS�O DO ESPA�O DE BUSCA:
        dim = 2;
        
        % --------------------------------------------------------------------%
        % Limite superior do intervalo de busca
        x_sup = [10; 10];
        a_sup = max(roots([36*x_sup(1,1)*x_sup(2,1) 144*x_sup(2,1)+48*x_sup(1,1) 48]));
        % Limite inferior do intervalo de busca
        x_inf = [-10; -10];
        a_inf = min(roots([36*x_inf(1,1)*x_inf(2,1) 144*x_inf(2,1)+48*x_inf(1,1) 48]));
        % --------------------------------------------------------------------%
        
        % OP��ES PARA O VALOR DO PAR�METRO a:
        %a = 0.0263;
        
        %.....................................................................%
        %     Val_a = 0;                                                      %
        %     if Val_a == 0                                                   %
        %         % Defini��o do valor a = 0                                  %
        %         a = (a_sup + a_inf)/2;                                      %
        %     end                                                             %
        %     if Val_a == 1                                                   %
        %         % Defini��o do valor a positivo pr�ximo de zero.            %
        %         a = (a_sup + 0.95*a_inf)/2;                                 %
        %     end                                                             %
        %     if Val_a == -1                                                  %
        %         % Defini��o do valor a negativo pr�ximo de zero.            %
        %         a = (0.95*a_sup + a_inf)/2;                                 %
        %     end                                                             %
        %.....................................................................%
        
        % SOLU��O �TIMA xstar:
        xstar(1,1) = min(roots([0.1875*a^3 3*a^2 (0.25*a^2+14*a) (2*a+4) ((1/12)*a+8/6)])); % -1/3;
        xstar(2,1) = min(roots([0.1875*a^3 a^2 ((4/3)*a+6*a) 4 2])); % -1/2
        
        % FUN��O OBJETIVO DA SOLU��O �TIMA xstar:
        fobjstar = fexlivro(xstar, a);
        
        % --------------------------------------------------------------------%
        % Expoente para definir os limites inferiores e superiores de x
        dmax = 1;
        % --------------------------------------------------------------------%
        
        % DEFINI��O DOS LIMITES INF E SUP DE x (Xmax E xMin) E DO PONTO INICIAL x0:
        x0 = -10 + rand(dim,1)*(10-(-10));
        Xmin = [-10;-10];
        Xmax = [10;10];
        
        % DEFINI��O DO N�MERO M�XIMO DE ITERA��ES:
        MAXITER = 2*dim*100;
        
        % DEFINI��O DA OPERA��O A SER REALIZADA DA SE��O �UREA:
        % 0 --> Falsa se��o aurea
        % 1 --> Verdadeira se��o aurea
        %isa_FV = 0;
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
        tmedio(aval,pa) = mean(tempo);
        ni(aval,pa) = length(Hfobj - 1);
        na(aval,pa) = icfunc;
        err_per_x(aval,pa) = 100*norm(xstar - XK1(:,end))/max(1,norm(xstar));
        err_per_fobj(aval,pa) = 100*norm(fobjstar - Hfobj(end))/max(1,norm(fobjstar));
    end
end

% TEMPO M�DIO:
media_t = mean(tmedio);
mediana_t = median(tmedio);
desvio_t = std(tmedio);
erro_t = std(tmedio)/sqrt(dados);
variancia_t = var(tmedio);
minimo_t = min(tmedio);
maximo_t = max(tmedio);
%figure(1)
%clf
%boxplot(tmedio,{'DFP','BFGS','Huang','Biggs'})
%xlabel('M�todos Quase-Newton')
%ylabel('Tempo de processamento m�dio (s)')

% N�MERO DE ITERA��ES:
media_ni = mean(ni);
mediana_ni = median(ni);
desvio_ni = std(ni);
erro_ni = std(ni)/sqrt(dados);
variancia_ni = var(ni);
minimo_ni = min(ni);
maximo_ni = max(ni);
%figure(2)
%clf
%boxplot(ni,{'DFP','BFGS','Huang','Biggs'})
%xlabel('M�todos Quase-Newton')
%ylabel('N� de Itera��es')

% N�MERO DE AVALIA��ES DE f(x):
media_na = mean(na);
mediana_na = median(na);
desvio_na = std(na);
erro_na = std(na)/sqrt(dados);
variancia_na = var(na);
minimo_na = min(na);
maximo_na = max(na);
%figure(3)
%clf
%boxplot(na,{'DFP','BFGS','Huang','Biggs'})
%xlabel('M�todos Quase-Newton')
%ylabel('N� de Avalia��es de f(x)')

exe = 1:dados;
% ERRO DA SOLU��O:
media_x = mean(err_per_x);
mediana_x = median(err_per_x);
desvio_x = std(err_per_x);
erro_x = std(err_per_x)/sqrt(dados);
variancia_x = var(err_per_x);
minimo_x = min(err_per_x);
maximo_x = max(err_per_x);
%figure(4)
%clf
%plot(exe,err_per_x(:,1),'-*')
%hold on
%plot(exe,err_per_x(:,2),'-o')
%plot(exe,err_per_x(:,3),'-d')
%plot(exe,err_per_x(:,4),'-s')
%legend('DFP','BFGS','Huang','Biggs')
%xlabel('Execu��o')
%ylabel('Erro da Solu��o (%)')

% ERRO DE f(x):
media_fobj = mean(err_per_fobj);
mediana_fobj = median(err_per_fobj);
desvio_fobj = std(err_per_fobj);
erro_fobj = std(err_per_fobj)/sqrt(dados);
variancia_fobj = var(err_per_fobj);
minimo_fobj = min(err_per_fobj);
maximo_fobj = max(err_per_fobj);
%figure(5)
%clf
%plot(exe,err_per_fobj(:,1),'-*')
%hold on
%plot(exe,err_per_fobj(:,2),'-o')
%plot(exe,err_per_fobj(:,3),'-d')
%plot(exe,err_per_fobj(:,4),'-s')
%legend('DFP','BFGS','Huang','Biggs')
%xlabel('Execu��o')
%ylabel('Erro da Fun��o Objetivo (%)')

disp('----------------------------------------------')
disp(TEC)
disp(['a = ',num2str(a)])
disp('----------------------------------------------')
disp('TEMPO DE PROCESSAMENTO:')
disp(['m�dia = ',num2str(media_t)])
disp(['mediana = ',num2str(mediana_t)])
disp(['desvio padr�o = ',num2str(desvio_t)])
disp(['erro padr�o = ',num2str(erro_t)])
disp(['vari�ncia = ',num2str(variancia_t)])
disp(['m�nimo = ',num2str(minimo_t)])
disp(['m�ximo = ',num2str(maximo_t)])
disp('----------------------------------------------')
disp('N� DE ITERA��ES:')
disp(['m�dia = ',num2str(media_ni)])
disp(['mediana = ',num2str(mediana_ni)])
disp(['desvio padr�o = ',num2str(desvio_ni)])
disp(['erro padr�o = ',num2str(erro_ni)])
disp(['vari�ncia = ',num2str(variancia_ni)])
disp(['m�nimo = ',num2str(minimo_ni)])
disp(['m�ximo = ',num2str(maximo_ni)])
disp('----------------------------------------------')
disp('N� DE AVALIA��ES DE f(x):')
disp(['m�dia = ',num2str(media_na)])
disp(['mediana = ',num2str(mediana_na)])
disp(['desvio padr�o = ',num2str(desvio_na)])
disp(['erro padr�o = ',num2str(erro_na)])
disp(['vari�ncia = ',num2str(variancia_na)])
disp(['m�nimo = ',num2str(minimo_na)])
disp(['m�ximo = ',num2str(maximo_na)])
disp('----------------------------------------------')
% disp('ERRO PERCENTUAL DE X:')
% disp(['m�dia = ',num2str(media_x)])
% disp(['mediana = ',num2str(mediana_x)])
% disp(['desvio padr�o = ',num2str(desvio_x)])
% disp(['erro padr�o = ',num2str(erro_x)])
% disp(['vari�ncia = ',num2str(variancia_x)])
% disp(['m�nimo = ',num2str(minimo_x)])
% disp(['m�ximo = ',num2str(maximo_x)])
% disp('----------------------------------------------')
% disp('ERRO PERCENTUAL DE f(x):')
% disp(['m�dia = ',num2str(media_fobj)])
% disp(['mediana = ',num2str(mediana_fobj)])
% disp(['desvio padr�o = ',num2str(desvio_fobj)])
% disp(['erro padr�o = ',num2str(erro_fobj)])
% disp(['vari�ncia = ',num2str(variancia_fobj)])
% disp(['m�nimo = ',num2str(minimo_fobj)])
% disp(['m�ximo = ',num2str(maximo_fobj)])
% disp('----------------------------------------------')
end