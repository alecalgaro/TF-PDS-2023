##--------------------------------------------------------------------------
## Funcion para grabar un audio en tiempo real, analizarlo y determinar el comando.
## Representaria una forma de uso donde el usuario presiona un boton cada vez que
## desea ejecutar una accion en la silla de ruedas y pronuncia cual es el comando.
##--------------------------------------------------------------------------

clc;

##---------------------------------------------------------------------------
##  VECTORES DE CARACTERISTICAS DE LOS COMANDOS DE REFERENCIA DISPONIBLES EN EL SISTEMA
##  (para comparar luego con la senial de entrada)
##---------------------------------------------------------------------------

  [data_adelante] = load("data_adelante.txt");
  [data_atras] = load("data_atras.txt");
  [data_derecha] = load("data_derecha.txt");
  [data_izquierda] = load("data_izquierda.txt");
  [data_detener] = load("data_detener.txt");

##---------------------------------------------------------------------------
##  GRABAR AUDIO DE ENTRADA EN TIEMPO REAL
##---------------------------------------------------------------------------

  disp('Presione alguna tecla para empezar a grabar (p: para salir): ');
  tecla = kbhit ();

  while(tecla != "p") % p para pause
    Fs = 8000;
    nombre_archivo = "comando.wav";
    cant_audios = 1;
    % Grabamos el archivo de audio usando la funcion audiorecorder(Fs, NBITS, numero de canales)
    r = audiorecorder(Fs, 16, 1);
    record(r);
    disp("Grabando...");
    pause(1.5)    % el archivo de sonido durará 1.5 seg.
    pause(r);
    % Obtenemos los datos de la grabacion de audio r
    y = getaudiodata(r);
    % Guardamos el archivo de sonido en formato .wav
    audiowrite(nombre_archivo,y,Fs);
    disp("Finalizó la grabación");
    disp("Analizando...");
    disp("")

##---------------------------------------------------------------------------
##  SE ANALIZA EL AUDIO DE ENTRADA
##---------------------------------------------------------------------------

    [caract] = analizar_audio(nombre_archivo);

##---------------------------------------------------------------------------
##  IDENTIFICACION DE COMANDO
##---------------------------------------------------------------------------

    disp("")
    dif_adelante = DTW(caract, data_adelante);
    dif_atras = DTW(caract, data_atras);
    dif_derecha = DTW(caract, data_derecha);
    dif_izquierda = DTW(caract, data_izquierda);
    dif_detener = DTW(caract, data_detener);

    [res, i] = min([dif_adelante, dif_atras, dif_derecha, dif_izquierda, dif_detener]);
    res;

##---------------------------------------------------------------------------
##  RESULTADO
##---------------------------------------------------------------------------

    comando = [" adelante"; " atras"; " derecha"; " izquierda"; " detener"];

    disp(strcat("Comando elegido:", comando(i,:)))

    % Se queda a la espera de presionar nuevamente una tecla para grabar un nuevo comando
    disp("");
    disp('Presione alguna tecla para empezar a grabar (p: para salir): ');
    tecla = kbhit ();

  endwhile

  return;
