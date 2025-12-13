function plot_res_traj(t, q, dq, q_des, dq_des)
    graphics_toolkit("gnuplot"); % fix per i grafici
    % Calcolo dell'errore
    e_q = q_des - q;
    e_dq = dq_des -dq;

    figure('Name', 'Inseguimento traiettoria giunti');

    % Posizioni
    subplot(1,2,1);
    plot(t, q(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t, q_des(:,1), 'k-.', 'LineWidth', 1.5);
    plot(t, q(:,2), 'r', 'LineWidth', 2);
    plot(t, q_des(:,2), 'k-.', 'LineWidth', 1.5);
    grid on;
    xlabel('Tempo [s]');
    ylabel('Posizione [rad]');
    legend('q1', 'q1_{ref}', 'q2', 'q2_{ref}');
    title('Inseguimento di posizione');

    % Velocità
    subplot(1,2,2);
    plot(t, dq(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t, dq_des(:,1), 'k-.', 'LineWidth', 1.5);
    plot(t, dq(:,2), 'r', 'LineWidth', 2);
    plot(t, dq_des(:,2), 'k-.', 'LineWidth', 1.5);
    grid on; 
    xlabel('Tempo [s]');
    ylabel('Velocità [rad/s]');
    legend('dq1', 'dq2');
    title('Inseguimento di velocità');

    % Errore posizione
    figure('Name', 'Errori di inseguimento');
    subplot(1,2,1);
    plot(t, e_q(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t, e_q(:,2), 'r', 'LineWidth', 2);
    grid on;
    ylabel('Errore [rad]');
    xlabel('Tempo [s]');
    legend('e_{q1}', 'e_{q2}');
    title('Errore in posizione');

    % Errore velocità
    subplot(1,2,2);
    plot(t, e_dq(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t, e_dq(:,2), 'r', 'LineWidth', 2);
    grid on;
    ylabel('Errore [rad/s]');
    xlabel('Tempo [s]');
    legend('e_{dq1}', 'e_{dq2}');
    title('Errore in velocità');

end