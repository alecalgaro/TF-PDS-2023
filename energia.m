function E = energia(x)
  E = normaP(x,2)^2;    % Energia = norma 2 de x, al cuadrado.  norm(x, 2)^2
                        % tambien seria como sum += abs(x(i))^2, porque el otro ^2 se cancelaria con el ^1/2 de la norma
endfunction