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

    [U, ~] = schur(H, 'stable');


    % --- 4. Estrazione della soluzione ---
    
    % La matrice U (2n x 2n) viene partizionata in 4 blocchi n x n:
    % U = [U11, U12;
    %      U21, U22]
    %
    % Le prime n colonne di U [U11; U21] formano una base
    % per il sottospazio stabile di H.
    [n, ~] = size(A);
    U11 = U(1:n, 1:n);
    U21 = U(n+1:2*n, 1:n);

    % La soluzione P è data da P = U21 * inv(U11)
    P = U21 / U11; 

    % La soluzione P deve essere simmetrica. Piccoli errori numerici
    % possono renderla molto leggermente asimmetrica.
    % Forziamo la simmetria calcolando (P + P') / 2.
    P = (P + P') / 2;
end