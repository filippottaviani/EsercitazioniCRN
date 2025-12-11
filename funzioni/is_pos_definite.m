function pos_def = is_pos_definite(A)
    % Controlla se la matrice è definita posistiva
    tol = 1e-6
    eigenvalues = eig(A);
    pos_def = all(eigenvalues > tol);
end