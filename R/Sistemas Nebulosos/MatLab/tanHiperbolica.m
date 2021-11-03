close all; clear all;clc;

a=-2;
b=2;
delta = 4/500;
xt=(a:delta:b)' ;
ydt = tanh(xt);
a = a + delta/2;
xv = (a:delta:b)';
ydv = tanh(xv);

options = genfisOptions('GridPartition', 'NumMembershipFunctions', 2);
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
plot(xv,ydv,xv,ys);
figure
plot(trainError);

% media = 0.8012