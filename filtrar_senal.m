% Entradas
% s = senal de entrada
% fm = frecuencia de muestreo
% f_min = frecuencia minima que desea dejar pasar
% f_max = frecuencia maxima que desea dejar pasar

function senal_filtrada = filtrar_senal(s, fm, f_min, f_max)
  TDF_s = fft(s);
  N = length(s);
  df = fm/N;

  # Despejar el numero de muestra de frecuencia minima/ maxima
  idx_f_min = floor(f_min/df);
  idx_f_max = ceil(f_max/df);

  # Filtrar las frecuencias
  TDF_s_filtrado = sparse(zeros(1, N));

  TDF_s_filtrado(idx_f_min + 1: idx_f_max + 1) = ...
           TDF_s(idx_f_min + 1: idx_f_max + 1);

  TDF_s_filtrado(N - idx_f_max: N - idx_f_min) = ...
           TDF_s(N - idx_f_max: N - idx_f_min);

  senal_filtrada = real(ifft(TDF_s_filtrado));

  # Mostrar resultado del filtro
<<<<<<< HEAD
##  figure(10)
##  plot(abs(TDF_s));
##  figure(11)
##  plot(abs(TDF_s_filtrado));
##  figure(12)
##  plot(senal_filtrada)
=======
##  plot(abs(TDF_s));
##  figure
##  plot(abs(TDF_s_filtrado));
>>>>>>> 0b1907891507f1d9bc1934d18bcbb48e007cb111

endfunction

