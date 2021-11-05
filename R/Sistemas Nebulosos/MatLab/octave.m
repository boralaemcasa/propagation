% dados de entrada
% inicializacao parametros
% testar modelo com parametros iniciais
%ajustar modelo
% validar modelo
close all;
clear all;
clc

npt=500;
xt=2*6.3*rand(npt,1)-6.3;
ydt=sin(xt);
xv=(-6.3:0.1:6.3)'
ydv=sin(xv);

n=1;
m=5;

alfa=0.1;
nepocas=10;

npv=length(ydv);

xmin=min(xv);
xmax=max(xv);

delta=(xmax-xmin)/(m-1);

for j=1:m
    for i=1:n
        c(i,j)=xmin(i) + (j-1)*delta(i);
        s(i,j)=0.5*delta(i)/(sqrt(2*log(2)));
        p(i,j)=rand;
    end
    q(j)=rand;
end

[ys y w b] = cys(xv,n,m,npv,c,s,p,q);

plot(xv,ydv,xv,ys)

dyjdqj=1;
for epoca=1:nepocas
    for k=1:npt
        [ys y w b] = cys(xt(k,:),n,m,1,c,s,p,q);
        dedys=ys-ydt(k);
        for j=1:m
            dysdwj=(y(j)-ys)/b;
            dysdyj=w(j)/2;

            for i=1:n
                dwjdcij=w(j)*(xt(k,i)-c(i,j)/(s(i,j)^2));
                dwjdsij=w(j)*(xt(k,i)-c(i,j))^2/(s(i,j)^3);
                dyjdpij=xt(k,i);
                c(i,j)=c(i,j) - alfa*dedys*dysdwj*dwjdcij;
                s(i,j)=s(i,j) - alfa*dedys*dysdwj*dwjdsij;
                p(i,j)=p(i,j) - alfa*dedys*dysdyj*dyjdpij;
            end
            q(j)=q(j)-alfa*dedys*dysdyj*dyjdqj;
        end
    end
end

figure
[ys y w b] = cys(xv,n,m,npv,c,s,p,q);

plot(xv,ydv,xv,ys)
