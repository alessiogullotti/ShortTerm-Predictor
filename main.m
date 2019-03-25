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

%Visualizzo la temperatura in relazione al giorno dell'anno
figure(1);
scatter(giorno_anno_Uno,misura_Uno,'r','Marker','o'); 
hold on;
scatter(giorno_anno_Due,misura_Due,'b','Marker','x');
xlabel('Giorno Anno');
ylabel('Consumi');
title('Consumi Anno1 vs Anno2');

%Visualizzo la temperatura in relazione al giorno della settimana
figure(2);
scatter(giorno_settimana_Uno,misura_Uno,'r','Marker','o'); 
hold on;
scatter(giorno_settimana_Due,misura_Due,'b','Marker','x');
xlabel('Giorno Settimana');
ylabel('Consumi');
title('Consumi Settimana1 vs Settimana2');


%Controllo occorrenz
figure(3);
pd = makedist ('Normal', 0 , 1);
histogram(misura,70,'Normalization','pdf');










