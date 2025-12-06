function [x, J] = get_kinematics(q)
    global geom
    l1 = geom.l1;
    l2 = geom.l2;
    q1 = q(1); 
    q2 = q(2);
    
    % Funzioni trigonometriche ausiliarie
    s1 = sin(q1); c1 = cos(q1);
    s12 = sin(q1+q2); c12 = cos(q1+q2);
    
    % Cinematica diretta
    x_pos = l1*c1 + l2*c12;
    y_pos = l1*s1 + l2*s12;
    x = [x_pos; y_pos];
    
    % Jacobiano Analitico
    J = [-l1*s1 - l2*s12,   -l2*s12;
          l1*c1 + l2*c12,    l2*c12];
end