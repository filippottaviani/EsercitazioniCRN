function plot_vector_field(R, L, C, alpha, beta, P1_num, P2_num, P3_num, t, fun_diodo)
    % Creiamo la griglia per il campo vettoriale (quiver plot)
    [X1_grid, X2_grid] = meshgrid(-3:0.3:3, -3:0.3:3);
    u = -R/L * X1_grid + 1/L * X2_grid;
    v = -1/C * X1_grid + alpha/C * X2_grid - beta/C * X2_grid.^3;

    % Normalizziamo le frecce per una migliore visualizzazione
    u_norm = u ./ sqrt(u.^2 + v.^2);
    v_norm = v ./ sqrt(v.^2 + v.^2);

    figure(1);
    hold on;

    % Plot del campo vettoriale
    quiver(X1_grid, X2_grid, u_norm, v_norm, 'Color', [0.8 0.8 0.8]);

    % Plot dei punti di equilibrio
    plot(P1_num(1), P1_num(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    text(P1_num(1)+0.1, P1_num(2), 'P1 (Sella)', 'Color', 'r');
    plot(P2_num(1), P2_num(2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
    text(P2_num(1)+0.1, P2_num(2), 'P2 (Nodo Stabile)', 'Color', 'g');
    plot(P3_num(1), P3_num(2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
    text(P3_num(1)+0.1, P3_num(2), 'P3 (Nodo Stabile)', 'Color', 'g');

    % 3. Plot di alcune traiettorie
    disp('Calcolo traiettorie di esempio...');
    t_span = [0 20];

    % Condizioni iniziali di esempio
    condizioni_iniziali = [
        0.1, 0.1;   % Vicino all'origine (P1)
        -0.1, -0.1;  % Vicino all'origine (P1)
        2.5, 2.5;   % Vicino a P2
        -2.5, -2.5;  % Vicino a P3
    ];

    for i = 1:size(condizioni_iniziali, 1)
        [t, x_sim] = ode45(fun_diodo, t_span, condizioni_iniziali(i,:));
        plot(x_sim(:, 1), x_sim(:, 2), 'b-', 'LineWidth', 1.5);

        % Plot del punto di partenza
        plot(x_sim(1,1), x_sim(1,2), 'bo', 'MarkerFaceColor', 'b');
    end

    % Impostazioni finali del grafico
    title('Ritratto di Fase - Diodo Tunnel');
    xlabel('x1 (Corrente I_L)');
    ylabel('x2 (Tensione V_C)');
    axis([-3 3 -3 3]);
    grid on;
    hold off;
end