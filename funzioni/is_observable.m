function observable = is_observable(A, C)
    [n, ~] = size(A);
    
    % Costruisco manualmente la matrice di osservabilità
    O_AC = C;
    A_power = A;
    
    % Aggiungo iterativamente le righe C*A, C*A^2, ...
    for i = 1:(n-1)
        O_AC = [O_AC; C * A_power];
        A_power = A_power * A;
    end

    % Controllo del rango pieno
    rank_O_AC = rank(O_AC);
    if rank_O_AC < n
        observable = false;
    else
        observable = true;
    end
end