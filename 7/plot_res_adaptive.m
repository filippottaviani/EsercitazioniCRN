function plot_res_adaptive(t, q, dq, theta_hist, q_des, theta_real)
    graphics_toolkit("gnuplot"); # fix per i grafici

    % Calcolo errore
    e_q = q_des - q;
    
    figure('Name', 'Controllo Adattativo');
    
    % Errore di inseguimento
    subplot(2,1,1);
    plot(t, e_q(:,1), 'b', 'LineWidth', 1.5);
    hold on;
    plot(t, e_q(:,2), 'r', 'LineWidth', 1.5);
    grid on;
    ylabel('Errore [rad]');
    xlabel('Tempo [s]');
    legend('e_{q1}', 'e_{q2}');
    title('Errore di Inseguimento (Adattativo)');
    
    % Stima dei parametri
    subplot(2,1,2);
    colors = lines(8);
    labels = {'\theta_1', '\theta_2', '\theta_3', '\theta_4', '\theta_5', '\theta_6', 'F_1', 'F_2'};
    
    % Plot parametri stimati vs reali
    hold on;
    t_start = t(1);
    t_end = t(end);
    for i=1:8
        plot(t, theta_hist(:,i), 'Color', colors(i,:), 'LineWidth', 1.5, 'DisplayName', ['Est. ' labels{i}]);
        plot([t_start t_end], [theta_real(i) theta_real(i)], '--', 'Color', colors(i,:), 'LineWidth', 1, 'HandleVisibility', 'off');
    end
    grid on; ylabel('Valore Parametro');
    xlabel('Tempo [s]');
    title('Convergenza Parametri (\theta)');
    legend('show', 'Location', 'eastoutside');
end