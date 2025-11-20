% Questa funzione disegna i grafici della simulazione
function plot_state(x_real, x_hat, t, err)
    graphics_toolkit("gnuplot"); # fix per i grafici

    % Plot confronto reale vs stimato
    figure(1);
    subplot(2, 2, 1);
    plot(t, x_real(:, 1), 'b', t, x_hat(:, 1), 'b--');
    title('Posizione (x)');
    legend('Reale', 'Stimato');
    grid on;

    subplot(2, 2, 2);
    plot(t, x_real(:, 2), 'r', t, x_hat(:, 2), 'r--');
    title('Velocità (x\_dot)');
    legend('Reale', 'Stimato');
    grid on;

    subplot(2, 2, 3);
    plot(t, x_real(:, 3), 'g', t, x_hat(:, 3), 'g--');
    title('Angolo (theta)');
    legend('Reale', 'Stimato');
    grid on;

    subplot(2, 2, 4);
    plot(t, x_real(:, 4), 'k', t, x_hat(:, 4), 'k--');
    title('Vel. Angolare (theta\_dot)');
    legend('Reale', 'Stimato');
    grid on;

    % Plot errore di stima
    figure(2);
    plot(t, err(:, 1), t, err(:, 2), t, err(:, 3), t, err(:, 4));
    title('Errore di Stima (e = x - x_hat)');
    xlabel('Tempo (s)');
    ylabel('Valore');
    legend('e(x)', 'e(x\_dot)', 'e(theta)', 'e(theta\_dot)');
    grid on;
end