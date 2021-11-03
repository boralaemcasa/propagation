close all; clear all;clc;

Method = 4; % 1 = gp, 2 = sc, 3 = fcm, 4 = nfn
nVariaveis = 3;
xt = zeros(216,3);
n = 1;
for i = 1:6;
    for j = 1:6;
        for k = 1:6;
           xt(n,:) = [i j k];
           n = n + 1;
        end
    end
end
ydt = (1 + xt(:,1).^0.5 + xt(:,2).^-1 + xt(:,3).^-1.5).^2;
xv = zeros(125,3);
n = 1;
for i = 1.5:5.5;
    for j = 1.5:5.5;
        for k = 1.5:5.5;
           xv(n,:) = [i j k];
           n = n + 1;
        end
    end
end
ydv = (1 + xv(:,1).^0.5 + xv(:,2).^-1 + xv(:,3).^-1.5).^2;

if Method == 4;
	xit = zeros(nVariaveis,1);
	xft = zeros(nVariaveis,1);
	for i = 1:nVariaveis;
	   xit(i) = 1;
	   xft(i) = 6;
	end
	[out_fis,trainError] = anfis_yamakawa(xt, ydt, xit, xft, 20, 5);
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
index = (1:1:length(ys))';
plot(index,ydv,index,ys);
figure
plot(trainError);

% media gp  = 0.000070881 %
% media sc  = 1.3196 %
% media fcm = 7.1077 %
% media nfn = 4.0202 %
