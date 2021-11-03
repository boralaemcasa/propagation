close all; clear all;clc;

Method = 1; % 1 = gp, 2 = sc, 3 = fcm, 4 = nfn
nVariaveis = 5;

size = 5000;
xt = zeros(size,5);
ydt = zeros(size,1);
yhat = zeros(size+3,1);
a = -1;
b = 1;
u = a + (b-a).*rand(size+2,1);
yhat(1) = a + (b-a)*rand;
yhat(2) = a + (b-a)*rand;
yhat(3) = a + (b-a)*rand;
for k = 3:(size+2);
  yhat(k+1) = g(yhat(k), yhat(k-1), yhat(k-2), u(k), u(k-1));
  ydt(k-2) = yhat(k+1);
  xt(k-2,:) = [yhat(k) yhat(k-1) yhat(k-2) u(k) u(k-1)];
end

xv = zeros(size,5);
ydv = zeros(size,1);
yhat = zeros(size+3,1);
u = a + (b-a).*rand(size+2,1);
yhat(1) = a + (b-a)*rand;
yhat(2) = a + (b-a)*rand;
yhat(3) = a + (b-a)*rand;
for k = 3:(size+2);
  yhat(k+1) = g(yhat(k), yhat(k-1), yhat(k-2), u(k), u(k-1));
  ydv(k-2) = yhat(k+1);
  xv(k-2,:) = [yhat(k) yhat(k-1) yhat(k-2) u(k) u(k-1)];
end

if Method == 4;
	xit = zeros(nVariaveis,1);
	xft = zeros(nVariaveis,1);
	for i = 1:nVariaveis;
	   xit(i) = min(xt(:,i));
	   xft(i) = max(xt(:,i));
	end
	[out_fis,trainError] = anfis_yamakawa(xt, ydt, xit, xft, 20, 10);
	ys=evalfis_yamakawa(out_fis,xt);
else
    if Method == 1;
	   options = genfisOptions('GridPartition', 'NumMembershipFunctions', 2);
    elseif Method == 2;
	   options = genfisOptions('SubtractiveClustering');
    else
	   options = genfisOptions('FCMClustering','NumClusters',20);
    end
    
	in_fis = genfis(xt,ydt,options);
	options = anfisOptions;
	options.InitialFIS = in_fis;
	options.EpochNumber = 20;
	
	options.DisplayANFISInformation = 0;
	options.DisplayErrorValues = 0;
	options.DisplayStepSize = 0;
	options.DisplayFinalResults = 0;
	
	[out_fis,trainError] = anfis([xt ydt],options);
	ys=evalfis(out_fis,xt);
end

soma = 0;
k = 0;
for i =1:length(ydt); 
   APE(i) = 0;   
   if abs(ydt(i)) > 1e-2;
      APE(i) = abs(ydt(i) - ys(i))/abs(ydt(i))*100;
      if APE(i) >= 200;
          APE(i) = 0;
      end
      k = k + 1;
   end
   soma = soma + APE(i);
end
media = soma/k
plot(APE);
figure

if Method == 4;
   ys=evalfis_yamakawa(out_fis,xv);
else
   ys=evalfis(out_fis,xv);
end
index = (1:1:length(ys))';
plot(index(1:500),ydv(1:500),index(1:500),ys(1:500));
figure
plot(trainError);

% media gp  =  1.9103 % 2 funcoes de pertinencia
% media sc  =  2.7354 %
% media fcm =  8.2840 % 20 clusters
% media nfn = 13.2751 % 10 funcoes de pertinencia