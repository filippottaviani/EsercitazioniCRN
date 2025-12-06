function dy = robot_dynamics_joint(t, y, q_des)
    % Assicuriamoci che y sia un vettore colonna
    y = y(:);
    q = y(1:2); 
    dq = y(3:4);
    
    % Recuperiamo le matrici dinamiche
    [B, C, g, F] = get_dynamic_matrices(q, dq);
    
    % Impostazione dei guadagni
    Kp = diag([300, 300]);  % Guadagno proporzionale
    Kd = diag([30, 30]);    % Guadagno derivativo
    
    e_q = q_des - q;        % Errore di posizione ai giunti
    
    % Controllo PD + Compensazione Gravità (g)
    tau = Kp * e_q - Kd * dq + g;
    
    % Dinamica
    ddq = B \ (tau - C*dq - F - g);
    dy = [dq; ddq];
end