function [y_con_ruido, py, pr] = generar_ruido(y,SNR)
  
## Nos basamos en la explicaci�n del ejercicio 2 de la guia de la pr�ctica de procesamiento de la voz,
## donde el profe explico como determinar la potencia del ruido en base a la potencia de la se�al y 
## la SNR que queremos usar. 
## Link del video: https://drive.google.com/file/d/1cALhVcNbycQJlPGETCeo3StgpovS4LIQ/view
## La explicaci�n de esta parte comienza en el minuto 21 aproximadamente.

##  Si queremos usar un ruido de personas hablando:
##  nombre_archivo = "ruido_personas.wav";
##  [r,t] = obtener_y(nombre_archivo); % r: ruido

## Si queremos usar un ruido random:
  r = randn(size(y));
  
  py = sum(y.*y);     % aca no hace falta dividir por "n" porque cuando haga el cociente divide las dos
  pr0 = sum(r.*r);
  
  alfa = sqrt(py/(pr0*10^(SNR/10)));
  pr = sum((alfa*r).*(alfa*r));     % potencia del ruido necesario
  % podr�a ser pr = sum((alfa*r).^2);
  
  y_con_ruido = y + alfa*r;

endfunction