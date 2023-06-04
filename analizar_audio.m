function [mfcc] = analizar_audio(nombre_archivo)##function [mfcc] = analizar_audio()  pkg load signal;##---------------------------------------------------------------------------##  CARGA DE SENIALES CON COMANDOS DISPONIBLES EN EL SISTEMA##  (para comparar luego con la senial de entrada)##---------------------------------------------------------------------------##  [y_adelante, fm_adelante] = audioread("dataset-ajustes/adelante_1.wav");##  [y_atras, fm_atras] = audioread("dataset-ajustes/atras_1.wav");##  [y_derecha, fm_derecha] = audioread("dataset-ajustes/derecha_1.wav");##  [y_izquierda, fm_izquierda] = audioread("dataset-ajustes/izquierda_1.wav");##  [y_parar, fm_parar] = audioread("dataset-ajustes/parar_1.wav");##---------------------------------------------------------------------------##  ADQUISICION DE LA SENIAL DE VOZ DE ENTRADA##---------------------------------------------------------------------------  % y: es la senial recibida, fm: es la frecuencia de muestreo    [y, fm] = audioread(nombre_archivo);    ##  [y, fm] = audioread("dataset-ajustes/adelante_2.wav");##  [y2, fm2] = audioread("dataset-ajustes/adelante_2.wav");##  sound(y)  % para escuchar el audio##  sound(y2)##  figure(1)##  plot(y)##  title("Senal 1")##  figure(2)##  plot(y2)##  title("Senal 2")  % Si la senial recibida se encuentra como vector columna, se tranforma a vector fila  if(length(y(1,:)) < length(y(:,1)))    y = y';  endif##---------------------------------------------------------------------------  ## A continuaci�n, primero se realiza un acondicionamiento de la se�al, el cual incluye:  ## -Remocion de la media.  ## -Filtrado para eliminacion de ruido.  ## -Filtrado pre-enfasis.  ## -Ventaneo.  ## -Segmentado de tramas sonoras.  ## Luego de eso se extraen los coeficientes cepstrales es escala de Mel,  ## para posteriormente comparar con los comandos de voz disponibles en el sistema  ## utilizando la tecnica DTW y verificar cual es el comando de voz mas parecido  ## a la senal de entrada, y si se supera cierto umbral de similitud, se indica  ## cual es el comando a ejecutar.##---------------------------------------------------------------------------##---------------------------------------------------------------------------##  REMOCION DE LA MEDIA (QUITAR COMPONENTE CONTINUA)##---------------------------------------------------------------------------  ## La componente continua es una desviacion general de la senial, positiva o  ## negativa debido principalmente a microfonos de mala calidad o a campos magneticos  ## presentes. Esto afecta de forma critica en etapas posteriores del procesado.  ## La componente continua se elimina restando la media de la senial a cada  ## una de las muestras.  y = y - mean(y);##---------------------------------------------------------------------------##  FILTRADO PARA ELIMINACION DE RUIDO##---------------------------------------------------------------------------  ## Es posible que en la senial se hayan introducido componentes de baja  ## frecuencia procedentes de distintas fuentes. Estas componentes no son de  ## interes para el estudio de la senal de voz y por ello es mejor eliminarlas. La  ## frecuencia de corte se ha establecido en 75 Hz que es la minima a la que se  ## encuentra la frecuencia fundamental (pitch) para la voz masculina  f_min = 75;  f_max = 3000;   % filtrando hasta menos de 3000 la voz en nuestro caso se distorsiona.                  % si la senal tiene fm = 8000 Hz, la f maxima es de 4000, asi                  % que estaria eliminando la parte de 0 a 74 y 3001 a 4000 Hz  printf("Senal original\n");  sound(y);  senal_filtrada = filtrar_senal(y, fm, f_min, f_max);  printf("Senal normalizado \n");  sound(senal_filtrada);##---------------------------------------------------------------------------##  FILTRADO PRE-ENFASIS##---------------------------------------------------------------------------
  % Pre-enfasis de la senal  senal_pre_enfasis = filter([1, -0.97], 1, senal_filtrada);  printf("Senal pre-enfasis \n");  sound(senal_pre_enfasis);##---------------------------------------------------------------------------##  NORMALIZAR SENAL##---------------------------------------------------------------------------  senal_pre_enfasis = 0.5 * senal_pre_enfasis./ max(senal_pre_enfasis);  printf("Senal normalizado \n");  sound(senal_pre_enfasis);##---------------------------------------------------------------------------##  VENTANEO##---------------------------------------------------------------------------##  La funcion buffer ya hace el paso de ventaneo :D  ## En intervalos cortos de tiempo la se?al se estabiliza y se aproxima a una se?al estacionaria,  ## entonces es necesario dividir utilizando ventanas, donde la mas utilizada es la ventana de Hamming.  ## Cuanto mas rapido se pronuncie, sera necesario un menor tama?o de ventana, pero suelen utilizarse  ## entre 10 y 30 ms.  ## Otro tema es tratar de superponer las ventanas (overlap), a mayor velocidad, mayor tiene que ser el overlap.  % Parametros de ventaneo  duracion_ventana = 0.025; % Duracion de cada segmento en segundos  superposicion_ventana = 0.01; % Superposicion entre segmentos en segundos  # Extraer las cantidad de muestras de cada elemento  muestra_ventana = round(duracion_ventana * fm);  muestra_superposicion = round(superposicion_ventana * fm);  % Ventana de Hamming  ventana = hamming(muestra_ventana);  # Extraer cada tramo  tramos = buffer(senal_pre_enfasis, muestra_ventana, muestra_superposicion, 'nodelay');  % Ventaneo  ventaneo = tramos .* ventana;##---------------------------------------------------------------------------##  STFT, TDF DE TIEMPO CORTO##---------------------------------------------------------------------------  stft_senal = abs(fft(ventaneo));##---------------------------------------------------------------------------##  DETECCION DE TRAMAS SONORAS##---------------------------------------------------------------------------  ## Las tramas que contienen la informacion mas relevante para la caracterizacion son  ## las llamadas sonoras. Por ese motivo es necesario establecer unos criterios que  ## permitan aislar este tipo de tramas y desechar las pertenecientes a silencios o a sonidos sordos.  ## Para este fin existen tres metodos, el calculo de la energia, la tasa de cruces  ## por cero (ZCR), y el calculo del pitch. En este caso, utilizaremos el calculo de la energia.  ## Es necesario definir un umbral de energia para discernir si un determinado  ## coeficiente de energia pertenece o no a una trama sonora. Para dar  ## estabilidad al calculo del parametro, ademas de eliminar la componente  ## continua de la se�al, tambi�n se puede normalizar entre 1 y -1.  ## Tenemos la funcion "energia" que podriamos ir aplicando a cada ventana,  ## y si supera un umbral la consideramos como sonora y sino como sorda y la descatamos  ## o la cambiamos por todos ceros para que la senal siga con el mismo tamanio.##  umbral_energia = valor;   % tendriamos que probar varias veces para ver que resultados##                            % nos da y luego definimos este valor de umbral##  for i = 1:length(vector_ventanas)##    if(energia(vector_ventanas(i) > umbral_energia))##      %...##    endif##  endfor##---------------------------------------------------------------------------##  EXTRACCION DE CARACTERISTICAS (Coeficientes cepstrales en escala de Mel)##---------------------------------------------------------------------------  # Definir el numero del filter-bank, por lo general entre 20-40  num_filter = 26;  # Definir cantidad de coeficientes interesados  num_coef = 13;  mfcc = calcularMFCC(stft_senal, fm, muestra_ventana, num_filter, num_coef);  % Guardar MFCC obtenidos para los comandos de referencia##  save data_parar.txt mfcc;  ## Al final de la pag. 13 del word de anotaciones de teoria y en otros archivos se habla de los MFCC,  ## y se explica los pasos para calcularlos (pre-enfasis, ventaneo, Fourier, banco de filtros,  ## logaritmo, transformada coseno, liftrado) y se muestra una imagen.  ## Se calculan en cada ventana.  ##  Para cada ventana deberiamos hacer:    ## -Transformada de Fourier    ## -Banco de filtros triangulares en escala de Mel    ## -Logaritmo.    ## -Transformada Discreta Coseno.    ## -Coeficientes MFCC##---------------------------------------------------------------------------##  CORRELACION CRUZADA##---------------------------------------------------------------------------  ##  QUIZAS NO ES NECESARIO, LO VEMOS DESPUES.  ## r = xcorr(x,y) devuelve la correlacion cruzada de dos secuencias de tiempo diferenciado.  ## La correlacion cruzada mide la similitud entre un vector "x" y las copias desplazadas (desfasadas)  ## de un vector "y" como funcion del desfase. Si "x" e "y" tienen longitudes diferentes,  ## la funcion agrega ceros al final del vector mas corto para que tenga la misma longitud que el otro.  ## Se deberia hacer la correlacion cruzada entre la senial de entrada y las cinco  ## seniales de comandos disponibles en el sistema.  ## Tambien debemos usar la tecnica dynamic time warping (DWT) para hacer un ajuste entre las seniales  ## que nos permita realizar la comparaciin, porque pueden ser de distinta duracion y entonces no usan  ## la misma cantidad de ventanas.endfunction