clear;  clc;  close all;

##---------------------------------------------------------------------------
##  Para analizar varios archivos ya grabados, representando lo que seria el 
##  usuario haciendo un recorrido con la silla de ruedas
##---------------------------------------------------------------------------

ubicacion_archivo = "NombreCarpeta/cabecera_";  % ubicacion de los archivos, sin la numeración, ni la extensión .wav
cant_audios = n; % cantidad de audios

for i = 1:cant_audios; % numero de archivo
  
  nombre_archivo = strcat(ubicacion_archivo,int2str(i),".wav");

  %--- Se analiza el audio ---

  [..] = analizar_audio(nombre_archivo);

  %--- Se muestran los datos ---
      
endfor