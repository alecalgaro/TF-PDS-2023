function [] = analizar_audio(nombre_archivo)pkg load signal;clc; clear all; close all;##---------------------------------------------------------------------------##  CARGA DE SENIALES CON COMANDOS DISPONIBLES EN EL SISTEMA##  (para comparar luego con la senial de entrada)##---------------------------------------------------------------------------##  [y_adelante, fm_adelante] = audioread("dataset-ajustes/adelante.wav");##  [y_atras, fm_atras] = audioread("dataset-ajustes/atras.wav");##  [y_derecha, fm_derecha] = audioread("dataset-ajustes/derecha.wav");##  [y_izquierda, fm_izquierda] = audioread("dataset-ajustes/izquierda.wav");##  [y_parar, fm_parar] = audioread("dataset-ajustes/parar.wav");##---------------------------------------------------------------------------##  LECTURA DE LA SENIAL DE VOZ DE ENTRADA##---------------------------------------------------------------------------  % y: es la senial recibida, fm: es la frecuencia de muestreo  % [y, fm] = audioread(nombre_archivo);  [y, fm] = audioread("dataset-ajustes/adelante_2.wav");  [y2, fm2] = audioread("dataset-ajustes/adelante_1.wav");##  [y, fm] = wavread(archivo);   otra opcion que se puede probar ##  yo = y; % y original para graficar si nos sirve##  fm  figure(1)  plot(y)  title("Se�al 1")  figure(2)  plot(y2)  title("Se�al 2")  % Si la senial recibida se encuentra como vector columna, se tranforma a vector fila  if(length(y(1,:)) < length(y(:,1)))    y = y';  endif  % Para probar que da la correlacion cruzada  correlacion_cruzada = xcorr(y, y2);  max_correlacion_cruzada = max(correlacion_cruzada)     figure(3)  plot(correlacion_cruzada)  title("Correlacion cruzada")    sound(y)  % para escuchar el audio  sound(y2)  ##  [S,f] = TDF(y,1/fm);##  figure(2)##  plot(S)##---------------------------------------------------------------------------##  REMOCION DE LA MEDIA (QUITAR COMPONENTE CONTINUA)##---------------------------------------------------------------------------  ## La componente continua es una desviacion general de la senial, positiva o  ## negativa debido principalmente a microfonos de mala calidad o a campos magneticos  ## presentes. Esto afecta de forma critica en etapas posteriores del procesado.  ## La componente continua se elimina restando la media de la senial a cada  ## una de las muestras.    y = y - mean(y);##---------------------------------------------------------------------------##  FILTRADO PARA ELIMINACION DE RUIDO##---------------------------------------------------------------------------  ## Es posible que en la senial se hayan introducido componentes de baja  ## frecuencia procedentes de distintas fuentes. Estas componentes no son de  ## interes para el estudio de la se�al de voz y por ello es mejor eliminarlas. La  ## frecuencia de corte se ha establecido en 75 Hz que es la m�nima a la que se  ## encuentra la frecuencia fundamental (pitch) para la voz masculina  % Periodo de muestreo  Tm = 1/fm;  % Vector de tiempos  t = 0 : Tm : (length(y)*Tm)-Tm;    % Con la funcion TDF calcula la transformada de Fourier y acomoda el rango de frecuencias.  [Y_sin_filtro, f] = TDF(y, Tm);    figure(4)  plot(Y_sin_filtro)    % Filtro pasa-banda  Filtro = (abs(f) >= 75 & abs(f) <= 400);  % unos en esa banda de 75 a 400 Hz y ceros en el resto  Y = Y_sin_filtro .* Filtro;  figure(5)  plot(Y)  ##  ---------- de Chen ----------##  # Propongo filtro de pasa-banda, dejando pasar [300 - 3000Hz]##  b = filtro_pasa_banda(fm, 300, 3000, hamming(fm + 1));####  # ======================[Analicis mediante grafica]=====================##  # Se puede borrar despues, nada mas es para ver las cosas####  # Filtro pasa-banda [300 - 3000Hz]##  [h, w] = freqz(b, 1, 1000, fm);##  subplot(2, 1, 1)##  plot(w, abs(h));####  # Sonido filtrado##  y_filtrado = filter(b, 1, y);##  subplot(2, 1, 2)##  plot(y_filtrado);##  sound(y_filtrado);####  # TDF de la senal original##  figure##  subplot(2, 1, 1)##  [s, f] = TDF(y, 1/fm);##  plot(f, s);####  # TDF de senal filtrado##  subplot(2, 1, 2)##  [s, f] = TDF(y_filtrado, 1/fm);##  plot(f, s);## ---------- ----------##---------------------------------------------------------------------------##  FILTRADO PRE-ENFASIS##---------------------------------------------------------------------------  ## Filtrado de primer orden donde se realza o enfatizan las altas frecuencias    a = 0.97;  for n = 1:length(y)    if(n-1 > 0)      y(n) = y(n) - a*y(n-1);    endif  endfor
##---------------------------------------------------------------------------##  VENTANEO##---------------------------------------------------------------------------  ## En intervalos cortos de tiempo la se?al se estabiliza y se aproxima a una se?al estacionaria,  ## entonces es necesario dividir utilizando ventanas, donde la mas utilizada es la ventana de Hamming.  ## Cuanto mas rapido se pronuncie, sera necesario un menor tama?o de ventana, pero suelen utilizarse  ## entre 10 y 30 ms.  ## Otro tema es tratar de superponer las ventanas (overlap), a mayor velocidad, mayor tiene que ser el overlap.  tvent = 0.03;   % ancho de la ventana de an?lisis en segundos (30 ms)  %overlap = 0.4;    % 40%, cantidad de solapamiento entre ventanas de an?lisis, 0 solapamiento total, 1 no hay solapamiento  tstep = 0.01;  % avance de la ventana (10 ms)  % Transformo esos tiempos en muestras  nvent = tvent * fm;  nstep = tstep * fm;  # Comento no mas, existe funcion hamming(N) donde N es la cantidad de elementos que  # deseas en esta ventana. Hay que prestar atencion porque la funcion devuelve  # un vector vertical. Por lo que veo, estas haciendo una ventana con un tamano  # de la senal original.##  % Ventana##  w = vhamming(t);##  y_ventaneada = w*y;   % VER COMO SERIA (ver en ej. 1 guia 8)  # En el ejercicio propuso iniciar en la mitad de la ventana, osea ini = nvent/2  # Luego termina una ventana antes de la final.  # Las explicaciones se encuentra en el video 2 de Guia 8 minuto 48:50.  ini = nvent/2;  nframes = floor((length(y) - nvent*0.5 - nvent - nstep)/nstep);  # Ventanear las senales  for i = 1: nframes    # Ventanear una parte de la senal. Por su puesto que falta algo    ...y(ini: ini + nvent - 1) .* hamming(nvent)';  endfor##---------------------------------------------------------------------------##  EXTRACCION DE CARACTERISTICAS (Coeficientes cepstrales en escala de Mel)##---------------------------------------------------------------------------  ## Al final de la pag. 13 del word de anotaciones de teoria se habla de estos MFCC,  ## y se explica los pasos para calcularlos (pre-enfasis, ventaneo, Fourier, banco de filtros,  ## logaritmo, transformada coseno, liftrado) y se muestra una imagen.  ## Se calculan en cada ventana.  ## Ver si debemos usar esos mismos pasos.  ##  cr = real(ifft(log(abs(fft(y))))); % cepstrum##---------------------------------------------------------------------------##  CORRELACION CRUZADA##---------------------------------------------------------------------------  ## r = xcorr(x,y) devuelve la correlacion cruzada de dos secuencias de tiempo diferenciado.  ## La correlacion cruzada mide la similitud entre un vector "x" y las copias desplazadas (desfasadas)  ## de un vector "y" como funcion del desfase. Si "x" e "y" tienen longitudes diferentes,  ## la funcion agrega ceros al final del vector mas corto para que tenga la misma longitud que el otro.  ## Se deberia hacer la correlacion cruzada entre la senial de entrada y las cinco  ## seniales de comandos disponibles en el sistema.  ## Tambien debemos usar la tecnica dynamic time warping (DWT) para hacer un ajuste entre las seniales  ## que nos permita realizar la comparaciin, porque pueden ser de distinta duracion y entonces no usan  ## la misma cantidad de ventanas.##---------------------------------------------------------------------------##  IDENTIFICACION DE COMANDO##---------------------------------------------------------------------------  ## La senial con mayor correlacion sera la de mayor similitud con la senial de entrada,  ## determinando asi cual es el comando que el usuario desea ejecutar##---------------------------------------------------------------------------##  RESULTADO##---------------------------------------------------------------------------  ## Mostrar si la senial de entrada fue un comando valido o noendfunction
=======
function [] = analizar_audio(nombre_archivo)pkg load signal;##---------------------------------------------------------------------------##  CARGA DE SE�ALES CON COMANDOS DISPONIBLES EN EL SISTEMA##  (para comparar luego con la se�al de entrada)##---------------------------------------------------------------------------##  [y_adelante, fm_adelante] = audioread("dataset-ajustes/adelante.wav");##  [y_atras, fm_atras] = audioread("dataset-ajustes/atras.wav");##  [y_derecha, fm_derecha] = audioread("dataset-ajustes/derecha.wav");##  [y_izquierda, fm_izquierda] = audioread("dataset-ajustes/izquierda.wav");##  [y_parar, fm_parar] = audioread("dataset-ajustes/parar.wav");##---------------------------------------------------------------------------##  LECTURA DE LA SE�AL DE VOZ DE ENTRADA##---------------------------------------------------------------------------  % y: es la se�al recibida, fm: es la frecuencia de muestreo  % [y, fm] = audioread(nombre_archivo);  [y, fm] = audioread("dataset-ajustes/atras_1.wav");##  [y, fm] = wavread(archivo);   otra opcion que se puede probar##  yo = y; % y original para graficar si nos sirve##  fm  % Si la se�al recibida se encuentra como vector columna, se tranforma a vector fila  if(length(y(1,:)) < length(y(:,1)))    y = y';  endif  sound(y)  % para escuchar el audio  # Le asigno el unico canal por las dudas (PUEDE QUE SEA POR COMO QUEDA EL AUDIO LUEGO DE AUDACITY)  y = y(1, :); # Pasar a dimension (1, 5197)# Me llamo atencion porque la dimension de y es (5197, 2)##  sound(sum(y, 2))  % para escuchar el audio##  sound(y(1, :))  % para escuchar el audio# Para probar que da la correlacion cruzadacorrelacion_cruzada = xcorr(y, y2);max_correlacion_cruzada = max(correlacion_cruzada);##  plot(y(1, :));##  hold on##  plot(y(2, :));##  [S,f] = TDF(y,1/fm);##  figure(2)##  plot(S)##---------------------------------------------------------------------------##  REMOCION DE LA MEDIA (QUITAR COMPONENTE CONTINUA)##---------------------------------------------------------------------------  ## La componente continua es una desviaci�n general de la se�al, positiva o  ## negativa debido principalmente a micr�fonos de mala calidad o a campos magn�ticos  ## presentes. Esto afecta de forma cr�tica en etapas posteriores del procesado.  ## La componente continua se elimina restando la media de la se�al a cada  ## una de las muestras.  y = y - mean(y);##---------------------------------------------------------------------------##  FILTRADO PARA ELIMINACION DE RUIDO##---------------------------------------------------------------------------  ## Es posible que en la se�al se hayan introducido componentes de baja  ## frecuencia procedentes de distintas fuentes. Estas componentes no son de  ## inter�s para el estudio de la se�al de voz y por ello es mejor eliminarlas. La  ## frecuencia de corte se ha establecido en 75 Hz que es la m�nima a la que se  ## encuentra la frecuencia fundamental (pitch) para la voz masculina  % Periodo de muestreo  Tm = 1/fm;  % Vector de tiempos  t = 0 : Tm : (length(y)*Tm)-Tm;  % Con la funcion TDF calcula la transformada de Fourier y acomoda el rango de frecuencias.  [Y_sin_filtro, f] = TDF(y, Tm);  % Filtro pasa-banda  Filtro = (abs(f) >= 75 & abs(f) <= 400);  % unos en esa banda de 75 a 400 Hz y ceros en el resto  Y = Y_sin_filtro .* Filtro;##  ---------- de Chen ----------##  # Propongo filtro de pasa-banda, dejando pasar [300 - 3000Hz]##  b = filtro_pasa_banda(fm, 300, 3000, hamming(fm + 1));####  # ======================[Analicis mediante grafica]=====================##  # Se puede borrar despues, nada mas es para ver las cosas####  # Filtro pasa-banda [300 - 3000Hz]##  [h, w] = freqz(b, 1, 1000, fm);##  subplot(2, 1, 1)##  plot(w, abs(h));####  # Sonido filtrado##  y_filtrado = filter(b, 1, y);##  subplot(2, 1, 2)##  plot(y_filtrado);##  sound(y_filtrado);####  # TDF de la senal original##  figure##  subplot(2, 1, 1)##  [s, f] = TDF(y, 1/fm);##  plot(f, s);####  # TDF de senal filtrado##  subplot(2, 1, 2)##  [s, f] = TDF(y_filtrado, 1/fm);##  plot(f, s);## ---------- ----------##---------------------------------------------------------------------------##  FILTRADO PRE-ENFASIS##---------------------------------------------------------------------------  ## Filtrado de primer orden donde se realza o enfatizan las altas frecuencias  a = 0.97;  for n = 1:length(y)    if(n-1 > 0)      y(n) = y(n) - a*y(n-1);    endif  endfor
##---------------------------------------------------------------------------##  VENTANEO##---------------------------------------------------------------------------  ## En intervalos cortos de tiempo la se�al se estabiliza y se aproxima a una se�al estacionaria,  ## entonces es necesario dividir utilizando ventanas, donde la mas utilizada es la ventana de Hamming.  ## Cuanto mas rapido se pronuncie, sera necesario un menor tama�o de ventana, pero suelen utilizarse  ## entre 10 y 30 ms.  ## Otro tema es tratar de superponer las ventanas (overlap), a mayor velocidad, mayor tiene que ser el overlap.  tvent = 0.03;   % ancho de la ventana de an�lisis en segundos (30 ms)  %overlap = 0.4;    % 40%, cantidad de solapamiento entre ventanas de an�lisis, 0 solapamiento total, 1 no hay solapamiento  tstep = 0.01;  % avance de la ventana (10 ms)  % Transformo esos tiempos en muestras  nvent = tvent * fm;  nstep = tstep * fm;  # Comento no mas, existe funcion hamming(N) donde N es la cantidad de elementos que  # deseas en esta ventana. Hay que prestar atencion porque la funcion devuelve  # un vector vertical. Por lo que veo, estas haciendo una ventana con un tamano  # de la senal original.##  % Ventana##  w = vhamming(t);##  y_ventaneada = w*y;   % VER COMO SERIA (ver en ej. 1 guia 8)  # En el ejercicio propuso iniciar en la mitad de la ventana, osea ini = nvent/2  # Luego termina una ventana antes de la final.  # Las explicaciones se encuentra en el video 2 de Guia 8 minuto 48:50.  ini = nvent/2;  nframes = floor((length(y) - nvent*0.5 - nvent - nstep)/nstep);  # Ventanear las senales  for i = 1: nframes    # Ventanear una parte de la senal. Por su puesto que falta algo    ...y(ini: ini + nvent - 1) .* hamming(nvent)';  endfor
##---------------------------------------------------------------------------##  EXTRACCION DE CARACTERISTICAS (Coeficientes cepstrales en escala de Mel)##---------------------------------------------------------------------------  ## Al final de la pag. 13 del word de anotaciones de teoria se habla de estos MFCC,  ## y se explica los pasos para calcularlos (pre-enfasis, ventaneo, Fourier, banco de filtros,  ## logaritmo, transformada coseno, liftrado) y se muestra una imagen.  ## Se calculan en cada ventana.  ## Ver si debemos usar esos mismos pasos.  ##  cr = real(ifft(log(abs(fft(y))))); % cepstrum##---------------------------------------------------------------------------##  CORRELACION CRUZADA##---------------------------------------------------------------------------  ##r = xcorr(x,y) devuelve la correlaci�n cruzada de dos secuencias de tiempo diferenciado.  ##La correlaci�n cruzada mide la similitud entre un vector "x" y las copias desplazadas (desfasadas)  ##de un vector "y" como funci�n del desfase. Si "x" e "y" tienen longitudes diferentes,  ##la funci�n a�ade ceros al final del vector m�s corto para que tenga la misma longitud que el otro.  ## Se deberia hacer la correlacion cruzada entre la se�al de entrada y las cinco  ## se�ales de comandos disponibles en el sistema.  ## Tambien debemos usar la t�cnica dynamic time warping (DWT) para hacer un ajuste entre las se�ales  ## que nos permita realizar la comparaci�n, porque pueden ser de distinta duracion y entonces no usan  ## la misma cantidad de ventanas.##---------------------------------------------------------------------------##  IDENTIFICACION DE COMANDO##---------------------------------------------------------------------------  ## La se�al con mayor correlacion sera la de mayor similitud con la se�al de entrada,  ## determinando asi cual es el comando que el usuario desea ejecutar##---------------------------------------------------------------------------##  RESULTADO##---------------------------------------------------------------------------  ## Mostrar si la se�al de entrada fue un comando valido o noendfunction