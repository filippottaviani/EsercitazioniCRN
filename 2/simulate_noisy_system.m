function simulate_system(A, B, C, K, L, B_w, W, V)
    % Matrice A ciclo chiuso
    A_cc = [ A,       -B*K;
             L*C,     A - B*K - L*C ];

    % Matrice B ciclo chiuso
    B_cc = [ B_w,       zeros(4, 2);
             zeros(4,1), L ];

    % Uscite da visualizzare
    C_cc = eye(8);
    D_cc = zeros(8, 3);

    sys_cc = ss(A_cc, B_cc, C_cc, D_cc);

    % Segnali di rumore
    dt = 0.01;
    t_sim = 0:dt:10;
    N = length(t_sim);
    
    % Rumore di Processo w ~ N(0, W)
    w_sig = sqrt(W) * randn(N, 1);
    
    % Rumore di Misura v ~ N(0, V)
    v_sig = (sqrt(V) * randn(2, N))'; 
    
    % Vettore ingressi complessivo u_noise = [w, v1, v2]
    u_noise = [w_sig, v_sig];

    % Il sistema parte da una condizione diversa da quella che l'osservatore crede
    x_real_0 = [0.5; 0; 0.2; 0]; 
    x_hat_0  = [0; 0; 0; 0];
    x0 = [x_real_0; x_hat_0];

    % Uso lsim per simulare la risposta temporale con ingressi arbitrari (rumore)
    [y_sim, t] = lsim(sys_cc, u_noise, t_sim, x0);

    % Estrazione risultati
    x_real = y_sim(:, 1:4);
    x_hat  = y_sim(:, 5:8);
    err    = x_real - x_hat;

    % Plot
    plot_state(x_real, x_hat, t, err);
end