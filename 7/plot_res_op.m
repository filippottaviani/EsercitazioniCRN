function plot_res_op(y, target_pos, t);
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
end