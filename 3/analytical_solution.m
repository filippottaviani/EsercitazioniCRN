function [t_an, x_an] = analytical_solution(fun_analitica_handle, t_punti, x0)
    % Calcolo della soluzione analitica
    disp('Calcolo soluzione analitica...');
    t_an = t_punti;
    x_an = fun_analitica_handle(t_an, x0);
    disp('Soluzione analitica calcolata.');
end