function stabilizable = is_stabilizable(A, B, K)
    % Verifico lo spettro della matrice (A-BK)
    tol = 1e-6
    stab_poles= eig(A - B*K);
    if max(real(stab_poles)) < tol
        stabilizable = true;
    else
        stabilizable = false;
    end
end