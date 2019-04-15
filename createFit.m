clc;
clear;
close all;

%Carico i dati all'interno di vettori distinti
data = readtable('data.xlsx','Range','A2:C724');
giorno_anno = table2array(data(: , 1));
giorno_settimana = table2array ( data(: , 2));
misura = table2array(data(: , 3));

dataTab = data {:,:};
mer = dataTab(dataTab(:,2)==3,3); %e' la y
mer(1,:) = []; %tolgo il primo y perche' non ho dati precedentemente
mer(103,:) = []; %tolgo ultima misura per fare previsione tramite OCV   (Ordinary Cross Validation)              
gio = dataTab(dataTab(:,2)==4,3);
gio(103,:) = [];
ven = dataTab(dataTab(:,2)==5,3);
ven(103,:) = [];
sab = dataTab(dataTab(:,2)==6,3);
sab(103,:) = [];
dom = dataTab(dataTab(:,2)==7,3);
dom(103,:) = [];
lun = dataTab(dataTab(:,2)==1,3);
lun(103,:) = [];
mar = dataTab(dataTab(:,2)==2,3);
mar(103,:) = [];

gio1=gio(1:length(gio)/2,1);
gio2=gio(length(gio)/2+1:length(gio),1);

ven1=ven(1:length(ven)/2,1);
ven2=ven(length(ven)/2+1:length(ven),1);

sab1=sab(1:length(sab)/2,1);
sab2=sab(length(sab)/2+1:length(sab),1);

dom1=dom(1:length(dom)/2,1);
dom2=dom(length(dom)/2+1:length(dom),1);

lun1=lun(1:length(lun)/2,1);
lun2=lun(length(lun)/2+1:length(lun),1);

mar1=mar(1:length(mar)/2,1);
mar2=mar(length(mar)/2+1:length(mar),1);

mer1=mer(1:length(mer)/2,1);
mer2=mer(length(mer)/2+1:length(mer),1);

%Visualizzo i consumi in relazione al giorno della settimana
figure(2);
scatter(giorno_settimana,misura,'r','Marker','o'); 
hold on;
scatter(giorno_settimana,misura,'b','Marker','x');
xlabel('Giorno Settimana');
ylabel('Consumi');
title('Consumi Settimana1 vs Settimana2');

%Visualizzo situazione generale
figure(3);
scatter3(giorno_anno,giorno_settimana,misura,'o');
title('Consumi');
xlabel('Giorno Anno');
ylabel('Giorno Settimana');
zlabel('Consumi');

%////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%Un primo approccio e' la stima lineare di ordine 2 LS
% model to fit  z = a0 + a1x + a2y + a3x^2 + a4y^2 + a5xy
figure(4);
phiL2 = [ones(length(gio1),1),gio1,ven1,sab1,dom1,lun1,mar1,gio1.^2,ven1.^2,sab1.^2,dom1.^2,lun1.^2,mar1.^2,gio1.*ven1,gio1.*sab1,gio1.*dom1,gio1.*lun1,gio1.*mar1,ven1.*sab1,ven1.*dom1,ven1.*lun1,ven1.*mar1,sab1.*dom1,sab1.*lun1,sab1.*mar1,dom1.*lun1,dom1.*mar1,lun1.*mar1];
thetaCapL2 = phiL2 \ mer1;
misuraStimataL2 = phiL2 * thetaCapL2;
scartoL2 = mer1 - misuraStimataL2;
SSRL2 = scartoL2' * scartoL2;


phiL2VAL = [ones(length(gio2),1),gio2,ven2,sab2,dom2,lun2,mar2,gio2.^2,ven2.^2,sab2.^2,dom2.^2,lun2.^2,mar2.^2,gio2.*ven2,gio2.*sab2,gio2.*dom2,gio2.*lun2,gio2.*mar2,ven2.*sab2,ven2.*dom2,ven2.*lun2,ven2.*mar2,sab2.*dom2,sab2.*lun2,sab2.*mar2,dom2.*lun2,dom2.*mar2,lun2.*mar2];
misuraStimataL2VAL = phiL2VAL * thetaCapL2;
scartoL2VAL = mer2-misuraStimataL2VAL;
SSRL2VAL = scartoL2VAL' * scartoL2VAL;

%come previsto una lineare di ordine 2 non approssima per niente l'andamento!

%//////////////////////////////////////////////////////////////////////////
%Provo con stima lineare di ordine 3
figure(5);
phiL3 = [phiL2, gio1.^3,ven1.^3,sab1.^3,dom1.^3,lun1.^3,mar1.^3,gio1.^2.*ven1,gio1.^2.*sab1,gio1.^2.*dom1,gio1.^2.*lun1,gio1.^2.*mar1,ven1.^2.*gio1,ven1.^2.*sab1,ven1.^2.*dom1,ven1.^2.*lun1,ven1.^2.*mar1,sab1.^2.*gio1,sab1.^2.*ven1,sab1.^2.*dom1,sab1.^2.*lun1,sab1.^2.*mar1,dom1.^2.*gio1,dom1.^2.*ven1,dom1.^2.*sab1,dom1.^2.*lun1,dom1.^2.*mar1,lun1.^2.*gio1,lun1.^2.*ven1,lun1.^2.*sab1,lun1.^2.*dom1,lun1.^2.*mar1,mar1.^2.*gio1,mar1.^2.*ven1,mar1.^2.*sab1,mar1.^2.*dom1,mar1.^2.*lun1];
thetaCapL3 = phiL3 \ mer1;
misuraStimataL3 = phiL3 * thetaCapL3;
scartoL3 = mer1 - misuraStimataL3;
SSRL3 = scartoL3' * scartoL3;

scatter3(giorno_anno,giorno_settimana,misuraStimataL3,'*');
xlabel('Giorni Anno');
ylabel('Giorni Settimana');
zlabel('Consumi');
title('Lineare di ordine 3');
hold on;

[Xg, Yg] = meshgrid(linspace(min(giorno_anno),max(giorno_anno),30), linspace(min(giorno_settimana),max(giorno_settimana),30));
Xcol = Xg(:);
Ycol = Yg(:);
PhiGridL3 = [ones(size(Xcol)), Xcol,Ycol,Xcol.^2,Ycol.^2,Xcol.*Ycol, Xcol.^3,Ycol.^3,(Xcol.^2).*Ycol,Xcol.*(Ycol.^2)];
YgridL3 = PhiGridL3*thetaCapL3;
surf(Xg,Yg,reshape(YgridL3,size(Xg)));
hold on;
scatter3(giorno_anno,giorno_settimana,misura,'o');

%l'SSR e' diminuito di poco rispetto al 2 ordine

%//////////////////////////////////////////////////////////////////////////
%Provo con stima lineare di ordine 4
figure(6);
phiL4 = [phiL3, giorno_anno.^4,giorno_settimana.^4,(giorno_anno.^3).*giorno_settimana,giorno_anno.*(giorno_settimana.^3),(giorno_anno.^3).*(giorno_settimana.^2),(giorno_anno.^2).*(giorno_settimana.^3)];
thetaCapL4 = phiL4 \ misura;
misuraStimataL4 = phiL4 * thetaCapL4;
scartoL4 = misura - misuraStimataL4;
SSRL4 = scartoL4' * scartoL4;

scatter3(giorno_anno,giorno_settimana,misuraStimataL4,'*');
xlabel('Giorni Anno');
ylabel('Giorni Settimana');
zlabel('Consumi');
title('Lineare di ordine 4');
hold on;

[Xg, Yg] = meshgrid(linspace(min(giorno_anno),max(giorno_anno),30), linspace(min(giorno_settimana),max(giorno_settimana),30));
Xcol = Xg(:);
Ycol = Yg(:);
PhiGridL4 = [ones(size(Xcol)), Xcol,Ycol,Xcol.^2,Ycol.^2,Xcol.*Ycol, Xcol.^3,Ycol.^3,(Xcol.^2).*Ycol,Xcol.*(Ycol.^2),Xcol.^4,Ycol.^4,(Xcol.^3).*Ycol,Xcol.*(Ycol.^3),(Xcol.^3).*(Ycol.^2),(Xcol.^2).*(Ycol.^3)];
YgridL4 = PhiGridL4*thetaCapL4;
surf(Xg,Yg,reshape(YgridL4,size(Xg)));
hold on;
scatter3(giorno_anno,giorno_settimana,misura,'o');

%l'SSR e' diminuito di molto, ma non e' ancora accettabile

%//////////////////////////////////////////////////////////////////////////
%Si nota un'andamento sinusoidale, provo serie di Fourier
%N.B = variare il max di n per variare il grado
figure(7);
w = 2 * pi / 365;
phiFour = ones(size(giorno_anno));
for n = 1:14
    phiFour = [phiFour, cos(n*w.*giorno_anno),sin(n*w.*giorno_anno),cos(n*w.*giorno_settimana),sin(n*w.*giorno_settimana)];
end
thetaCapFour = phiFour \ misura;
misuraStimataFour = phiFour * thetaCapFour;
scartoFour = misura - misuraStimataFour;
SSRFOUR = scartoFour' * scartoFour;


scatter3(giorno_anno,giorno_settimana,misuraStimataFour,'*');
xlabel('Giorni Anno');
ylabel('Giorni Settimana');
zlabel('Consumi');
title('Fourier ordine n');
hold on;

[Xg, Yg] = meshgrid(linspace(min(giorno_anno),max(giorno_anno),30), linspace(min(giorno_settimana),max(giorno_settimana),30));
Xcol = Xg(:);
Ycol = Yg(:);
PhiGridFour = ones(size(Xcol));
for n = 1:14
    PhiGridFour = [PhiGridFour, cos(n*w.*Xcol),sin(n*w.*Xcol),cos(n*w.*Ycol),sin(n*w.*Ycol)];
end
YgridFour = PhiGridFour*thetaCapFour;
surf(Xg,Yg,reshape(YgridFour,size(Xg)));
hold on;
scatter3(giorno_anno,giorno_settimana,misura,'o');


%Si nota che il modello mediante serie di Fourier risulta essere il
%migliore, provo a Crossvalidarlo con i dati del secondo anno
%N.B= adattare l' n massimo con quello in identificazione e togliere meta'
%dati
figure(8);
dataDue = readtable('data.xlsx','Range','A367:C732');
giorno_annoDue = table2array(dataDue(: , 1));
giorno_settimanaDue = table2array( dataDue(: , 2));
misuraDue = table2array(dataDue(: , 3));
for c = 1: 364
    if isnan(misuraDue(c,:)) || isnan(giorno_annoDue(n,:)) || isnan(giorno_settimanaDue(n,:))
        giorno_annoDue(c,:) = [];
        misuraDue(c,:) = [];
        giorno_settimanaDue(c,:) = [];
    end
end

phiFourVal = ones(size(giorno_annoDue));
for n = 1:14
    phiFourVal = [phiFourVal, cos(n*w.*giorno_annoDue),sin(n*w.*giorno_annoDue),cos(n*w.*giorno_settimanaDue),sin(n*w.*giorno_settimanaDue)];
end
misuraStimataFourVal = phiFourVal * thetaCapFour;
scartoFourVal = misuraDue - misuraStimataFourVal;
SSRFOURVAL = scartoFourVal' * scartoFourVal;


scatter3(giorno_annoDue,giorno_settimanaDue,misuraStimataFourVal,'*');
xlabel('Giorni Anno');
ylabel('Giorni Settimana');
zlabel('Consumi');
title('CrossValidazione Fourier ordine n');
hold on;

[Xg, Yg] = meshgrid(linspace(min(giorno_annoDue),max(giorno_annoDue),30), linspace(min(giorno_settimanaDue),max(giorno_settimanaDue),30));
Xcol = Xg(:);
Ycol = Yg(:);
PhiGridFourVal = ones(size(Xcol));
for n = 1:14
    PhiGridFourVal = [PhiGridFourVal, cos(n*w.*Xcol),sin(n*w.*Xcol),cos(n*w.*Ycol),sin(n*w.*Ycol)];
end
YgridFourVal = PhiGridFourVal*thetaCapFour;
surf(Xg,Yg,reshape(YgridFourVal,size(Xg)));
hold on;
scatter3(giorno_anno,giorno_settimana,misura,'o');

%Il risultato e' soddisfacente, lo scarto e' basso

%----------------------------------------------------------------------------------------------------------------------
%Utilizzo una rete neurale con ingresso due input
%Utilizzo un solo layer nascosto, con 20 neuroni
%Utilizzando algoritmo Bayesiano, il grafico di regressione esce
figure(9);
x = [giorno_anno giorno_settimana]';
t = misura';

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

% Getting the ThetaCap
thetaCapNET = getwb(net);

%Getting the number of targets used
nt = length(tr.trainInd);

% Test the Network
y = net(x);
e = gsubtract(t,y);
scartoNET = misura - y';
SSRNET = scartoNET' * scartoNET;
performance = perform(net,t,y);

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y);
valPerformance = perform(net,valTargets,y);
testPerformance = perform(net,testTargets,y);

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
scatter3(giorno_anno,giorno_settimana,misura,'o');


%-------------------------------------------------------
%In ultima analisi provo a creare un modello su stima di Fourier basato
%in ingresso sui dati della settimana e come misura uso il mercoledi

dataTab = data {:,:};
for n = 1: size(dataTab)-1
    if isnan(dataTab(n,3))
        dataTab(n,:) = [];
    end
end
mer = dataTab(dataTab(:,2)==3,3); %e' la y
mer(1,:) = []; %tolgo il primo y perche' non ho dati precedentemente
mer(104,:) = []; %tolgo ultima misura per fare previsione tramite OCV   (Ordinary Cross Validation)              
mer(103,:) = [];
gio = dataTab(dataTab(:,2)==4,3);
gio(104,:) = [];
gio(103,:) = [];
ven = dataTab(dataTab(:,2)==5,3);
ven(104,:) = [];
ven(103,:) = [];
sab = dataTab(dataTab(:,2)==6,3);
sab(104,:) = [];
sab(103,:) = [];
dom = dataTab(dataTab(:,2)==7,3);
dom(104,:) = [];
dom(103,:) = [];
lun = dataTab(dataTab(:,2)==1,3);
lun(104,:) = [];
lun(103,:) = [];
mar = dataTab(dataTab(:,2)==2,3);
mar(104,:) = [];
mar(103,:) = [];

w = 2 * pi / 365;
phiFour2 = ones(size(gio));
for n = 1:12
    phiFour2 = [phiFour2, cos(n*w.*gio),sin(n*w.*gio),cos(n*w.*ven),sin(n*w.*ven),sin(n*w.*gio),cos(n*w.*sab),sin(n*w.*sab),sin(n*w.*gio),cos(n*w.*dom),sin(n*w.*dom),sin(n*w.*gio),cos(n*w.*lun),sin(n*w.*lun),sin(n*w.*gio),cos(n*w.*mar),sin(n*w.*mar)];
end
thetaCapFour2 = phiFour2 \ mer;
misuraStimataFour2 = phiFour2 * thetaCapFour2;
scartoFour2 = mer - misuraStimataFour2;
SSRFOUR2 = scartoFour2' * scartoFour2;


%Per concluder testo i modelli ricavati con le varie tecniche
%TEST FPE
fpeL2 = ((length(misura)+length(thetaCapL2))/(length(misura)-length(thetaCapL2))) * SSRL2;
fpeL3 = ((length(misura)+length(thetaCapL3))/(length(misura)-length(thetaCapL3))) * SSRL3;
fpeL4 = ((length(misura)+length(thetaCapL4))/(length(misura)-length(thetaCapL4))) * SSRL4;
fpeFOUR = ((length(misura)+length(thetaCapFour))/(length(misura)-length(thetaCapFour))) * SSRFOUR;
fpeFOUR2 = ((length(mer)+length(thetaCapFour2))/(length(mer)-length(thetaCapFour2))) * SSRFOUR2;

%TEST AIC
aicL2 = (2*length(thetaCapL2)/length(misura))+log(SSRL2);
aicL3 = (2*length(thetaCapL3)/length(misura))+log(SSRL3);
aicL4 = (2*length(thetaCapL4)/length(misura))+log(SSRL4);
aicFOUR = (2*length(thetaCapFour)/length(misura))+log(SSRFOUR);
aicFOUR2 = (2*length(thetaCapFour2)/length(mer))+log(SSRFOUR2);
aicNET = (2*length(thetaCapNET)/nt)+log(SSRNET);

%Si nota che il modello migliore e' il FOUR2! Facciamo una predizione!

