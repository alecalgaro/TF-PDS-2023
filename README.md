# TF-PDS-2023

### Indicaciones:

- usuario_un_audio.m:  
  Función que se debe ejecutar para analizar un archivo de audios ya grabado, el cual representa una señal o comando de entrada, simulando como el usuario utilizaria el sistema ingresando un comando de voz.

- usuario_varios_audios.m:  
  Función que se debe ejecutar para analizar varios archivos de audio ya grabados, asi se envian todos los de un mismo comando juntos y se puede calcular estadisticas del conjunto.

- analizar_audio.m:  
  Funcion que analiza un audio de entrada aplicando un acondicionamiento de la señal y luego calcula caracteristicas relevantes de la misma (MFCC, LPC y energia), para devolverlas y utilizarlas en la comparación con las señales de referencia que representan los comandos disponibles en el sistema.

  Las señales de referencia ya fueron analizadas para obtener sus vectores de características y se crearon archivos .txt con dicha información para cada comando, con la finalidad de no tener que analizar todos los comandos de referencia cada vez que ingresa un nuevo comando de voz.
