% Controlla se la matrice è definita posistiva
function pos_def = is_pos_definite(A)
    eigenvalues = eig(A);
    pos_def = all(eigenvalues > 1e-10); % tolleranza numerica
end