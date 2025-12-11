function controllable = is_controllable(A, B)
    % Costruisco manualmente la matrice di controllabilità: R_AB = [B, AB, A^2B, ..., A^(n-1)B]
    R_AB = B;
    A_power = A;
    [n, ~] = size(A);
    
    % Aggiungo iterativamente le colonne AB, A^2B, ..., A^(n-1)B
    for i = 1:(n-1)
        R_AB = [R_AB, A_power * B];
        A_power = A_power * A;
    end

    % Controllo del rango pieno
    rank_R_AB = rank(R_AB);
    if rank_R_AB < n
        controllable = false;
    else
        controllable = true;
    end
end