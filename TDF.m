function [S,f] = TDF(s,tm)
  N = length(s);  % cant. de muestras
  fm = 1/tm;  % frecuencia de muestreo
  DF = fm/N;  % delta de la frecuencia

  f = -fm/2 : DF : fm/2-DF;   % dominio frecuencial
  % Calculamos la transformada discreta de Fourier, el abs es para
  % tener la magnitud de los complejos que obtiene fft.
  % La funcion fft solo nos realiza la sumatoria de los prod int.
  S = abs(fft(s));
  % Acomodamos S para que la segunda mitad (parte negativa) pase al principio:
<<<<<<< HEAD
##  S = [S(N/2+1:N) S(1:N/2)];
  S = [S(round(N/2+1):end) S(1:round(N/2))];
endfunction  
=======
  S = [S(round(N/2+1):end) S(1:round(N/2))];
endfunction
>>>>>>> fc0dcc5ae25ab26fa1d989888a790eb2bef77540
