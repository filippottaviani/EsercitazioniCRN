function plot_phase_portrait(fig_num, f_handle, condizioni_iniziali)
    graphics_toolkit("gnuplot"); # fix per i grafici
    figure(fig_num);
    
    % Creo la griglia per il campo vettoriale
    [X1_grid, X2_grid] = meshgrid(-2:0.2:2, -2:0.2:2);
    u = zeros(size(X1_grid));
    v = zeros(size(X2_grid));
    
    for i = 1:numel(X1_grid)
        dxdt = f_handle(0, [X1_grid(i); X2_grid(i)]);
        u(i) = dxdt(1);
        v(i) = dxdt(2);
    end
    
    % Normalizzo le frecce per una migliore visualizzazione
    norme = sqrt(u.^2 + v.^2);
    norme(norme == 0) = 1;
    quiver(X1_grid, X2_grid, u./norme, v./norme, 'AutoScaleFactor', 0.5, 'Color', [0.8 0.8 0.8]);

    % Simulo e grafico le traiettorie
    t_span = [0 10];
    for i = 1:size(condizioni_iniziali, 1)
        [t, x_sim] = ode45(f_handle, t_span, condizioni_iniziali(i,:));
        plot(x_sim(:, 1), x_sim(:, 2), 'b-', 'LineWidth', 1.5);
        plot(x_sim(1,1), x_sim(1,2), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 5);
    end
    
    xlabel('x1 (Posizione)');
    ylabel('x2 (Velocità)');
    axis([-2 2 -2 2]);
    grid on;
    hold off;
end