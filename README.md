# ShortTerm-Predictor

Il procedimento è predirre i giorni precedenti al mercoledì che si vuole predirre, fino al mercoledì precedente. Costruiti i vari modelli
eseguirne i test dalla slide VALIDAZIONE.

Il file Excel contiene due anni di dati giornalieri, strutturati come segue: 
• 1 colonna: giorno dell’anno [1, ..., 365]; 
• 2 colonna: giorno della settimana [1, ..., 7]; 
• 3 colonna: serie temporale. 
Obiettivo: Identificare un modello per la previsione a breve termine del dato della serie temporale corrispondente al mercoledì, basato sui sette giorni precedenti. Si richiede di scrivere una funzione Matlab che prenda in input un vettore di sette valori (dal mercoledì al martedì) e che restituisca la predizione del giorno successivo. La funzione andrà consegnata al termine del progetto.
