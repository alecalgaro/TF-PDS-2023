%Entradas:
% fm = frecuencia de muestreo
% f_min = frecuencia minima
% f_max = frecuencia maxima
% ventana = ventana del tamano fm + 1

function filtro = filtro_pasa_banda(fm, f_min, f_max, ventana)

  N = fm + 1;     # Longitud del filtro deseado
  M = 10*N;       # Longitud de la respuesta en frecuencia deseada para frecuencia positiva
  Mtot = 2*M + 1; # Frecuencia positiva, negativa y 1 para frecuencia 0.
  df = fm/Mtot;   # Resolucion frecuencial


  # Construccion de la respuesta de magnitud
  MD = zeros(1, M + 1);   # todo 0

  n_min = fix(f_min/df) + 1;  # Calculo a que muestra corresponde la frecuencia f_min
  n_max = fix(f_max/df) + 1;  # Calculo a que muestra corresponde la frecuencia f_max

  MD(n_min : n_max) = 1; # ancho de banda que sobrevive

  # Respuesta de fase: incluye un retardo de (N-1)/2 muestras
  # Toda la mitad desfasada para generar retardo temporal
  ph = exp(-j*2*pi* ((N-1)/2) * [0:M]/Mtot);

  # Respuesta deseada completa
  R = MD .* ph;

  # Parte de frecuencia negativa conjugada
  R = [R, conj(R(end: -1: 2))];

  # Aplicar TF inversa pasando en el dominio termporal
  h = real(ifft(R));

  # Ventaneo las muestras interesadas
  filtro = h(1:N) .* ventana';

endfunction

# Comprobar

##fm = 8000;
##p = 300; q = 3000;
##ventana = boxcar(fm + 1);
##filtro = filtro_pasa_banda(fm, p, q, ventana);
##
##plot(filtro)
##freqz(filtro, 1, 1000, fm)


