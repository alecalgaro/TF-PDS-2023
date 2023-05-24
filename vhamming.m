## En pag. 1 de mi word con anotaciones de teoria habla del ventaneo y que la
## mas usada es la de Hamming. Ver si ahi usa lo mismo porque tiene n-1 y N-1
## en lo que seria la linea 10 del codigo.

function [w] = vhamming(t)
  N = length(t);
  n = 1:N;
  a = 27/50;
  b = 23/50;
  argumento = 2*pi*n/N;
  w = a-b*cos(argumento);
endfunction