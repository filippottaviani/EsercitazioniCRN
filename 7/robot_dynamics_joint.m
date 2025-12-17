function dy = robot_dynamics_joint(t, y, q_des, Kp, Kd)
    % Assicuriamoci che y sia un vettore colonna
    y = y(:);
    q = y(1:2); 
    dq = y(3:4);
    
    % Recuperiamo le matrici dinamiche
    [B, C, g, F] = get_dynamic_matrices(q, dq);
    
    e_q = q_des - q; % Errore di posizione ai giunti
    
    % Controllo PD + Compensazione gravità (g)
    u = Kp * e_q - Kd * dq + g;
    
    % Dinamica
    ddq = B \ (u - C*dq - F - g);
    dy = [dq; ddq];
end