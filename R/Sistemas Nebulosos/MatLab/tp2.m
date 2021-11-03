close all;
clc;
clear all


a = 0;
b = 2*pi;
delta = 0.001;
x=(a:delta:b)' ;

for k =1:length(x)
   y(k) = sin(x(k));
   if x(k) < pi/2
      p = 2/pi;
      q = 1;
   elseif x(k) > 3*pi/2
      p = 2/pi;
      q = -3;
   else
      p = -2/pi;
      q = 1;
   end
   z(k) = p * (x(k) - pi/2) + q;
end

figure
plot(x,y, x, z)

