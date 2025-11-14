function analyze_equilibrium_point(J, x1, x2, P_num)
    J_P = double(subs(J, [x1, x2], P_num'));
    [V, D] = eig(J_P);
    poli_P = diag(D);

    disp('Equilibrio P = :' + P_num);
    disp('  Jacobiano J(P2):');
    disp(J_P);
    disp('  Autovalori (Poli):'); 
    disp(poli_P');

    % Classificazione
    if all(real(poli_P) < 0)
        disp('  -> STABILE (Nodo/Fuoco Stabile)');
    elseif all(real(poli_P) > 0)
        disp('  -> INSTABILE (Nodo/Fuoco Instabile)');
    elseif any(real(poli_P) > 0) && any(real(poli_P) < 0)
        disp('  -> INSTABILE (Punto di Sella)');
    else
        disp('  -> Caso critico)');
    end
    disp(' ');
endfunction