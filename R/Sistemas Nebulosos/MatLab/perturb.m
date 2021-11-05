close all;
clc;
clear all


a = 1;
b = 3;
m1 = 0;
M2 = 2;
Rx = 3;
Lx = 5;
Ry = 1;
Ly = 1;
omega = 1;
phi = 1;
emin = -1;
emax = 1;
delta = 0.001;
x=(a:delta:8*b-delta)' ;
epsilon = 0.000000000000008;


pp = -1/(emax-emin);

u(1) = 0;
ulinha(1) = 0;
q1(1) = 0;
q2(1) = 0;
soma = 0;
somalinha = 0;
P = 0;
alfa(1) = 42000;
funfinal = fun(b,a,b);
temp = 0;

for k =1:length(x)

    R = Rx + Ry * sin(omega * x(k));
    L = Lx + Ly * sin(phi * x(k));

    if (k > 1)
        P = P + R/L * delta;

        termo = exp(P)* delta * u(k)/L/alfa(k-1);
        somalinha = somalinha + termo;
    end

    termo = exp(-P);
    ilinha(k) = termo * somalinha;

    const = 1 / funfinal * (M2 - m1);

     if (x(k) <= a)
         temp = 0;
     elseif (x(k) >= b)
         temp = funfinal;
     else
         temp = temp + exp(1./((x(k)-a).*(x(k)-b))) * delta;
     end

    iref(k) = temp * const + m1;

    aa = ilinha(k);
    bb = iref(k);

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

    if abs(aa - bb / mm7) < epsilon
      alfa(k) = mm7;
    elseif abs(aa - bb / mm8) < epsilon
      alfa(k) = mm8;
    elseif abs(aa - bb / mm9) < epsilon
      alfa(k) = mm9;
    elseif abs(aa - bb / mmA) < epsilon
      alfa(k) = mmA;
    else
      alfa(k) = 1;
    end

##    if alfa(k) > 42000
##      alfa(k) = 42000;
##    elseif alfa(k) < 39915
##      alfa(k) = 39915;
##    end

    % calcular i(k) através da eq. do circuito

    % i = exp(-P) * integral exp(P) * u/L dt

    if (k > 1)
        termo = exp(P)* delta * u(k)/L/alfa(k);
        soma = soma + termo * alfa(k);
    end

    termo = exp(-P);
    i(k) = termo * soma;

    % calcular o erro
    e(k) = iref(k) - i(k);

    % calcular mi1

    if e(k) <= emin
        mi1 = 1;
    elseif e(k) >= emax
        mi1 = 0;
    else mi1 = pp* e(k) + 0.5;
    end

    mi2=1-mi1;

    q1(k+1)=q1(k) + alfa(k)*mi1*e(k);
    q2(k+1)=q2(k) + alfa(k)*mi2*e(k);

    if (k < length(x))
        u(k+1) = mi1*q1(k+1) + mi2*q2(k+1);
    end

    % u = Ri + L di\dt

     if (x(k) <= a)
         z = 0;
     elseif (x(k) >= b)
         z = 0;
     else
       z = exp(1./((x(k)-a).*(x(k)-b)));
     end
     uref(k) = R * iref(k) + L * z * const;
end

figure
plot(x,e)

figure
plot(x,alfa)
