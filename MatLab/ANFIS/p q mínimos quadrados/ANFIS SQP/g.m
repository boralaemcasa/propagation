function y = g(x1, x2, x3, x4, x5)
   n = x1 * x2 * x3 * x5 * (x3 - 1) + x4;
   d = 1 + x3^2 + x4^2;
   y = n/d;
end