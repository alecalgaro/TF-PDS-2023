## Este algoritmo toma una se�al de voz y la frecuencia de muestreo (fs) como entrada.
## Luego, realiza los siguientes pasos:
##
## 1. Pre�nfasis de la se�al de voz para resaltar las frecuencias de alta energ�a.
## 2. Divide la se�al en segmentos solapados con una duraci�n y superposici�n especificadas.
## 3. Aplica una ventana de Hamming a cada segmento.
## 4. Calcula la Transformada de Fourier de tiempo corto (STFT) para cada segmento y obtiene los espectros de magnitud.
## 5. Utiliza un banco de filtros mel para aplicar filtros ponderados en escala mel a los espectros.
## 6. Calcula los logaritmos de las energ�as filtradas.
## 7. Aplica la transformada de coseno discreta (DCT) a los logaritmos de energ�a filtrados para obtener los coeficientes cepstrales de frecuencia Mel (MFCC).
## 8. Retorna los MFCC calculados.
##

# Version original


##function mfcc = calcularMFCC(signal, fs)
##    % Par�metros MFCC
##    frameLength = 0.025; % Duraci�n de cada segmento en segundos
##    frameOverlap = 0.01; % Superposici�n entre segmentos en segundos
##    numCoefficients = 13; % N�mero de coeficientes cepstrales
##
##    % Pre�nfasis de la se�al
##    preEmphasized = filter([1, -0.97], 1, signal);
##
##    % Divisi�n en segmentos con superposici�n
##    frameSamples = round(frameLength * fs);
##    frameOverlapSamples = round(frameOverlap * fs);
##    frames = buffer(preEmphasized, frameSamples, frameOverlapSamples, 'nodelay');
##
##    % Ventana de Hamming
##    window = hamming(frameSamples);
##
##    % C�lculo de la FFT para cada segmento
##    fftFrames = abs(fft(frames .* window));
##
##    % Filtro de banco de filtros mel
##    numFilters = 26; % N�mero de filtros mel
##    melFilters = melFilterBank(fs, frameSamples, numFilters);
##
##    % Aplicaci�n del banco de filtros mel a los espectros
##    filteredFrames = melFilters * fftFrames(1:frameSamples/2 + 1, :);
##
##    % C�lculo de los logaritmos de las energ�as filtradas
##    logEnergies = log(filteredFrames);
##
##    % C�lculo de los coeficientes cepstrales de frecuencia Mel (MFCC)
##    dctMatrix = dct(logEnergies);
##    mfcc = dctMatrix(1:numCoefficients, :);
##end
function mfcc = calcularMFCC(fftFrames, fs, frameSamples, numFilters, numCoefficients)

    % Filtro de banco de filtros mel
    melFilters = melFilterBank(fs, frameSamples, numFilters);

    % Aplicaci�n del banco de filtros mel a los espectros
    filteredFrames = melFilters * fftFrames(1:frameSamples/2 + 1, :);

    % C�lculo de los logaritmos de las energ�as filtradas
    logEnergies = log(filteredFrames);

    % C�lculo de los coeficientes cepstrales de frecuencia Mel (MFCC)
    dctMatrix = dct(logEnergies);
    mfcc = dctMatrix(1:numCoefficients, :);
endfunction

function filters = melFilterBank(fs, frameLength, numFilters)
    % Parametros de frecuencia
    minFrequency = 0; % Frecuencia minima en Hz
    maxFrequency = fs / 2; % Frecuencia maxima en Hz

    % Convertir las frecuencias minima y maxima a escala mel
    minMel = hz2mel(minFrequency);
    maxMel = hz2mel(maxFrequency);

    % Espaciado lineal de puntos mel
    melPoints = linspace(minMel, maxMel, numFilters + 2);

    % Convertir los puntos mel a frecuencias en Hz
    frequencyPoints = mel2hz(melPoints);

    % Convertir las frecuencias en Hz a indices de la FFT
    fftIndices = floor((frameLength + 1) * frequencyPoints / fs);

    % Crear los filtros mel
    filters = zeros(numFilters, frameLength/2 + 1);
    for i = 2:numFilters+1
        filters(i-1, [fftIndices(i-1):fftIndices(i)] + 1) = ...
            (fftIndices(i-1):fftIndices(i)) - fftIndices(i-1);
        filters(i-1, [fftIndices(i):fftIndices(i+1)] + 1) = ...
            fftIndices(i+1) - (fftIndices(i):fftIndices(i+1));
    endfor

    % Normalizacion de los filtros
    filters = filters ./ max(1e-10, sum(filters, 2));
endfunction

function mel = hz2mel(frequency)
    mel = 2595 * log10(1 + frequency / 700);
endfunction

function frequency = mel2hz(mel)
    frequency = 700 * (10 .^ (mel / 2595) - 1);
endfunction
