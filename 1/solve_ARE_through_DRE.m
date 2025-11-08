function P_inf = solve_ARE_through_DRE(A, B, R, Q)
    [n, ~] = size(A);

    % Impostiamo la condizione finale P(T) = 0
    P_tf = zeros(n);

    % Scegliamo un orizzonte temporale T sufficientemente lungo
    T_horizon = 100;

    % Chiamiamo la funzione DRE esistente
    [~, P_sol] = evalc('solve_DRE(A, B, Q, R, P_tf, T_horizon)');

    % La soluzione dell'ARE è P(0)
    P_inf = P_sol(:,:,1);
end