close all; clear all;clc;

arq = readtable('flare.csv','Format','auto');

xt = zeros(107,10);
ydt = zeros(107,1);
xv = zeros(1066-107,10);
ydv = zeros(1066-107,1);
i = 1;
j = 1;
for n = 1:1066;
   if mod(n,10) == 1;
      xt(j,:) = arq{n,4:13};
      ch = cell2mat(arq{n,3});
      if ch == 'X';
         ydt(j) = 1;
      elseif ch == 'O';
         ydt(j) = 2;
      elseif ch == 'I';
         ydt(j) = 3;
      else % 'C'
         ydt(j) = 4;
      end
      j = j + 1;
   else
      xv(i,:) = arq{n,4:13};
      ch = cell2mat(arq{n,3});
      if ch == 'X';
         ydv(i) = 1;
      elseif ch == 'O';
         ydv(i) = 2;
      elseif ch == 'I';
         ydv(i) = 3;
      else % 'C'
         ydv(i) = 4;
      end
      i = i + 1;
   end
end

options = genfisOptions('GridPartition', 'NumMembershipFunctions', 2);

%options = genfisOptions('SubtractiveClustering');

%options = genfisOptions('FCMClustering','NumClusters',4);

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

soma = 0;
k = 0;
for i =1:length(ydt);
   if abs(ydt(i)) > 1e-2;
      soma = soma + abs(ydt(i) - ys(i))/abs(ydt(i))*100;
      k = k + 1;
   end
end
media = soma/k

ys=evalfis(out_fis,xv);
index = (1:1:125)';
plot(index,ydv,index,ys);
figure
plot(trainError);

% media gp  =  %
% media sc  =  %
% media fcm =  %
