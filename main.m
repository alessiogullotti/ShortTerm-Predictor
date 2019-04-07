clc;
clear;
close all;

%Carico i dati all'interno di vettori distinti
data = readtable('data.xlsx','Range','A2:C732');
giorno_anno = table2array(data(: , 1));
giorno_settimana = table2array ( data(: , 2));
misura = table2array(data(: , 3));

%Spezzo le misure in anno 1 e anno 2
giorno_anno_Uno = giorno_anno(1:365, 1);
giorno_anno_Due = giorno_anno(366:730, 1);

giorno_settimana_Uno = giorno_settimana(1:365, 1);
giorno_settimana_Due = giorno_settimana(366:730, 1);

misura_Uno = misura(1:365, 1);
misura_Due = misura(366:730,1);

%Visualizzo i consumi in relazione al giorno dell'anno
figure(1);
scatter(giorno_anno_Uno,misura_Uno,'r','Marker','o'); 
hold on;
scatter(giorno_anno_Due,misura_Due,'b','Marker','x');
xlabel('Giorno Anno');
ylabel('Consumi');
title('Consumi Anno1 vs Anno2');


%Visualizzo i consumi in relazione al giorno della settimana
figure(2);
scatter(giorno_settimana_Uno,misura_Uno,'r','Marker','o'); 
hold on;
scatter(giorno_settimana_Due,misura_Due,'b','Marker','x');
xlabel('Giorno Settimana');
ylabel('Consumi');
title('Consumi Settimana1 vs Settimana2');

%////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%Un primo approccio e' la stima tramite lineare LS
% model to fit  z = a0 + a1x + a2y + a3x^2 + a4y^2 + a5xy
figure(3);
phi = [ ones(length(giorno_anno_Uno),1),giorno_anno_Uno,giorno_settimana_Uno,giorno_anno_Uno.^2,giorno_settimana_Uno.^2,giorno_anno_Uno.*giorno_settimana_Uno]; % least square approximation
thetaCap = phi \ misura_Uno;
MisuraStimata = phi*thetaCap;

scatter3(giorno_anno_Uno,giorno_settimana_Uno,MisuraStimata,'*');
xlabel('Giorni Anno');
ylabel('Giorni Settimana');
zlabel('Consumi');
hold on;

[Xg, Yg] = meshgrid(linspace(min(giorno_anno_Uno),max(giorno_anno_Uno),15), linspace(min(giorno_settimana_Uno),max(giorno_settimana_Uno),15));
Xcol = Xg(:);
Ycol = Yg(:);
PhiGrid = [ones(size(Xcol)), Xcol,Ycol,Xcol.^2,Ycol.^2,Xcol.*Ycol];
Ygrid = PhiGrid*thetaCap;
surf(Xg,Yg,reshape(Ygrid,size(Xg)));
hold on;
scatter3(giorno_anno_Uno,giorno_settimana_Uno,misura_Uno,'o');
%come previsto una lineare di ordine 2 non approssima per niente l'andamento!


%/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%Provo con un modello non lineare basato sulla stima dei coefficienti di Fourier
figure(4);
x = giorno_anno_Uno;
y = giorno_settimana_Uno;
nx= x*(1:12);
ny= y*(1:12);
phiFourier = [0.5*ones(size(x)),cos(nx).*cos(ny),cos(nx).*sin(ny),sin(nx).*cos(ny),sin(nx).*sin(ny)];
thetaFour = phiFourier \ misura_Uno;
MisuraStimFour = phiFourier*thetaFour;
scatter3(giorno_anno_Uno,giorno_settimana_Uno,MisuraStimFour,'*');
xlabel('Giorni Anno');
ylabel('Giorni Settimana');
zlabel('Consumi');
hold on;

[Xg, Yg] = meshgrid(linspace(min(giorno_anno_Uno),max(giorno_anno_Uno),15), linspace(min(giorno_settimana_Uno),max(giorno_settimana_Uno),15));
Xcol = Xg(:);
Ycol = Yg(:);
nxcol= Xcol*(1:12);
nycol= Ycol*(1:12);
PhiGridFour = [0.5*ones(size(Xcol)),cos(nxcol).*cos(nycol),cos(nxcol).*sin(nycol),sin(nxcol).*cos(nycol),sin(nxcol).*sin(nycol)];
YgridFour = PhiGridFour*thetaFour;
surf(Xg,Yg,reshape(YgridFour,size(Xg)));
hold on;
scatter3(giorno_anno_Uno,giorno_settimana_Uno,misura_Uno,'o');

%La rappresentazione e' corretta, segue abbastanza i dati, va validato.

%----------------------------------------------------------------------------------------------------------------------
%Utilizzo una rete neurale con ingresso due input
%Utilizzo un solo layer nascosto, con 20 neuroni
%Utilizzando algoritmo Bayesiano, il grafico di regressione esce
figure(5);
x = [giorno_anno giorno_settimana]';
t = [misura]';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainbr';  % Bayesian Regularization backpropagation.

% Create a Fitting Network
hiddenLayerSize = 20;
net = fitnet(hiddenLayerSize,trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Choose a Performance Function
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)


scatter3(giorno_anno,giorno_settimana,y,'*');
xlabel('Giorni Anno');
ylabel('Giorni Settimana');
zlabel('Consumi');
hold on;

[Xg, Yg] = meshgrid(linspace(min(giorno_anno),max(giorno_anno),15), linspace(min(giorno_settimana),max(giorno_settimana),15));
Xcol = Xg(:);
Ycol = Yg(:);
surf(Xg,Yg,reshape(y,size(Xg)));
hold on;
scatter3(giorno_anno,giorno_settimana,misura,'o');
