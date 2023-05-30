function dist = DTW(a, b)

  length_a = length(a);
  length_b = length(b);

  an = sparse(zeros(length_a+1,length_b+1));

  # Inicializar los bordes
  an(1, :) = 1e5;
  an(:, 1) = 1e5;

  an(1,1)=0;

  # Tamano de ventana
  w=abs(length_a - length_b);

  for i = 1: length_a
##      for j = max(1,i-w-3): min(length_b,i+w)
      for j = 1: length_b
          cost = abs(a(i) - b(j));
          an(i+1, j+1) = cost + min([an(i,j+1),an(i+1,j),an(i,j)]);
      end
  end

  dist = double(an(end,end));

endfunction


clear; clc
fm = 200;
t1 = 0: 1/fm: 1 - 1/fm;
t2 = 0: 1/fm: 0.5;
a = sin(2*pi*(5 + 5*t1) .* t1);
b = sin(2*pi*25*t2);


plot(t1, a);
hold on;
plot(t2, b);

##a = [2 3 3];
##b = [2 3];


dist = DTW(a, b)
# Primer for
# (1, 1) -> 0.4533

# Segundo for j = 1: algo - 3
##  (1, 1) -> 4.2274

# Tercer for todo




