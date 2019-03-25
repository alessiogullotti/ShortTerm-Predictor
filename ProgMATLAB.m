close all
clear
clc

T = readtable('data.xlsx', 'Range', 'A2:C732');

giornoAnno = T.giorno_anno;
giornoSett = T.giorno_settimana;
dati = T.dati;

giornoAnnoPrimo = giornoAnno(1:365, 1);
giornoSettPrimo = giornoSett(1:365, 1);
datiPrimo = dati(1:365, 1);

giornoAnnoSecondo = giornoAnno(366:730, 1);
giornoSettSecondo = giornoSett(366:730, 1);
datiSecondo = dati(366:730, 1);

scatter(giornoAnnoPrimo, datiPrimo, 'b');
hold on
scatter(giornoAnnoSecondo, datiSecondo, 'r');

ind1 = T.giorno_settimana == 3;
ind2 = T.dati(ind1,:);

%%
pause
close all
scatter(giornoSettPrimo, datiPrimo, 'b');
hold on
scatter(giornoSettSecondo, datiSecondo, 'r', 'Marker', 'x')

%%
pause
close all
plot3(giornoAnnoPrimo, giornoSettPrimo, datiPrimo)
xlabel('giornoAnno');
ylabel('giornoSett');
zlabel('dati');
title('Primo anno');

pause
hold on
plot3(giornoAnnoSecondo, giornoSettSecondo, datiSecondo)
title('completo');




