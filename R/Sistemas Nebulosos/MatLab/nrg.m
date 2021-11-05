close all; clear all;clc;

Method = 4; % 1 = gp, 2 = sc, 3 = fcm, 4 = nfn
nVariaveis = 8;
arq = csvread('nrg.csv');

ycol = 9; % 9 or 10
xt = zeros(77,8);
ydt = zeros(77,1);
xv = zeros(768-77,8);
ydv = zeros(768-77,1);
i = 1;
j = 1;
for n = 1:768;
   if mod(n,10) == 1;
      xt(j,:) = arq(n,1:8);
      ydt(j) = arq(n,ycol);
      j = j + 1;
   else
      xv(i,:) = arq(n,1:8);
      ydv(i) = arq(n,ycol);
      i = i + 1;
   end
end

if Method == 4;
	xit = zeros(nVariaveis,1);
	xft = zeros(nVariaveis,1);
	for i = 1:nVariaveis;
	   xit(i) = min(xt(:,i));
	   xft(i) = max(xt(:,i));
	end
	[out_fis,trainError] = anfis_yamakawa(xt, ydt, xit, xft, 20, 7);
	ys=evalfis_yamakawa(out_fis,xt);
else
    if Method == 1;
	   options = genfisOptions('GridPartition', 'NumMembershipFunctions', 2);
    elseif Method == 2;
	   options = genfisOptions('SubtractiveClustering');
    else
	   options = genfisOptions('FCMClustering','NumClusters',4);
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
   if abs(ydt(i)) > 1e-2;
      soma = soma + abs(ydt(i) - ys(i))/abs(ydt(i))*100;
      k = k + 1;
   end
end
media = soma/k

if Method == 4;
   ys=evalfis_yamakawa(out_fis,xv);
else
   ys=evalfis(out_fis,xv);
end
index = (1:1:length(ys))';
plot(index,ydv,index,ys);
figure
plot(trainError);

% media gp  = 0.0131 % 2 funcoes de pertinencia, muito lento
% media sc  = 0.0072 %
% media fcm = 4.3929 %
% media nfn = 7.5070 % 7 funcoes de pertinencia
