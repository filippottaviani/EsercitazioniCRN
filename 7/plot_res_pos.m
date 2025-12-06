function plot_res_pos(y, target_pos, t, geom);
    % Estrazione coordinate target
    x_des = target_pos(1);
    y_des = target_pos(2);
    T_sim = t(end);

    q1 = y(:,1);
    q2 = y(:,2);
    x_traj = zeros(length(t), 2);

    % Ricostruzione traiettoria
    for i=1:length(t)
        [pos, ~] = get_kinematics(y(i,1:2)');
        x_traj(i,:) = pos';
    end

    figure('Name', 'Controllo Spazio Operativo');
    subplot(1,2,1);
    plot(t, x_traj(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t, x_traj(:,2), 'r', 'LineWidth', 2);
    plot([0 T_sim], [x_des x_des], 'b--'); 
    plot([0 T_sim], [y_des y_des], 'r--');
    grid on;
    legend('x', 'y', 'x_{target}', 'y_{target}');
    xlabel('Tempo [s]');
    ylabel('Posizione [m]');
    title('Convergenza alle coordinate cartesiane');

    subplot(1,2,2);
    q_end = y(end, 1:2);
    p0 = [0; 0];
    p1 = [geom.l1*cos(q_end(1)); geom.l1*sin(q_end(1))];
    p2 = p1 + [geom.l2*cos(sum(q_end)); geom.l2*sin(sum(q_end))];
    plot([p0(1) p1(1) p2(1)], [p0(2) p1(2) p2(2)], 'k-o', 'LineWidth', 2);
    hold on;
    plot(x_des, y_des, 'rx', 'MarkerSize', 10, 'LineWidth', 3);
    axis equal;
    grid on;
    xlim([-1.2 1.2]);
    ylim([-1.2 1.2]);
    title('Configurazione Finale vs Target');
end