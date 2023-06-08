##---------------------------------------------------------------------------
##  Para analizar varios archivos ya grabados, asi se envian todos los de un
##  mismo comando juntos y se puede calcular estadisticas del conjunto
##---------------------------------------------------------------------------

  clear;  clc;  close all;

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
##  Se leen todos los audios correspondientes a un comando
##---------------------------------------------------------------------------

  ubicacion_archivo = "dataset-ajustes/adelante_";  % ubicacion de los archivos, sin la numeración, ni la extensión .wav
  cant_audios = 6; % cantidad de audios

  ##ubicacion_archivo = "dataset-ajustes/atras_";  % ubicacion de los archivos, sin la numeración, ni la extensión .wav
  ##cant_audios = 5; % cantidad de audios

  ##ubicacion_archivo = "dataset-ajustes/derecha_";  % ubicacion de los archivos, sin la numeración, ni la extensión .wav
  ##cant_audios = 4; % cantidad de audios

  ##ubicacion_archivo = "dataset-ajustes/izquierda_";  % ubicacion de los archivos, sin la numeración, ni la extensión .wav
  ##cant_audios = 4; % cantidad de audios

  ##ubicacion_archivo = "dataset-ajustes/detener_";  % ubicacion de los archivos, sin la numeración, ni la extensión .wav
  ##cant_audios = 4; % cantidad de audios

##---------------------------------------------------------------------------
##  Se recorren y analizan todos los audios
##---------------------------------------------------------------------------

  for i = 1:cant_audios; % numero de archivo

    nombre_archivo = strcat(ubicacion_archivo, int2str(i), ".wav");
    [caract] = analizar_audio(nombre_archivo);

    ##---------------------------------------------------------------------------
    ##  Identificacion del comando
    ##---------------------------------------------------------------------------

    disp("")
    dif_mismo = DTW(caract, caract)   % solo para probar

    dif_adelante = DTW(caract, data_adelante)
    dif_atras = DTW(caract, data_atras)
    dif_derecha = DTW(caract, data_derecha)
    dif_izquierda = DTW(caract, data_izquierda)
    dif_detener = DTW(caract, data_detener)
    disp("")

    [res, i] = min([dif_adelante, dif_atras, dif_derecha, dif_izquierda, dif_detener]);
    res

    ##---------------------------------------------------------------------------
    ##  Resultado
    ##---------------------------------------------------------------------------

    comando = [" adelante"; " atras"; " derecha"; " izquierda"; " detener"];
    umbral = [3.1, 3.7, 2.4, 2.9, 3.1];

    if(res < umbral(i))
      disp(strcat("Comando elegido:", comando(i,:)))
    else
      disp("Comando no valido")
    endif

  endfor
