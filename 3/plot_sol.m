% Funzione per plottare le soluzioni numeriche e analitiche
function plot_soluzioni(fig_num, titolo, t_num, x_num, t_an, x_an)

    % Genero un grafico di confronto tra soluzione numerica e analitica.
    figure(fig_num);
    plot(t_num, x_num, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4); % Numerica
    hold on;
    plot(t_an, x_an, 'r-', 'LineWidth', 2); % Analitica
    title(titolo);
    xlabel('Tempo (t)');
    ylabel('Stato (x)');
    legend('Soluzione Numerica (ode45)', 'Soluzione Analitica');
    grid on;
    hold off;
end