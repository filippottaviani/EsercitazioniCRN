function plot_res(x, y, xd, yd, e1, e2, e3, v_cmd, w_cmd, t, theta)
    graphics_toolkit("gnuplot"); % fix per i grafici

    % Traiettoria nel piano XY
    figure(1);
    plot(x, y, 'b', 'LineWidth', 2);
    hold on;
    plot(xd, yd, 'r', 'LineWidth', 2);

    % Disegna il robot all'inizio e alla fine
    draw_robot(x(1), y(1), theta(1), 'g');
    draw_robot(x(end), y(end), theta(end), 'k');
    grid on;
    axis equal;
    title('Inseguimento della traiettoria nel piano');
    legend('Traiettoria reale', 'Riferimento', 'Inizio', 'Fine');
    xlabel('X [m]');
    ylabel('Y [m]');

    % Errori nel tempo
    figure(2);
    subplot(1,3,1);
    plot(t, e1, 'LineWidth', 2);
    grid on;
    ylabel('e_y (Long)');
    xlabel('Tempo [s]');
    title('Errore lungo x');
    
    subplot(1,3,2);
    plot(t, e2, 'LineWidth', 2);
    grid on;
    ylabel('e_x');
    xlabel('Tempo [s]');
    title('Errore lungo y');

    subplot(1,3,3);
    plot(t, e3, 'LineWidth', 2);
    grid on;
    ylabel('e_\theta (Ang)');
    xlabel('Tempo [s]');
    title('Errore angolare');

    % Ingressi di controllo
    figure(3);
    subplot(1,2,1);
    plot(t, v_cmd, 'm', 'LineWidth', 2);
    grid on;
    xlabel('Tempo [s]');
    ylabel('v [m/s]');
    title('Ingresso di controllo v');

    subplot(1,2,2);
    plot(t, w_cmd, 'm', 'LineWidth', 2);
    grid on;
    ylabel('\omega [rad/s]');
    xlabel('Tempo [s]');
    title('Ingresso di controllo \omega');
end
