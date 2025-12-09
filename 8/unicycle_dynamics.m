function [dqdt, ref, err, ctrl] = unicycle_dynamics(t, q)
    global gains
    k1 = gains(1); k2 = gains(2); k3 = gains(3);

    x = q(1); y = q(2); theta = q(3);

    % Traiettoria a 8
    A = 3; 
    w0 = 0.3; % frequenza base
    xd = A * sin(w0*t);
    yd = A * sin(2*w0*t) / 2;
    
    % Derivate prime (velocità cartesiane riferimento)
    dxd = A * w0 * cos(w0*t);
    dyd = A * 2 * w0 * cos(2*w0*t) / 2;
    
    % Derivate seconde (accelerazioni cartesiane riferimento)
    ddxd = -A * w0^2 * sin(w0*t);
    ddyd = -A * 4 * w0^2 * sin(2*w0*t) / 2;

    % Calcolo riferimenti non-olonomi (vd, wd, thetad)
    vd = sqrt(dxd^2 + dyd^2);
    thetad = atan2(dyd, dxd);
    wd = (dxd*ddyd - dyd*ddxd) / (vd^2 + 1e-6);

    % Calcolo errori nel body frame
    ex_world = xd - x;
    ey_world = yd - y;
    e_theta = thetad - theta;
    
    % Normalizzazione angolo tra -pi e pi
    e_theta = atan2(sin(e_theta), cos(e_theta));
    e1 =  cos(theta)*ex_world + sin(theta)*ey_world;
    e2 = -sin(theta)*ex_world + cos(theta)*ey_world;
    e3 = e_theta;

    % Legge di controllo
    v = vd * cos(e3) + k1 * e1;
    w = wd + k2 * vd * e2 + k3 * sin(e3);

    % 4. Dinamica del robot reale
    dxdt = v * cos(theta);
    dydt = v * sin(theta);
    dthetadt = w;
    dqdt = [dxdt; dydt; dthetadt];
    
    % Output extra per post-processing
    ref = [xd; yd; thetad];
    err = [e1; e2; e3];
    ctrl = [v; w];
end