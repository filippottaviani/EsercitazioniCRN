function dy = robot_dynamics_computed_torque(t, y, A_traj, w_traj)
    y = y(:); 
    q = y(1:2); 
    dq = y(3:4);
    
    % Generazione traiettoria di riferimento
    qd = A_traj .* sin(w_traj*t);
    dqd = A_traj .* w_traj .* cos(w_traj*t);
    ddqd = -A_traj .* w_traj.^2 .* sin(w_traj*t);
    
    % Calcolo matrici dinamiche
    [B, C, g, F] = get_dynamic_matrices(q, dq);
    
    % Legge di controllo Computed Torque
    e = qd - q;
    de = dqd - dq;
    
    % Tuning PD
    wn = 10; % Banda passante [rad/s]
    Kp = diag([wn^2, wn^2]);
    Kd = diag([2*wn, 2*wn]);
    
    % Ingresso ausiliario (doppio integratore stabilizzato)
    u_aux = ddqd + Kd*de + Kp*e;
    
    % Linearizzazione tramite feedback (Calcolo Coppia)
    u = B * u_aux + C*dq + F + g;
    
    % Dinamica diretta
    ddq = B \ (u - C*dq - F - g);
    dy = [dq; ddq];
end