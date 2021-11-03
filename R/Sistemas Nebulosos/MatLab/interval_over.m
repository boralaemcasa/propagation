function r = interval_over(x, y)

		r = Interval;
		r.min = 1e100;
		r.max = -1e100;
		v = interval_split(x);
		w = interval_split(y);
		for i = 1:10
			for j = 1:10
				if w(j) == 0
					z = 0.0;
				else
					z = v(i) / w(j);
				end;
				if z < r.min
					r.min = z;
				end;
				if z > r.max
					r.max = z;
				end;
			end;
		end;
end;
