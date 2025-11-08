function [P_sol, t] = DRE(A, B, Q, R, P_tf, T)
    % Vettorizzo la condizione finale P(T)
    P_tf_vec = P_tf(:);

    % Definisco l'intervallo di integrazione all'indietro: [T, 0]
    tspan = [T, 0];

    % Integro all'indietro 
    % ode45 chiama la funzione 'compute_DRE' ad ogni passo
    [t_backward, P_vec_backward] = ode45(@(t, P_vec) compute_DRE(P_vec, A, B, Q, R, n), tspan, P_tf_vec);
    
    % Riordino i risultati in avanti nel tempo (da t=0 a t=T)
    t = flipud(t_backward);
    P_vec = flipud(P_vec_backward);

    % Converto i risultati da forma vettoriale (usata da ode45)
    % a forma matriciale (un array 3D)
    num_points = length(t);
    P_sol = zeros(n, n, num_points);
    for i = 1:num_points
        P_vec_i = P_vec(i, :)';
        P_sol(:, :, i) = reshape(P_vec_i, n, n); % Ricostruisco la matrice n x n
    end
end