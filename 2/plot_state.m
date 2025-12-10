function plot_state(x_real, x_hat, t)
    graphics_toolkit("gnuplot"); # fix per i grafici
    figure('Name', 'Regolazione dall uscita del pendolo linearizzato');

    subplot(1,2,1);
    plot(t, x_real(:,1), 'b', 'LineWidth', 1.5); 
    hold on;
    plot(t, x_real(:,3), 'r', 'LineWidth', 1.5);
    title('Stati del sistema');
    xlabel('Tempo [s]');
    ylabel('Stato');
    legend('x_{c}', '\theta_p');
    grid on;

    subplot(1,2,2);
    plot(t, x_real(:,3) - x_hat(:,3), 'k', 'LineWidth', 1.5);
    title('Errore di stima angolo');
    xlabel('Tempo [s]');
    ylabel('Errore [rad]');
    grid on;
end