close all;
clc;
clear all


omega_inverso = 6;
a = 1;
b = 1 + pi * 18;
M2 = 1;
Rx = 3;
Lx = 5;
Ry = 0.3;
Ly = 0.5;
omega = 1;
phi = 1;
emin = -1;
emax = 1;
delta = 0.001;
x=(a:delta:b)' ;
epsilon = 0.000008;


pp = -1/(emax-emin);

u(1) = 0;
ulinha(1) = 0;
q1(1) = 0;
q2(1) = 0;
P = 0;
soma = 0;
somalinha = 0;
temp = 0;
kk = 1;

for k =1:length(x)
    if (x(k) >= 12 * pi) && (kk == k)
      kk = 1;
    end

    R = Rx + Ry * sin(omega * x(kk));
    L = Lx + Ly * sin(phi * x(kk));

    alfa(k) = 0.1;
    if (kk > 1)
        P = P + R/L * delta;

        termo = exp(P)* delta * ulinha(kk)/L;
        somalinha = somalinha + termo;
    end

    termo = exp(-P);
    ilinha(k) = termo * somalinha;

    iref(k) = M2 * (1 - cos((x(kk) - a)/omega_inverso));
    direfdt = M2 * sin((x(kk) - a)/omega_inverso)/omega_inverso;

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

    if mm7 == 0
      res1 = 1000;
    else
      res1 = abs(aa - bb / mm7);
    end
    if mm8 == 0
      res2 = 1000;
    else
      res2 = abs(aa - bb / mm8);
     end
   if mm9 == 0
      res3 = 1000;
    else
      res3 = abs(aa - bb / mm9);
    end
    if mmA == 0
      res4 = 1000;
    else
      res4 = abs(aa - bb / mmA);
    end
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

    % i = exp(-P) * integral exp(P) * u/L dt

    if (kk > 1)
        termo = exp(P)* delta * u(kk)/L/alfa(kk);
        soma = soma + termo;
    end

    termo = exp(-P);
    i(k) = termo * soma;

    % calcular o erro
    e(k) = iref(kk) - i(kk);

    % calcular mi1

    if e(k) <= emin
        mi1 = 1;
    elseif e(k) >= emax
        mi1 = 0;
    else mi1 = pp* e(k) + 0.5;
    end

    mi2 = 1 - mi1;

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


