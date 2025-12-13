function dy = robot_dynamics_adaptive(t, y_aug, A_traj, w_traj, Lambda, Gamma, Kd)
    % Stato aumentato
    q = y_aug(1:2);
    dq = y_aug(3:4);
    theta_hat = y_aug(5:end);
    
    % Generazione traiettoria
    qd = A_traj .* sin(w_traj*t);
    dqd = A_traj .* w_traj .* cos(w_traj*t);
    ddqd = -A_traj .* w_traj.^2 .* sin(w_traj*t);
    
    % Errore
    e = q - qd;
    
    % Velocità e accelerazione di riferimento "virtuali"
    dqr = dqd - Lambda * e;
    ddqr = ddqd - Lambda * (dq - dqd);
    
    % Superficie di scorrimento s = dq - dqr = de + Lambda*e
    s = dq - dqr;
    
    % Calcolo Regressore Y(q, dq, dqr, ddqr)
    Y = get_regressor(q, dq, dqr, ddqr);
    
    % Legge di controllo: Feedforward Adattativo (Y*theta_hat) + Feedback PD (Kd*s)
    u = Y * theta_hat - Kd * s;
    
    % Legge di adattamento (Update Parametri)
    d_theta_hat = -Gamma * Y' * s;
    
    % Utilizziamo i parametri "veri" (ignoti al controllore) per la simulazione
    [B, C, g, F] = get_dynamic_matrices(q, dq);
    
    % Dinamica diretta: B*ddq + C*dq + F + g = tau
    ddq = B \ (u - C*dq - F - g);
    
    % Derivata dello stato aumentato
    dy = [dq; ddq; d_theta_hat];
end