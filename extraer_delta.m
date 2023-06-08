function delta_mfcc = extraer_delta(mfcc, n)

  delta_mfcc = zeros(size(mfcc));
  len_T = size(mfcc, 2);

  # Se recorre cada ventana y se calcula delta
  for i = n + 1: len_T - n

    # Trabajo en forma matricial, tiene cantidad de fila de mfcc, 26x1
    num = zeros(size(mfcc, 1), 1);

    for j = 1: n
      num += j* (mfcc(:, i + j) - mfcc(:, i - j));
    endfor
    den = [1: n] * [1: n]';
    delta_mfcc(:, i) = num / (2*den);
  endfor

endfunction