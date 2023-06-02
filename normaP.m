function V = normaP(x,p)    % En octave norm(x, p)
  sum = 0;
  for i = 1:length(x)
    sum += abs(x(i))^p;
  endfor
  V = sum^(1/p);
endfunction