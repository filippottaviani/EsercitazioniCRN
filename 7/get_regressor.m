function Y = get_regressor(q, dq, dqr, ddqr)
    % Costruisce la matrice Y tale che Y*Theta = B*ddqr + C*dqr + g + F
    
    q1 = q(1); q2 = q(2);
    dq1 = dq(1); dq2 = dq(2);
    dqr1 = dqr(1); dqr2 = dqr(2);
    ddqr1 = ddqr(1); ddqr2 = ddqr(2);
    
    c1 = cos(q1); c2 = cos(q2); s2 = sin(q2); c12 = cos(q1+q2);
    
    % t1: coeff di ddqr1
    Y11 = ddqr1;
    % t2: coeff di ddqr2
    Y12 = ddqr2;
    % t3: Termini di inerzia accoppiata e Coriolis
    Y13 = 2*c2*ddqr1 + c2*ddqr2 - 2*s2*dq2*dqr1 - s2*dq2*dqr2;
    % t4: 0
    Y14 = 0;
    % t5: c1 (Gravità link 1)
    Y15 = c1;
    % t6: c12 (Gravità link 2)
    Y16 = c12;
    % f1: dqr1 (Attrito viscoso giunto 1)
    Y17 = dqr1; 
    % f2: 0
    Y18 = 0;
    
    Y21 = 0;
    Y22 = ddqr1;
    Y23 = c2*ddqr1 + s2*dq1*dqr1;
    Y24 = ddqr2;
    Y25 = 0;
    Y26 = c12;
    Y27 = 0;
    Y28 = dqr2;
    
    Y = [Y11, Y12, Y13, Y14, Y15, Y16, Y17, Y18;
         Y21, Y22, Y23, Y24, Y25, Y26, Y27, Y28];
end