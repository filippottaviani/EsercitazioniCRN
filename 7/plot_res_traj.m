function plot_res_traj(t, q, dq, q_des, e_q)
    figure('Name', 'Inseguimento traiettoria giunti');

    % Posizioni
    subplot(3,1,1);
    plot(t, q(:,1), 'b', 'LineWidth', 1.5);
    hold on;
    plot(t, q_des(:,1), 'b--', 'LineWidth', 1);
    plot(t, q(:,2), 'r', 'LineWidth', 1.5);
    plot(t, q_des(:,2), 'r--', 'LineWidth', 1);
    grid on; ylabel('Posizione [rad]');
    legend('q1', 'q1_{ref}', 'q2', 'q2_{ref}');
    title('Inseguimento Traiettoria (Computed Torque)');

    % Velocità
    subplot(3,1,2);
    plot(t, dq(:,1), 'b', t, dq(:,2), 'r');
    grid on; ylabel('Velocità [rad/s]');
    legend('dq1', 'dq2');

    % Errori
    subplot(3,1,3);
    plot(t, e_q(:,1), 'b', 'LineWidth', 1.5);
    hold on;
    plot(t, e_q(:,2), 'r', 'LineWidth', 1.5);
    grid on;
    ylabel('Errore [rad]');
    xlabel('Tempo [s]');
    legend('e_{q1}', 'e_{q2}');
    title('Errore di Inseguimento');
end