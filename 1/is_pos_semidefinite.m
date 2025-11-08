% Controlla se la matrice è semidefinita posistiva
function pos_semidef = is_pos_semidefinite(A)
    eigenvalues = eig(A);
    pos_semidef = all(eigenvalues >= -1e-10);
end