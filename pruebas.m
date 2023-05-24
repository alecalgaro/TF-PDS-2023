clear; close all; clc;

## Esto lo hacemos al final, una vez que el sistema funciona.
##
## Podemos separar en distintas pruebas para cada tipo de comando: adelante, atras, derecha, izquierda y parar.
## Se podria separar los comandos de prueba en distintas carpetas, donde en cada una haya varios comandos de cada tipo, 
## y aca ir leyendo por ejemplo primero todos los comandos "Adelante" y contar la cantidad de aciertos y desaciertos del sistema  
## al indicar el comando reconocido. Lo mismo para los demás comandos y obtener un porcentaje de acierto para cada uno.
##
## Luego se les puede agregar distintos niveles de ruido (cambiando la SNR) e ir obteniendo otros porcentajes
## para evaluar la robustez del sistema.
## Tambien podemos hacer graficas para mostrar como aumenta la cantidad de errores al aumentar el ruido.