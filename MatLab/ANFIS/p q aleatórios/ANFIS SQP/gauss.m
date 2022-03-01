function r = gauss(x, c, sigma)
    if sigma == 0
        sigma = 1e-3;
    end
    temp1 = c - x;
    temp1 = temp1/sigma;
    temp2 = temp1*temp1;
    temp1 = -0.5 * temp2;
    r = exp(temp1);
end
