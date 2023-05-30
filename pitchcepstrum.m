% Funcion para determinar el pitch (F0) con el metodo de coeficientes cepstrales (ejercicio 1 guia 8)
% Recibe una ventana "x" de la señal y la frecuencia de muestreo "fm" que estamos usando, y devuelve
% la frecuencia fundamental o pitch "fpitch".

function [fpitch] = pitchcepstrum(x, fm)
  Tm = 1/fm;    % periodo de muestreo
  
  % Rango de frecuencias posibles
  pmin = 60;   % pitch minimo
  pmax = 400;   % pitch maximo
  
  % Rango de periodos posibles para buscar el pico
  Tmin = 1/pmax;  % periodo minimo (correspondiente al maximo pitch)
  Tmax = 1/pmin;  % periodo maximo (correspondiente al minimo pitch)

  nmin = floor(Tmin/Tm);  % numero de muestras correspondientes al periodo minimo
  nmax = ceil(Tmax/Tm);   % numero de muestras correspondientes al periodo maximo

  % Calculo del cepstrum real
  rceps = real(ifft(log(abs(fft(x)))));
  
  % Busco el max entre los valores de rceps, me interesa el indice
  [val, i] = max(rceps(nmin:nmax));
  
  % Corrijo el numero de muestra npitch porque el rango esta corrido hasta nmin
  npitch = i+nmin-1;    % muestra donde aparece el pico
  
  Tpitch = npitch*Tm;   % periodo fundamental
  
  fpitch = 1/Tpitch;    % frecuencia fundamental
  
endfunction