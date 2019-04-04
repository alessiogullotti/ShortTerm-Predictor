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


%Un primo approccio e' la stima tramite lineare LS
% model to fit  z = a0 + a1x + a2y + a3x^2 + a4y^2 + a5xy
figure(3);
phi = [ ones(length(giorno_anno_Uno),1),giorno_anno_Uno,giorno_settimana_Uno,giorno_anno_Uno.^2,giorno_settimana_Uno.^2,giorno_anno_Uno.*giorno_settimana_Uno]; % least square approximation
thetaCap = phi \ misura_Uno;
MisuraStimata = phi*thetaCap;
%------------------------------------------------------------------------%
% visualize the least square solution
scatter3(giorno_anno_Uno,giorno_settimana_Uno,MisuraStimata,'*');
xlabel('Giorni Anno');
ylabel('Giorni Settimana');
zlabel('Consumi');
hold on;

[Xg, Yg] = meshgrid(linspace(min(giorno_anno_Uno),max(giorno_anno_Uno),15), linspace(min(giorno_settimana_Uno),max(giorno_settimana_Uno),15));
Xcol = Xg(:);
Ycol = Yg(:);
PhiGrid2 = [ones(size(Xcol)), Xcol,Ycol,Xcol.^2,Ycol.^2,Xcol.*Ycol];
Ygrid2 = PhiGrid2*thetaCap;
surf(Xg,Yg,reshape(Ygrid2,size(Xg)));
hold on;
scatter3(giorno_anno_Uno,giorno_settimana_Uno,misura_Uno,'o');
%come previsto una lineare di ordine 2 non approssima per niente
%l'andamento!


%Provo con un modello non lineare basato sulla stima dei coefficienti di Fourier
figure(4);
%scalo a[-pi,pi]
x1 = min(giorno_anno_Uno);
x2 = max(giorno_settimana_Uno);
x = pi*(2*(giorno_anno_Uno-x1)/(x2-x1) - 1);

y1 = min(giorno_settimana_Uno);
y2 = max(giorno_settimana_Uno);
y = pi*(2*(giorno_settimana_Uno-y1)/(x2-x1)-1);
phiFourier = [ 0.5*ones(length(giorno_anno_Uno),1),cos(giorno_anno_Uno).*cos(giorno_settimana_Uno),cos(giorno_anno_Uno).*sin(giorno_settimana_Uno),sin(giorno_anno_Uno).*cos(giorno_settimana_Uno),sin(giorno_anno_Uno).*sin(giorno_settimana_Uno)];
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
PhiGridFour = [0.5*ones(size(Xcol)),cos(Xcol).*cos(Ycol),cos(Xcol).*sin(Ycol),sin(Xcol).*cos(Ycol),sin(Xcol).*sin(Ycol)];
Ygrid3 = PhiGridFour*thetaFour;
surf(Xg,Yg,reshape(Ygrid3,size(Xg)));
hold on;
scatter3(giorno_anno_Uno,giorno_settimana_Uno,misura_Uno,'o');

%La rappresentazione e' corretta ma non sembra seguire l'andamento dei
%dati, va sistemato


