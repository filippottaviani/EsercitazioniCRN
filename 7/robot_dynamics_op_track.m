function dy = robot_dynamics_op_track(t, y, traj_data, Kp, Kd)
    y = y(:);
    q = y(1:2);
    dq = y(3:4);
    
    % Riferimenti cartesiani (cerchio)
    C = traj_data.Center;
    R = traj_data.Radius;
    w = traj_data.Omega;
    
    xd = C + [R*cos(w*t); R*sin(w*t)];
    dxd = [-R*w*sin(w*t); R*w*cos(w*t)];
    ddxd = [-R*w^2*cos(w*t); -R*w^2*sin(w*t)];
    
    % Cinematica attuale
    [x, J] = get_kinematics(q);
    
    % Calcolo della dJ 
    dJ = get_jacobian_dot(q, dq);
    dJ_dq = dJ * dq;

    dx = J * dq;
    
    % Legge di controllo operativa
    e = xd - x;
    de = dxd - dx;
    
    % Accelerazione cartesiana virtuale
    v_cart = ddxd + Kd*de + Kp*e;
    
    % Mappatura nello spazio dei giunti
    ddq_ref = J \ (v_cart - dJ_dq);
    
    % Dinamica inversa (Computed Torque)
    [B, C_mat, g, F] = get_dynamic_matrices(q, dq);
    
    tau = B * ddq_ref + C_mat*dq + F + g;
    
    % Dinamica diretta
    ddq = B \ (tau - C_mat*dq - F - g);
    dy = [dq; ddq];
end