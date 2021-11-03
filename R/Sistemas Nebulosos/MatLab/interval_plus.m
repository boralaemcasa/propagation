function r = interval_plus(x, y)
         r = Interval;
         r.min = x.min + y.min;
         r.max = x.max + y.max;
end;
