function dz = closed_loop_dynamics(t, z, A, B, C, K, L)
    % Estraggo gli stati reali e stimati
    x = z(1:4);
    x_hat = z(5:8);
    
    % Uscita
    y = C * x;
    
    % Legge di controllo basata sullo stato stimato
    u = -K * x_hat;
    
    % Dinamica del sistema reale
    dx = A * x + B * u;
    
    % Dinamica dell'osservatore
    dx_hat = A * x_hat + B * u + L * (y - C * x_hat);
    
    % Combina derivate
    dz = [dx; dx_hat];
end