function r = interval_minus(x, y)
         oposto = Interval;
         oposto.min = -y.max;
         oposto.max = -y.min;
         r = interval_plus(x, oposto);
end;
