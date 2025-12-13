function plot_res_op(mode, y, target_pos, t);
    graphics_toolkit("gnuplot"); % fix per i grafici
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

    if mode == 0
        figure('Name', 'Controllo nello spazio operativo');
    elseif mode == 1
        figure('Name', 'Controllo nello spazio operativo con guadagni tuned');
    else
        error('Modalita del plot inesistente')
    end
    plot(t, x_traj(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t, x_traj(:,2), 'r', 'LineWidth', 2);
    plot([0 T_sim], [x_des x_des], 'b--'); 
    plot([0 T_sim], [y_des y_des], 'r--');
    grid on;
    legend('x', 'y', 'x_{target}', 'y_{target}');
    xlabel('Tempo [s]');
    ylabel('Posizione [m]');
    
    if mode == 0
        title('Convergenza alle coordinate cartesiane');
    elseif mode == 1
        title('Convergenza alle coordinate cartesiane con guadagni tuned');
    else
        error('Modalita del plot inesistente')
    end