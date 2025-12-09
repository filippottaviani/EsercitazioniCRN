function dJ = get_jacobian_dot(q, dq)
    global geom
    l1 = geom.l1; l2 = geom.l2;
    
    q1 = q(1); q2 = q(2);
    dq1 = dq(1); dq2 = dq(2);
    s1 = sin(q1); c1 = cos(q1);
    s12 = sin(q1+q2); c12 = cos(q1+q2);
    
    % Termine (1,1): d(-l1*s1 - l2*s12)/dt
    dJ11 = -l1*c1*dq1 - l2*c12*(dq1+dq2);
    
    % Termine (1,2): d(-l2*s12)/dt
    dJ12 = -l2*c12*(dq1+dq2);
    
    % Termine (2,1): d(l1*c1 + l2*c12)/dt
    dJ21 = -l1*s1*dq1 - l2*s12*(dq1+dq2);
    
    % Termine (2,2): d(l2*c12)/dt
    dJ22 = -l2*s12*(dq1+dq2);
    
    % Assemblo lo jacobiano
    dJ = [dJ11, dJ12;
          dJ21, dJ22];
end