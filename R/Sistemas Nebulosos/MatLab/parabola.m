close all; clear all;clc;

Method = 2; % 1 = gp, 2 = sc, 3 = fcm, 4 = nfn
nVariaveis = 1;
a=-2;
b=2;
delta = 4/500;
xt=(a:delta:b)' ;
ydt = xt.^2;
xv = (a:delta/2:b)';
ydv = xv.^2;

if Method == 4;
	xit = -2;
	xft = 2;
	[out_fis,trainError] = anfis_yamakawa(xt, ydt, xit, xft, 20, 11);
	ys=evalfis_yamakawa(out_fis,xt);
else
    if Method == 1;
	   options = genfisOptions('GridPartition', 'NumMembershipFunctions', 5);
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
plot(xv,ydv,xv,ys);
figure
plot(trainError);

% media gp  = 8.5418 %
% media sc  = 0.0554 %
% media fcm = 2.7754 %
% media nfn = 4.0365 % 11 funcoes de pertinencia
