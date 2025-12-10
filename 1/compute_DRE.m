function Pdot_vec = compute_DRE(P_vec, A, B, Q, R, n)

    % Ricostruisco la matrice P (n x n) dal vettore P_vec (n^2 x 1)
    P = reshape(P_vec, n, n);

    % Calcolo la derivata P_dot usando l'equazione di Riccati
    Pdot = -(A'*P + P*A + Q - P*B*inv(R)*B'*P);

    % Vettorizzo l'output Pdot per restituirlo a ode45
    Pdot_vec = Pdot(:); 
end