close all;
clc;
clear all


a=-0.1;
b=10.1;
delta = 0.1;
x=(a:delta:b)' ;

for k =1:length(x)
  young(k) = gaussmf(x(k), [20 0]);
  old(k) = gaussmf(x(k), [30 100]);
  veryyoung(k) = young(k) * young(k);
  veryold(k) = old(k) * old(k);
  y(k) = min(1 - veryyoung(k), 1- veryold(k));
  z(k) = min(veryyoung(k), veryold(k));

  a1(k) = trapmf(x(k), [3 4 5 6]);
  a2(k) = trapmf(x(k), [6 6.5 7 7.5]);
  c1(k) = trimf(x(k), [3 4 5]);
  c2(k) = trimf(x(k), [4 5 6]);
  alinha(k) = trimf(x(k), [5 6 7]);
  clinha(k) =  max( min ( max(max( min(trimf(5.5, [5 6 7]), trapmf(5.5, [3 4 5 6])),
                               min(trimf(6.25, [5 6 7]), trapmf(6.25, [3 4 5 6]))),
                               min(trimf(6.75, [5 6 7]), trapmf(6.75, [3 4 5 6]))),
                               c1(k)),
                    min ( max(max( min(trimf(5.5, [5 6 7]), trapmf(5.5, [6 6.5 7 7.5])),
                               min(trimf(6.25, [5 6 7]), trapmf(6.25, [6 6.5 7 7.5]))),
                               min(trimf(6.75, [5 6 7]), trapmf(6.75, [6 6.5 7 7.5]))),
                               c2(k)));
end

#plot(x, young, x, old, x, y, x, z)

plot(x, a1, x, a2)

figure

plot(x, c1, x, c2)

figure

plot(x, alinha)

figure

plot(x, clinha)


