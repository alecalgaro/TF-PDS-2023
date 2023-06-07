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


  # Guardo los datos de referencia por aca, asi cambio el nombre del archivo txt
  # Lo bueno es que puedo cambiar la referencia por aca, simplemente eligiendo el
  # "cual" especifico. Si quiero actualizar atras_1 a atras_2, le cambio
  # el nombre simplemente y actualizo con los comandos siguientes.
##
##  ref = [ "adelante_1"  ;
##          "atras_1"     ;
##          "derecha_1"   ;
##          "detener_1"   ;
##          "izquierda_1" ;
##          "parar_1"];
##
####  for cual = 1: size(ref, 1)
##    cual = 2;
##    nombre_archivo = strcat("dataset-ajustes/", ref(cual, :),".wav");
##
##    [caract] = analizar_audio(nombre_archivo);
##    switch (cual)
##      case 1
##        save data_adelante.txt caract;
##      case 2
##        save data_atras.txt caract;
##      case 3
##        save data_derecha.txt caract;
##      case 4
##        save data_detener.txt caract;
##      case 5
##        save data_izquierda.txt caract;
##      case 6
##        save data_parar.txt caract;
##    endswitch
####  endfor

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
