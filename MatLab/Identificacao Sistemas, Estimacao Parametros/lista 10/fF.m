function x1=fF(x,u,Phi,Gama,s)
    for i = 1:size(x,2)
        Phi(1,1)  = x(4,i);
        Gama(3,1) = x(5,i); % theta_2
        x1(1:s,i) = Phi * x(1:s,i) + Gama * u;
        for j = 1:s
            x1(j,i) = x1(j,i) + x(s+j,i);
        end
        for j = s+1:size(x,1)
            x1(j,i) = x(j,i);
        end
    end
end