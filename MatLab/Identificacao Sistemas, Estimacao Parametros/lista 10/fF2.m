function x1=fF2(x,s,h,G,m1,m2,t)
    u = 1;
    for i = 1:size(x,2)
        x1(:,i) = x(:,i);
        x1(1:s,i) = x1(1:s,i) + h*dvCord1(x(1:s,i),u,t,G,m1,m2);
end