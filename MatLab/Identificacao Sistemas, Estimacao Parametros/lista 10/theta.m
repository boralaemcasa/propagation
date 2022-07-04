function y=theta(x)
    y = x;
    for i = 1:length(y)
        if y(i) >= 0
            y(i) = 1;
        else
            y(i) = 0;
        end
    end
