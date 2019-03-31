clc;
close all;
clear all;

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


%Un primo approccio e' la stima tramite LS
% model to fit  y = a0 + a1 x + a2 x^2
figure(3);
giorno_anno_Uno_Formatted = giorno_anno_Uno./365;
phi = [ ones(length(giorno_anno_Uno_Formatted),1),giorno_anno_Uno_Formatted,giorno_anno_Uno_Formatted.^2,]; % least square approximation
thetaCap = phi \ misura_Uno;
MisuraStimata = phi*thetaCap;
%------------------------------------------------------------------------%
% visualize the least square solution
plot(giorno_anno_Uno,MisuraStimata,'r-')
hold on;
scatter(giorno_anno_Uno,misura_Uno,'r','Marker','o');
%come previsto una lineare di ordine 2 non approssima per niente
%l'andamento!

%Inanzitutto i dati forniti sono periodici, dai grafici si nota un certo
%andamento sinusoidale dei consumi.



