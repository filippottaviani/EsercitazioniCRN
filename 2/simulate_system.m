function simulate_system(A, B, C, K, L)
    % Ora simuliamo il sistema combinato (8 stati).
    A_cc = [ A, -B*K;
            L*C, A - B*K - L*C];

    % Non ci sono ingressi esterni
    B_cc = zeros(8, 1);

    % Definiamo le uscite che vogliamo visualizzare:
    % 1-4: Stati reali (x)
    % 5-8: Stati stimati (x_hat)
    C_cc = [eye(4),  zeros(4,4);
            zeros(4,4), eye(4)];

    D_cc = zeros(8, 1);

    % Creiamo il sistema completo
    sys_cc = ss(A_cc, B_cc, C_cc, D_cc);

    % Condizioni iniziali
    x_real_0 = [
        0.5;   % Carrello a 0.5m
        0;     % Carrello fermo
        0.2;   % Pendolo inclinato di 0.2 rad (circa 11.5 gradi)
        0];    % Pendolo fermo

    x_hat_0 = [0; 0; 0; 0]; % L'osservatore "pensa" che tutto sia a zero

    x0 = [x_real_0; x_hat_0]; % Vettore di stato iniziale (8x1)

    % Simulazione
    t_sim = 0:0.01:10; % 10 secondi
    [y_sim, t] = initial(sys_cc, x0, t_sim);

    % Estrazione dei risultati
    x_real = y_sim(:, 1:4);
    x_hat = y_sim(:, 5:8);
    err = x_real - x_hat; % Errore di stima

    % Plot dei Risultati
    plot_state(x_real, x_hat, t, err)
end