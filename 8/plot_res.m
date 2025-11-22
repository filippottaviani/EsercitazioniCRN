function plot_res(x, y, xd, yd, e1, e2, e3, v_cmd, w_cmd)
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
    title('Traiettoria nel Piano XY');
    legend('Robot', 'Riferimento', 'Start', 'End');
    xlabel('X [m]');
    ylabel('Y [m]');

    % Errori nel tempo
    figure(2);
    subplot(3,1,1);
    plot(t, e1, 'LineWidth', 2);
    grid on;
    ylabel('e_1 (Long)');
    title('Errori di Inseguimento (Body Frame)');
    subplot(3,1,2);
    plot(t, e2, 'LineWidth', 2);
    grid on;
    ylabel('e_2 (Lat)');
    subplot(3,1,3);
    plot(t, e3, 'LineWidth', 2);
    grid on;
    ylabel('e_3 (Ang)');
    xlabel('Tempo [s]');

    % Ingressi di Controllo
    figure(3);
    subplot(2,1,1);
    plot(t, v_cmd, 'm', 'LineWidth', 1.5);
    grid on;
    ylabel('v [m/s]');
    title('Ingressi di Controllo');
    subplot(2,1,2);
    plot(t, w_cmd, 'm', 'LineWidth', 1.5);
    grid on;
    ylabel('\omega [rad/s]');
    xlabel('Tempo [s]');
end
