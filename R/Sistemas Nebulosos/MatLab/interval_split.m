function r = interval_split(x)

		r = (1:1:10);
		dx = (x.max - x.min) / 10;
		for i = 1:10
		  r(i) = x.min + dx * (i - 1);
		end ;
end;
