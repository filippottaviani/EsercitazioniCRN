function plot_state_or(t, y_hist, y_des_hist, err_hist, w_hist, w_hat_hist)
    graphics_toolkit("gnuplot"); % fix per i grafici
    figure('Name', 'Regolazione dall uscita');

    subplot(1,3,1);
    plot(t, y_hist(:,1), 'b', 'LineWidth', 1.5);
    hold on;
    plot(t, y_des_hist(:,1), 'r--', 'LineWidth', 1.5);
    title('Regolazione posizione carrello x_p');
    legend('Reale', 'Riferimento');
    grid on;

    subplot(1,3,2);
    plot(t, y_hist(:,2), 'b', 'LineWidth', 1.5);
    hold on;
    plot(t, y_des_hist(:,2), 'r--', 'LineWidth', 1.5);
    title('Regolazione angolo \theta_p = 0');
    grid on;

    subplot(1,3,3);
    plot(t, err_hist(:,1), 'k', 'LineWidth', 1.5); 
    title('Errore di regolazione (posizione)');
    xlabel('Tempo [s]');
    grid on;

    figure('Name', 'Stima esosistema');
    plot(t, w_hist(:,1), 'b');
    hold on;
    plot(t, w_hat_hist(:,1), 'r--');
    title('Stima stato w_1 (riferimento)');
    legend('Vero', 'Stimato');
    grid on;
end