clear;  clc;  close all;

##---------------------------------------------------------------------------
##  Para analizar un archivo ya grabado, representando un solo comando.
##---------------------------------------------------------------------------

ubicacion_archivo = "NombreCarpeta/nombre_archivo.wav"; % ubicacion de los archivos, sin la numeración, ni la extensión .wav
  
nombre_archivo = strcat(ubicacion_archivo,int2str(i),".wav");

%--- Se analiza el audio ---

[..] = analizar_audio(nombre_archivo);

%--- Se muestran los datos ---