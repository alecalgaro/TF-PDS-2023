## Funcion para calcular los coeficientes cepstrales en escala de Mel.
## Se ventanea la senal y para cada ventana se aplica:
## -Transformada de Fourier (se realiza en analizar_audio y se lo recibe aca)
## -Banco de filtros triangulares en escala de Mel
## -Logaritmo.
## -Transformada Discreta Coseno.
## -Coeficientes MFCC

function mfcc = calcularMFCC(fftFrames, fs, frameSamples, numFiltros, numCoeficientes)
  % Banco de filtros mel
  filtrosMel = bancoFiltrosMel(fs, frameSamples, numFiltros);

  % Aplicacion del banco de filtros mel a los espectros
  framesFiltrados = filtrosMel * fftFrames(1:frameSamples/2 + 1, :);

  % Calculo de los logaritmos de las energas filtradas
  logEnergias = log(framesFiltrados);

  % Calculo de los coeficientes cepstrales de frecuencia Mel (MFCC)
  matrizDCT = dct(logEnergias);
  mfcc = matrizDCT(1:numCoeficientes, :);
endfunction

% Funcion para armar el banco de filtros
function filtros = bancoFiltrosMel(fs, frameLength, numFiltros)
  % Parametros de frecuencia (en Hz)
  frecuenciaMinima  = 0;
  frecuenciaMaxima  = fs / 2;

  % Convertir las frecuencias minima y maxima a escala mel
  minMel = hz2mel(frecuenciaMinima);
  maxMel = hz2mel(frecuenciaMaxima);

  % Espaciado lineal de puntos mel
  puntosMel = linspace(minMel, maxMel, numFiltros + 2);

  % Convertir los puntos mel a frecuencias en Hz
  puntosFrecuencia = mel2hz(puntosMel);

  % Convertir las frecuencias en Hz a indices de la FFT
  indicesFFT = floor((frameLength + 1) * puntosFrecuencia / fs);

  % Crear los filtros mel
  filtros = zeros(numFiltros, frameLength/2 + 1);
  for i = 2:numFiltros+1
    filtros(i-1, [indicesFFT(i-1):indicesFFT(i)] + 1) = ...
      (indicesFFT(i-1):indicesFFT(i)) - indicesFFT(i-1);
    filtros(i-1, [indicesFFT(i):indicesFFT(i+1)] + 1) = ...
      indicesFFT(i+1) - (indicesFFT(i):indicesFFT(i+1));
  endfor

  % Normalizacion de los filtros
  filtros = filtros ./ max(1e-10, sum(filtros, 2));
endfunction

% Funcion para convertir de Hz a Mel
function mel = hz2mel(frecuencia)
    mel = 2595 * log10(1 + frecuencia / 700);
endfunction

% Funcion para convertir de Mel a Hz
function frecuencia = mel2hz(mel)
    frecuencia = 700 * (10 .^ (mel / 2595) - 1);
endfunction
