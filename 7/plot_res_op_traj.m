function plot_res_op_traj(t, x_real, x_des, e_x)
    graphics_toolkit("gnuplot"); % fix per i grafici
    
    figure('Name', 'Inseguimento traiettoria nello spazio operativo');
    
    % Traiettoria
    subplot(1,2,1);
    plot(x_real(:,1), x_real(:,2), 'g', 'LineWidth', 2);
    hold on;
    plot(x_des(:,1), x_des(:,2), 'k--', 'LineWidth', 2);
    axis equal;
    grid on;
    legend('Reale', 'Riferimento');
    xlabel('X [m]'); ylabel('Y [m]');
    title('Traiettoria cartesiana (cerchio)');
    
    % Errori
    subplot(1,2,2);
    plot(t, e_x(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t, e_x(:,2), 'r', 'LineWidth', 2);
    grid on; 
    ylabel('Errore [m]');
    xlabel('Tempo [s]');
    legend('e_x', 'e_y');
    title('Errore cartesiano');
end