% Funcion DTW que tiene como entrada
% a = vector de tamano (1, n)
% b = vector de tamano (1, m)
function dist = DTW(a, b)

  if (size(a, 1) != size(b, 1))
    printf("Dimensiones erroneas!");
    dist = NaN;
    return
  endif

##  # Normalizar
##  a = a./max(a, [], 1);
##  b = b./max(b, [], 1);

  # Cantidad de columnas de cada matriz de caracteristica
  len_a = size(a, 2);
  len_b = size(b, 2);

  # Inicializar la matriz de DTW
  an = sparse(zeros(len_a, len_b));

  # Inicializar los bordes
  an(:, 1) = norm(a - b(:, 1), 2, "columns");
  an(:, 1) = cumsum(an(:, 1));

  an(1, :) = norm(b - a(:, 1), 2, "columns");
  an(1, :) = cumsum(an(1, :));

  for i = 1: len_a - 1
    an(i+1, 2: end) = norm(b(:, 2: end) - a(:, i+1), 2, "columns");
    for j = 1: len_b - 1
        an(i+1, j+1) += min([an(i,j+1), an(i,j), an(i+1,j)]);
    endfor
  endfor

  dist = full(an(end,end));

endfunction

##
##function [dist, an, idx_ij] = DTW(a, b)
##
##  if (size(a, 1) != 1 || size(b, 1) != 1)
##    printf("Dimension de las entradas erronea!")
##    dist = an = idx_ij = NaN;
##    return
##  endif
##
##
##  # Busqueda de las distnacias
##  an = abs(a' - b);
##  an(:, 1) = cumsum(an(:, 1));
##  an(1, :) = cumsum(an(1, :));
##
##
##  w = abs(length(a) - length(b));
##  for i = 1: length(a) - 1
##      for j = max(1, i - w): min(length(b) - 1, i + w)
##          an(i+1, j+1) += min([an(i,j+1), an(i+1,j), an(i,j)]);
##      endfor
##  endfor
##
##  dist = an(end,end);
##
##
##  # Camino minimo con los indices de regreso
##  idx_ij = [length(a);
##            length(b)];
##  aux = [0, 1, 1;
##         1, 0, 1];
##
##  # Mientras ni i ni j llegase a 1, esto va regresando y guardando los
##  # indices de i y j en una matriz
##  while(idx_ij(1, end) != 1 && idx_ij(2, end) != 1)
##   i = idx_ij(1, end); j = idx_ij(2, end);
##
##   [val, x] = min([an(i,j-1), an(i-1,j), an(i-1,j-1)]);
##   idx_ij = [idx_ij, idx_ij(:, end) - aux(:, x)];
##
##  endwhile
##
##  # Comprueba si realmente llegaron a 1, sino agrega los numeros.
##  # Por ejemplo i = [5 4 3], j = [3 2 1], entonces rellena a
##  # i = [5 4 3 2 1], j = [3 2 1 1 1]
##
##  if (idx_ij(1, end) != 1)
##      cant = idx_ij(1, end) - 1;
##      idx_ij = [idx_ij, [cant: -1 :1; ones(1, cant)]];
##  elseif(idx_ij(2, end) != 1)
##      cant = idx_ij(2, end) - 1;
##      idx_ij = [idx_ij, [ones(1, cant); cant: -1: 1]];
##  endif
##
##
##
##endfunction



