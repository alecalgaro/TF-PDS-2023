## Funcion para analizar un archivo ya grabado, representando un solo comando,
## simulando como el usuario utilizaria el sistema ingresando un comando de voz.

## Se busca el comando con mayor similitud a la senal de entrada, utilizando
## la funcion DTW para ajustar las ventanas y calcular las diferencias entre las
## caracteristicas de la senal de entrada y los comandos disponibles en el sistema.
## Si se supera cierto umbral de similitud se indica como comando valido.

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
##  SE ANALIZA EL AUDIO DE ENTRADA
##---------------------------------------------------------------------------

##  nombre_archivo = strcat("dataset-ajustes/adelante_2.wav");
  nombre_archivo = strcat("dataset-ajustes/comando_no_valido_derecha_1.wav");
  [caract] = analizar_audio(nombre_archivo);

## Para cuando se quieren actualizar los txt con los vectores de caracteristicas
## de los comandos de referencia disponibles en el sistema.
##  save data_adelante.txt caract;
##  save data_atras.txt caract;
##  save data_derecha.txt caract;
##  save data_izquierda.txt caract;
##  save data_detener.txt caract;

##---------------------------------------------------------------------------
##  IDENTIFICACION DE COMANDO
##---------------------------------------------------------------------------

  disp("")
  dif_adelante = DTW(caract, data_adelante)
  dif_atras = DTW(caract, data_atras)
  dif_derecha = DTW(caract, data_derecha)
  dif_izquierda = DTW(caract, data_izquierda)
  dif_detener = DTW(caract, data_detener)
  disp("")

  [res, i] = min([dif_adelante, dif_atras, dif_derecha, dif_izquierda, dif_detener]);
  res

##---------------------------------------------------------------------------
##  RESULTADO
##---------------------------------------------------------------------------

  ## Mostrar si la senal de entrada fue un comando valido o no, verificando si
  ## supera cierto umbral de similitud de acuerdo al comando de referencia con
  ## mayor similitud, e indicar cual fue el comando.

  comando = [" adelante"; " atras"; " derecha"; " izquierda"; " detener"];

  disp(strcat("Comando elegido:", comando(i,:)))

% Si se quiere utilizar el umbral para comandos sin ruido:
##  umbral = [3.1, 3.7, 2.4, 2.9, 3.1];
##
##  if(res < umbral(i))
##    disp(strcat("Comando elegido:", comando(i,:)))
##  else
##    disp("Comando no valido")
##  endif
