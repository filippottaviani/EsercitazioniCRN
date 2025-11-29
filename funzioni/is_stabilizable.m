% Verifica se la coppia è stabilizzabile
function stabilizable = is_stabilizable(A, B, K, tol)
    % Verifico lo spettro della matrice (A-BK)
    stab_poles= eig(A - B*K);
    if max(real(stab_poles)) < tol
        stabilizable = true;
    else
        stabilizable = false;
    end
end