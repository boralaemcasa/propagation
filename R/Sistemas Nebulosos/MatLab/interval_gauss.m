function r = interval_gauss(x, c, sigma)
		temp1 = interval_minus(c, x);
		temp1 = interval_over(temp1, sigma);
		temp2 = interval_square(temp1);
		temp1 = interval_timesConstant(temp2, -0.5);
		r = interval_exponential(temp1);
end;
