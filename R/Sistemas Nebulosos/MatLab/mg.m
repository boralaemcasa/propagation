close all; clear all;clc;

Method = 1; % 1 = gp, 2 = sc, 3 = fcm, 4 = nfn
nVariaveis = 4;
load mgdata.dat

xt = zeros(500,4);
ydt = zeros(500,1);
t = 118;
for n = 1:500;
   xt(n,:) = [mgdata(t-18+1, 2) mgdata(t-12+1, 2) mgdata(t-6+1, 2) mgdata(t+1, 2)];
   ydt(n) = mgdata(t+6+1, 2);
   t = t + 1;
end

xv = zeros(500,4);
ydv = zeros(500,1);
for n = 1:500;
   xv(n,:) = [mgdata(t-18+1, 2) mgdata(t-12+1, 2) mgdata(t-6+1, 2) mgdata(t+1, 2)];
   ydv(n) = mgdata(t+6+1, 2);
   t = t + 1;
end

if Method == 4;
	xit = zeros(nVariaveis,1);
	xft = zeros(nVariaveis,1);
	for i = 1:nVariaveis;
	   xit(i) = min(xt(:,i));
	   xft(i) = max(xt(:,i));
	end
	[out_fis,trainError] = anfis_yamakawa(xt, ydt, xit, xft, 20, 5);
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

% media gp  = 0.1727 % 2 funcoes de pertinencia
% media sc  = 0.3020 %
% media fcm = 1.4554 %
% media nfn = 6.2273 %
