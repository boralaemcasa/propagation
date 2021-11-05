load fcmdata.dat
X = fcmdata;
close all
k = 3;
c = k;

%%% K MEANS %%%%
[idxk,K] = kmeans(X,k);
x1 = linspace(0,1,40);
x2 = x1;
[x1G,x2G] = meshgrid(x1,x2);
XGrid = [x1G(:),x2G(:)];
idx2Region = kmeans(XGrid,k,'MaxIter',1,'Start',K);
S = griddata(XGrid(:,1),XGrid(:,2),idx2Region,x1G,x2G);
figure(1)
surf(x1G,x2G,S)
hold on
plot3(X(:,1),X(:,2),k*ones(size(X,1),1),'.k','MarkerSize',20)

%%%% C MEANS %%%%%

K1 = rand(c,size(X,2));
epsilon = 10^-5;
m = 1.5;
[K,~] = fcmeans(X,K1,m,epsilon);
plot_fuzzy(X,K,m)
m = 2;
[K,~] = fcmeans(X,K1,m,epsilon);
plot_fuzzy(X,K,m)
m = 2.5;
[K,~] = fcmeans(X,K1,m,epsilon);
plot_fuzzy(X,K,m)
