function r = interval_timesConstant(x, k)
         r = Interval;
         r.min = x.min * k;
         r.max = x.max * k;
end;
