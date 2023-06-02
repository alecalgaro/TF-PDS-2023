## Este algoritmo toma una señal de voz y la frecuencia de muestreo (fs) como entrada. 
## Luego, realiza los siguientes pasos:
##
## 1. Preénfasis de la señal de voz para resaltar las frecuencias de alta energía.
## 2. Divide la señal en segmentos solapados con una duración y superposición especificadas.
## 3. Aplica una ventana de Hamming a cada segmento.
## 4. Calcula la Transformada de Fourier de tiempo corto (STFT) para cada segmento y obtiene los espectros de magnitud.
## 5. Utiliza un banco de filtros mel para aplicar filtros ponderados en escala mel a los espectros.
## 6. Calcula los logaritmos de las energías filtradas.
## 7. Aplica la transformada de coseno discreta (DCT) a los logaritmos de energía filtrados para obtener los coeficientes cepstrales de frecuencia Mel (MFCC).
## 8. Retorna los MFCC calculados.

function mfcc = calcularMFCC(signal, fs)
    % Parámetros MFCC
    frameLength = 0.025; % Duración de cada segmento en segundos
    frameOverlap = 0.01; % Superposición entre segmentos en segundos
    numCoefficients = 13; % Número de coeficientes cepstrales
    
    % Preénfasis de la señal
    preEmphasized = filter([1, -0.97], 1, signal);
    
    % División en segmentos con superposición
    frameSamples = round(frameLength * fs);
    frameOverlapSamples = round(frameOverlap * fs);
    frames = buffer(preEmphasized, frameSamples, frameOverlapSamples, 'nodelay');
    
    % Ventana de Hamming
    window = hamming(frameSamples);
    
    % Cálculo de la FFT para cada segmento
    fftFrames = abs(fft(frames .* window));
    
    % Filtro de banco de filtros mel
    numFilters = 26; % Número de filtros mel
    melFilters = melFilterBank(fs, frameSamples, numFilters);
    
    % Aplicación del banco de filtros mel a los espectros
    filteredFrames = melFilters * fftFrames(1:frameSamples/2 + 1, :);
    
    % Cálculo de los logaritmos de las energías filtradas
    logEnergies = log(filteredFrames);
    
    % Cálculo de los coeficientes cepstrales de frecuencia Mel (MFCC)
    dctMatrix = dct(logEnergies);
    mfcc = dctMatrix(1:numCoefficients, :);
end

function filters = melFilterBank(fs, frameLength, numFilters)
    % Parámetros de frecuencia
    minFrequency = 0; % Frecuencia mínima en Hz
    maxFrequency = fs / 2; % Frecuencia máxima en Hz
    
    % Convertir las frecuencias mínima y máxima a escala mel
    minMel = hz2mel(minFrequency);
    maxMel = hz2mel(maxFrequency);
    
    % Espaciado lineal de puntos mel
    melPoints = linspace(minMel, maxMel, numFilters + 2);
    
    % Convertir los puntos mel a frecuencias en Hz
    frequencyPoints = mel2hz(melPoints);
    
    % Convertir las frecuencias en Hz a índices de la FFT
    fftIndices = floor((frameLength + 1) * frequencyPoints / fs);
    
    % Crear los filtros mel
    filters = zeros(numFilters, frameLength/2 + 1);
    for i = 2:numFilters+1
        filters(i-1, fftIndices(i-1):fftIndices(i)) = ...
            (fftIndices(i-1):fftIndices(i)) - fftIndices(i-1);
        filters(i-1, fftIndices(i):fftIndices(i+1)) = ...
            fftIndices(i+1) - (fftIndices(i):fftIndices(i+1));
    end
    
    % Normalización de los filtros
    filters = filters ./ max(1e-10, sum(filters, 2));
end

function mel = hz2mel(frequency)
    mel = 2595 * log10(1 + frequency / 700);
end

function frequency = mel2hz(mel)
    frequency = 700 * (10 .^ (mel / 2595) - 1);
end
