##  Funcion para analizar un archivo ya grabado, representando un solo comando.

clear;  clc;  close all;

##---------------------------------------------------------------------------
##  VECTORES DE CARACTERISTICAS DE LOS COMANDOS DISPONIBLES EN EL SISTEMA
##  (para comparar luego con la senial de entrada)
##---------------------------------------------------------------------------

  [data_adelante] = load("data_adelante.txt");
  [data_atras] = load("data_atras.txt");
  [data_derecha] = load("data_derecha.txt");
  [data_izquierda] = load("data_izquierda.txt");
  [data_parar] = load("data_parar.txt");

##---------------------------------------------------------------------------
##  SE ANALIZA EL AUDIO DE ENTRADA
##---------------------------------------------------------------------------

  nombre_archivo = strcat("dataset-ajustes/adelante_2.wav");
  [mfcc] = analizar_audio(nombre_archivo);

##---------------------------------------------------------------------------
##  IDENTIFICACION DE COMANDO
##---------------------------------------------------------------------------

  ## Se busca el comando con mayor similitud a la senal de entrada y si se supera
  ## cierto umbral de similitud se indica como comando valido.
  dif_mismo = DTW(mfcc, mfcc)

  dif_adelante = DTW(mfcc, data_adelante)
  dif_atras = DTW(mfcc, data_atras)
  dif_derecha = DTW(mfcc, data_derecha)
  dif_izquierda = DTW(mfcc, data_izquierda)
  dif_parar = DTW(mfcc, data_parar)
  disp("")

  ##  dif_adelante = norm(mfcc - data_adelante, 2)
##  dif_atras = norm(mfcc - data_atras, 2)
##  dif_derecha = norm(mfcc - data_derecha, 2)
##  dif_izquierda = norm(mfcc - data_izquierda, 2)
##  dif_parar = norm(mfcc - data_parar, 2)
##  disp("")

  res = min([dif_adelante, dif_atras, dif_derecha, dif_izquierda, dif_parar])

##---------------------------------------------------------------------------
##  RESULTADO
##---------------------------------------------------------------------------

  ## Mostrar si la senial de entrada fue un comando valido o no
