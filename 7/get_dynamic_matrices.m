function [B, C, g, F] = get_dynamic_matrices(q, dq)
    global theta
    t1=theta(1); t2=theta(2); t3=theta(3); 
    t4=theta(4); t5=theta(5); t6=theta(6);
    
    c1 = cos(q(1));
    c2 = cos(q(2));
    s2 = sin(q(2));
    c12 = cos(q(1)+q(2));
    
    B = [t1 + 2*t3*c2, t2 + t3*c2;
         t2 + t3*c2,   t4];
         
    C = [-2*t3*dq(2)*s2, -t3*dq(2)*s2;
              t3*dq(1)*s2,    0];
    
    g = [t5*c1 + t6*c12;
         t6*c12];
         
    F = [2*dq(1); 2*dq(2)];
end