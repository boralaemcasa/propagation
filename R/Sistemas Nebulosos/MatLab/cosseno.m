close all;
clc;
clear all


omega = 6;
a = 1;
b = 1 + pi * 18;
M2 = 1;
R = 3;
L = 5;
emin = -1;
emax = 1;
delta = 0.001;
x=(a:delta:b)' ;
epsilon = 0.000008;


p = -1/(emax-emin);

u(1) = 0;
ulinha(1) = 0;
q1(1) = 0;
q2(1) = 0;
soma = 0;
somalinha = 0;
temp = 0;
kk = 1;

for k =1:length(x)
    if (x(k) >= 12 * pi + 1 - 100*delta) && (kk == k)
      kk = 1;
    end

    alfa(k) = 0.1;
    if (kk > 1)
        termo = exp(R*x(kk)/L)* delta * ulinha(kk);
        somalinha = somalinha + termo;
    end

    termo = exp(-R*x(kk)/L)/L;
    ilinha(k) = termo * somalinha;

    iref(k) = M2 * (1 - cos((x(kk) - a)/omega));
    direfdt = M2 * sin((x(kk) - a)/omega)/omega;

    aa = ilinha(kk);
    bb = iref(kk);

    mm1 = 0;
    mm2 = bb / (aa - epsilon);
    mm3 = bb / (aa + epsilon);
    if (mm1 < mm2) && (mm2 < mm3)
      mm4 = mm1;
      mm5 = mm2;
      mm6 = mm3;
    elseif (mm1 < mm3) && (mm3 < mm2)
      mm4 = mm1;
      mm5 = mm3;
      mm6 = mm2;
    elseif (mm2 < mm1) && (mm1 < mm3)
      mm4 = mm2;
      mm5 = mm1;
      mm6 = mm3;
    elseif (mm2 < mm3) && (mm3 < mm1)
      mm4 = mm2;
      mm5 = mm3;
      mm6 = mm1;
    elseif (mm3 < mm1) && (mm1 < mm2)
      mm4 = mm3;
      mm5 = mm1;
      mm6 = mm2;
    else
      mm4 = mm3;
      mm5 = mm2;
      mm6 = mm1;
    end
    mm7 = mm6 + delta/1000;
    mm8 = (mm5 + mm6)/2;
    mm9 = (mm4 + mm5)/2;
    mmA = mm4 - delta/1000;

    res1 = abs(aa - bb / mm7);
    res2 = abs(aa - bb / mm8);
    res3 = abs(aa - bb / mm9);
    res4 = abs(aa - bb / mmA);
    minimo = res1;
    alfa(k) = mm7;
    if res2 < minimo
      minimo = res2;
      alfa(k) = mm8;
    end
    if res3 < minimo
      minimo = res3;
      alfa(k) = mm9;
    end
    if res4 < minimo
      minimo = res4;
      alfa(k) = mmA;
    end

##    if alfa(k) > 100
##      alfa(k) = 100;
##    end

    % calcular i(k) através da eq. do circuito

    % i = exp(-Rt/L)/L * integral exp(R*t/L) * u dt

    if (kk > 1)
        termo = exp(R*x(kk)/L)* delta * u(kk);
        soma = soma + termo;
    end

    termo = exp(-R*x(kk)/L)/L;
    i(k) = termo * soma;

    % calcular o erro
    e(k) =iref(kk) - i(kk);

    % calcular mi1

    if e(k) <= emin
        mi1 = 1;
    elseif e(k) >= emax
        mi1 = 0;
    else mi1 = p* e(k) + 0.5;
    end

    mi2=1-mi1;

    % resolva em m: - M < A - BM/epsilon < M
    %               BM/epsilon - M < A < BM/epsilon + M
    %               A/~ < M < A/~

    q1(k+1)=q1(kk) + alfa(kk)*mi1*e(kk);
    q2(k+1)=q2(kk) + alfa(kk)*mi2*e(kk);
    q3(k+1)=q1(kk) + mi1*e(kk);
    q4(k+1)=q2(kk) + mi2*e(kk);

    if (kk < length(x))
        u(k+1) = mi1*q1(kk+1) + mi2*q2(kk+1);
        ulinha(k+1) = mi1*q3(kk+1) + mi2*q4(kk+1);
    end

    % u = Ri + L di\dt

     uref(k) = R * iref(kk) + L * direfdt;
    kk = kk + 1;
end

figure
plot(x,e)

figure
plot(x,alfa)


