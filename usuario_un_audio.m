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
  [data_detener] = load("data_detener.txt");
##  [data_parar] = load("data_parar.txt");

##---------------------------------------------------------------------------
##  SE ANALIZA EL AUDIO DE ENTRADA
##---------------------------------------------------------------------------

  nombre_archivo = strcat("dataset-ajustes/atras_1.wav");
  [caract] = analizar_audio(nombre_archivo);



##  # Guardo los datos de referencia por aca, asi cambio el nombre del archivo txt
##  ref = [ "adelante_1"  ;
##          "atras_1"     ;
##          "derecha_1"   ;
##          "detener_1"   ;
##          "izquierda_1" ;
##          "parar_1"];
##
##  cual = 6;
##
##  nombre_archivo = strcat("dataset-ajustes/", ref(cual, :),".wav");
##
##  [caract] = analizar_audio(nombre_archivo);
##  save data_parar.txt caract;

##---------------------------------------------------------------------------
##  IDENTIFICACION DE COMANDO
##---------------------------------------------------------------------------

  ## Se busca el comando con mayor similitud a la senal de entrada y si se supera
  ## cierto umbral de similitud se indica como comando valido.
  disp("")
  dif_mismo = DTW(caract, caract)

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

  ## Mostrar si la senial de entrada fue un comando valido o no, verificando si
  ## supera cierto umbral de similitud, e indicar cual fue el comando.

  comando = [" adelante"; " atras"; " derecha"; " izquierda"; " detener"];

  umbral = 0;
  if(res > umbral)
    disp(strcat("Comando elegido:", comando(i,:)))
  elseif
    disp("Comando no valido")
  endif
