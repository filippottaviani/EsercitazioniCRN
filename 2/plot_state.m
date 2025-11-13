% Questa funzione disegna i grafici della simulazione
function plot_state(x_real, x_hat, t, err)

    % Plot stati reali
    figure(1);
    subplot(2, 1, 1);
    plot(t, x_real(:, 1), 'b-', 'LineWidth', 1.5);
    hold on;
    plot(t, x_real(:, 3), 'r-', 'LineWidth', 1.5);
    title('Stati Reali: Posizione (x) e Angolo (theta)');
    xlabel('Tempo (s)');
    ylabel('Valore');
    legend('Posizione Carrello (x)', 'Angolo Pendolo (theta)');
    grid on;

    subplot(2, 1, 2);
    plot(t, x_real(:, 2), 'b--', 'LineWidth', 1.5);
    hold on;
    plot(t, x_real(:, 4), 'r--', 'LineWidth', 1.5);
    title('Stati Reali: Velocità (x\_dot) e Vel. Angolare (theta\_dot)');
    xlabel('Tempo (s)');
    ylabel('Valore');
    legend('Velocità Carrello (x\_dot)', 'Vel. Angolare (theta\_dot)');
    grid on;

    % Plot confronto reale vs stimato
    figure(2);
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
    figure(3);
    plot(t, err(:, 1), t, err(:, 2), t, err(:, 3), t, err(:, 4));
    title('Errore di Stima (e = x - x_hat)');
    xlabel('Tempo (s)');
    ylabel('Valore');
    legend('e(x)', 'e(x\_dot)', 'e(theta)', 'e(theta\_dot)');
    grid on;
    disp('Simulazione completata. I grafici mostrano i risultati.');
end