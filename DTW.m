% Funcion DTW que tiene como entrada
% a = vector de tamano (1, n)
% b = vector de tamano (1, m)


clear; clc
a = [2 3 3 4 5 4];
b = [2 3 4];

a = [1 1 2 3 4 4 5 6];
b = [1 2 2 2 3 4 5 5 6 6];


##fm = 30;
##t1 = 0: 1/fm: 1 - 1/fm;
##t2 = 0: 1/fm: 0.5;
##a = sin(2*pi*(2 + 2*t1) .* t1);
##b = sin(2*pi*5*t2);
##
##plot(t1, a);
##hold on;
##plot(t2, b);



function [dist, an, idx_ij] = DTW(a, b)

  if (size(a, 1) != 1 || size(b, 1) != 1)
    printf("Dimension de las entradas erronea!")
    dist = NaN;
    return
  endif

  # Busqueda de las distnacias
  an = abs(a' - b);
  an(:, 1) = cumsum(an(:, 1));
  an(1, :) = cumsum(an(1, :));

  for i = 1: length(a) - 1
      for j = 1: length(b) - 1
          an(i+1, j+1) += min([an(i,j+1), an(i+1,j), an(i,j)]);
      endfor
  endfor

  dist = an(end,end);


  # Camino minimo con los indices de regreso
  idx_ij = [length(a);
            length(b)];
  aux = [0, 1, 1;
         1, 0, 1];

  # Mientras ni i ni j llegase a 1, esto va regresando y guardando los
  # indices de i y j en una matriz
  while(idx_ij(1, end) != 1 && idx_ij(2, end) != 1)
   i = idx_ij(1, end); j = idx_ij(2, end);

   [val, x] = min([an(i,j-1), an(i-1,j), an(i-1,j-1)]);
   idx_ij = [idx_ij, idx_ij(:, end) - aux(:, x)];

  endwhile

  # Comprueba si realmente llegaron a 1, sino agrega los numeros.
  # Por ejemplo i = [5 4 3], j = [3 2 1], entonces rellena a
  # i = [5 4 3 2 1], j = [3 2 1 1 1]

  if (idx_ij(1, end) != 1)
      cant = idx_ij(1, end) - 1;
      idx_ij = [idx_ij, [cant: -1 :1; ones(1, cant)]];
  elseif(idx_ij(2, end) != 1)
      cant = idx_ij(2, end) - 1;
      idx_ij = [idx_ij, [ones(1, cant); cant: -1: 1]];
  endif



endfunction


[dist, an, idx_ij] = DTW(a, b)




