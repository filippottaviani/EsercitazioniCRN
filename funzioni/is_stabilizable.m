function stabilizable = is_stabilizable(A, B)
    % Utilizzo il PBH test
    n = size(A, 1);
    all_eigs = eig(A);
    
    % Tolleranza per confronti numerici
    tol = 1e-6;

    % Filtra solo autovalori con parte reale >= 0 (instabili)
    unstable_mask = real(all_eigs) >= -tol;
    unstable_eigs = all_eigs(unstable_mask);
    stabilizable = true;

    if isempty(unstable_eigs)
        return;
    end

    % Test PBH sugli autovalori instabili
    for i = 1:length(unstable_eigs)
        lam = unstable_eigs(i);
        pbh_mat = [A - lam * eye(n), B];
        
        if rank(pbh_mat, tol) < n
            stabilizable = false;
        end
    end
end