function plot_res(y1, y2, xd1, xd2, t1, t2, u1, u2, a_true)
    % Stabilizzazione
    figure(1);
    subplot(3,1,1);
    plot(t1, y1(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t1, xd1, 'k-', 'LineWidth', 1.5);
    grid on;
    title(' Stabilizzazione - Stato x(t)');
    legend('x(t)', 'x_d(t)=0');
    ylabel('Stato');

    subplot(3,1,2);
    plot(t1, y1(:,2), 'g', 'LineWidth', 2);
    hold on;
    plot([min(t1) max(t1)], [a_true a_true], 'k-', 'LineWidth', 1.5);
    grid on;
    title('Stima del parametro \alpha');
    legend('Stima \alpha(t)', 'Vero \alpha'); 
    ylabel('\alpha');

    subplot(3,1,3);
    plot(t1, u1, 'm', 'LineWidth', 1.5);
    grid on; 
    title('Ingresso di Controllo u(t)');
    xlabel('Tempo [s]');
    ylabel('u');

    % Inseguimento
    figure(2);
    subplot(3,1,1);
    plot(t2, y2(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t2, xd2, 'k-', 'LineWidth', 1.5);
    grid on; 
    title('Inseguimento - Stato x(t)');
    legend('x(t)', 'x_d(t)=sin(t)');
    ylabel('Stato');

    subplot(3,1,2);
    plot(t2, y2(:,2), 'g', 'LineWidth', 2);
    hold on;
    plot([min(t2) max(t2)], [a_true a_true], 'k-', 'LineWidth', 1.5);
    grid on;
    title('Stima del parametro \alpha');
    legend('Stima \alpha(t)', 'Vero \alpha');
    ylabel('\alpha');

    subplot(3,1,3);
    plot(t2, u2, 'm', 'LineWidth', 1.5);
    grid on;
    title('Ingresso di Controllo u(t)');
    xlabel('Tempo [s]');
    ylabel('u');
endfunction