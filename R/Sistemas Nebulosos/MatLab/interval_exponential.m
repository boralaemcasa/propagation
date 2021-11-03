function r = interval_exponential(x)

		r = Interval;
		r.min = 1e100;
		r.max = -1e100;
		v = interval_split(x);
		for i = 1:10
		  z = exp(v(i));
			if z < r.min
				r.min = z;
			end;
			if z > r.max
				r.max = z;
			end;
		end;
end;
