function P = solve_ARE_shur(A, B, Q, R)
    % --- 2. Costruzione della matrice Hamiltoniana ---
    %
    %    H = [ A     -B*inv(R)*B' ]
    %        [ -Q        -A'      ]
    %
    
    % Costruisco la matrice Hamiltoniana 2n x 2n
    H = [ A, -B * (R \ B');
         -Q, -A'];
    
    % --- 3. Calcolo del sottospazio stabile ---

    % Usiamo la decomposizione di Schur ordinata ('stable')
    % Questo riordina la matrice T (Schur) e la matrice U (trasformazione)
    % in modo che gli autovalori con parte reale negativa (stabili)
    % appaiano nel blocco in alto a sinistra di T.

    [U, T] = schur(H);
    
    % Calcolo degli autovalori dalla matrice di Schur
    eigvals = diag(T);

    % Selezione degli autovalori stabili (parte reale negativa)
    n = size(A, 1);
    stable_idx = (real(eigvals) < -1e-10);

    % Ordino gli indici in modo che gli autovalori stabili siano primi
    [~, idx] = sort(real(eigvals));
    select = zeros(1, 2*n);
    select(idx(1:n)) = 1;

    % Riordino della decomposizione di Schur
    [U, T] = ordschur(U, T, select);

    % La matrice U (2n x 2n) viene partizionata in 4 blocchi n x n:
    U11 = U(1:n, 1:n);
    U21 = U(n+1:2*n, 1:n);

    % La soluzione P è data da P = U21 * inv(U11)
    P = U21 / U11; 

    % La soluzione P deve essere simmetrica. Piccoli errori numerici
    % possono renderla molto leggermente asimmetrica.
    % Forziamo la simmetria calcolando (P + P') / 2.
    P = (P + P') / 2;
end