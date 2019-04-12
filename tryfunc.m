close all;

%N.B = Runnare prima main e poi il tryfunc (questo per poter ricavare prima
%i thetaCap)

%La funzione richiede la scrittura in T (array 1x6) delle misure rilevate
%da giovedi' a martedi' ed effettua la predizione sul mercoledi

T = [36.899181671791666 36.160694699500006 35.216059679874995 29.335233257291662 26.830451813166675 32.621158044208336];
%Ho scelto la settimana dal dato 716 al 721 , questi dati non sono stati
%usati per l'identificazione, provare con dati identificati

gio = T(1,1);
ven = T(1,2);
sab = T(1,3);
dom = T(1,4);
lun = T(1,5);
mar = T(1,6);

w = 2 * pi/365;
phiFourPrev = ones(size(gio));
for n = 1:12 %se si alza il valore della serie ricordare di cambiarlo anche nel main
    phiFourPrev = [phiFourPrev, cos(n*w.*gio),sin(n*w.*gio),cos(n*w.*ven),sin(n*w.*ven),sin(n*w.*gio),cos(n*w.*sab),sin(n*w.*sab),sin(n*w.*gio),cos(n*w.*dom),sin(n*w.*dom),sin(n*w.*gio),cos(n*w.*lun),sin(n*w.*lun),sin(n*w.*gio),cos(n*w.*mar),sin(n*w.*mar)];
end

PREVISIONE = phiFourPrev * thetaCapFour2;

%Atteso: 32.2
%Previsione: 33.9