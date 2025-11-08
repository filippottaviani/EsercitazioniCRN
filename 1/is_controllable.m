% Verifica se la copppia è controllabile
function controllable = is_controllable(A, B)
    % Costruisco manualmente la matrice di controllabilità: R_AB = [B, AB, A^2B, ..., A^(n-1)B]
    R_AB = B;  % Inizializzo con B
    A_power = A; % A^1
    [n, ~] = size(A);
    
    % Aggiungo iterativamente le colonne AB, A^2B, ..., A^(n-1)B
    for i = 1:(n-1)
        R_AB = [R_AB, A_power * B];
        A_power = A_power * A;  % Calcolo la prossima potenza di A
    end

    % Controllo del rango pieno
    rank_R_AB = rank(R_AB);
    if rank_R_AB < n
        controllable = false;
    else
        controllable = true;
end