close all;
clc;
clear all


a=1
b=3
m1 = 7
M2 = 11
R = 3
L = 5
emin=-1
emax=1
delta = 0.01
x=(a:delta:b-delta)' ;

det = @(a,b,c,d) (a*d - b*c) ;

u(1)=0;
q1(1)=0;
q2(1)=0;
soma = 0;
alfa = 0.001;

for k =1:length(x)
    % calcular i(k) através da eq. do circuito

    % i = exp(-Rt/L)/L * integral exp(R*t/L) * u dt

    if (k > 1)
        soma = soma + exp(R*x(k)/L) * u(k) * delta
    end

    i(k) = exp(-R*x(k)/L)/L * soma

    const = 1 / fun(b,a,b) * (M2 - m1);
    iref(k) = fun(x(k),a,b) * const + m1;

    % calcular o erro
    e(k) =iref(k) - i(k);

    % calcualar mi1

    if e(k) <= emin
        mi1 = 1
    elseif e(k) >= emax
        mi1 = 0
    else
       % aa * emin + bb = 1
       % aa * emax + bb = 0
        d1 = det(emin, emax, 1, 0)
        d2 = det(1, 0, 1, 1)
        d3 = det(emin, emax, 1, 1)
        aa = d1/d3
        bb = d2/d3
        mi1 = aa * e(k) + bb
    end

    mi2=1-mi1;

    q1(k+1)=q1(k) - alfa*mi1*e(k);
    q2(k+1)=q2(k) - alfa*mi2*e(k);

    if (k < length(x))
        u(k+1) = mi1*q1(k) + mi2*q2(k);
    end

    %u(k) = R * i(k) + L * (fun(x(k)) * const + m1);
end

plot(x,u)
