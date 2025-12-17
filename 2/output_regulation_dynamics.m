function dz = output_regulation_dynamics(t, z, A, B, P, C, Q, S, K, Pi, Gamma, L_obs)
    % Estrazione stati
    n = size(A, 1);
    nw = size(S, 1);
    x = z(1:n);           % Stato sistema
    w = z(n+1 : n+nw);    % Stato esosistema
    xe_hat = z(n+nw+1 : end); % Stato osservatore esteso [x_hat; w_hat]
    
    x_hat = xe_hat(1:n); % Stima dello stato
    w_hat = xe_hat(n+1:end); % Stima riferimento e rumore
    
    % Calcolo misure
    y_meas = C * x; 
    
    % Calcolo controllo (Feedforward + Feedback)
    u = -K * (x_hat - Pi * w_hat) + Gamma * w_hat;
    
    % Dinamica del sistema
    dx = A * x + B * u + P * w;
    
    % Dinamica esosistema
    dw = S * w;
    
    % Misuro l'errore regolato e = Cx + Qw
    output_e = C * x + Q * w; 
    
    % Uscita stimata dall'osservatore
    output_e_hat = C * x_hat + Q * w_hat;
    
    % Aggiornamento osservatore
    Be = [B; zeros(nw, size(B,2))];
    Ae = [A, P; zeros(nw, n), S];
    dxe_hat = Ae * xe_hat + Be * u + L_obs * (output_e - output_e_hat);
    dz = [dx; dw; dxe_hat];
end