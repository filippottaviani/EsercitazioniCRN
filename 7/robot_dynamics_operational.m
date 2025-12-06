function dy = robot_dynamics_operational(t, y, x_des)
    % Assicuriamoci che y sia un vettore colonna (4x1)
    y = y(:); 
    q = y(1:2); dq = y(3:4);
    
    % Calcolo matrici dinamiche (B, C, g, F)
    [B, C, g, F] = get_dynamic_matrices(q, dq);
    
    % Calcolo Cinematica e JACOBIANO
    [x_curr, J] = get_kinematics(q);
    
    % Legge di Controllo nello Spazio Operativo
    e_x = x_des - x_curr;
    
    % Velocità cartesiana reale
    dx = J * dq;
    
    % Guadagni del controllore
    Kp = diag([500, 500]); 
    Kd = diag([50, 50]);
    
    % Forza virtuale cartesiana richiesta (2x1)
    F_task = Kp * e_x - Kd * dx;
    
    % Mappatura in coppie ai giunti tramite J trasposto + Compensazione Gravità
    tau = J' * F_task + g;
    
    % 4. Dinamica diretta del robot
    ddq = B \ (tau - C*dq - F - g);
    dy = [dq; ddq];
end