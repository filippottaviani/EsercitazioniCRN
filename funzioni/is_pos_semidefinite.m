function pos_semidef = is_pos_semidefinite(A)
    % Controlla se la matrice è semidefinita posistiva
    tol = -1e-6
    eigenvalues = eig(A);
    pos_semidef = all(eigenvalues >= tol);
end