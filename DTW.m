% Funcion DTW que tiene como entrada
% a = vector de tamano (1, n)
% b = vector de tamano (1, m)

function dist = DTW(a, b)

  if (size(a, 1) != size(b, 1))
    printf("Dimensiones erroneas!");
    dist = NaN;
    return
  endif

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

  dist = full(an(end,end))/(len_a + len_b - 1);

endfunction
