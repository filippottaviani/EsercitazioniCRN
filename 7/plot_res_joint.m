function plot_res_joint(t_j, y_j, q_des, T_sim)
    figure('Name', 'Scenario A: Spazio Giunti');
    plot(t_j, y_j(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t_j, y_j(:,2), 'r', 'LineWidth', 2);
    plot([0 T_sim], [q_des(1) q_des(1)], 'b--');
    plot([0 T_sim], [q_des(2) q_des(2)], 'r--');
    grid on;
    ylabel('Angoli [rad]');
    legend('q1', 'q2', 'q1_{target}', 'q2_{target}');
    title('Regolazione ai Giunti (PD + G)');
end