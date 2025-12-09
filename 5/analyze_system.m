function analyze_system(fig_num, title_str, J_func, P_equilibri)
    figure(fig_num);
    clf; % Pulisce la figura
    title(title_str);
    hold on;
    disp(' ');
    disp(['Analisi: ', title_str]);

    for i = 1:size(P_equilibri, 1)
        P_num = P_equilibri(i, :);
        J_P = J_func(P_num);
        poli_P = eig(J_P);

        disp(['Equilibrio P', num2str(i), ' = (', num2str(P_num(1)), ', ', num2str(P_num(2)), ')']);
        disp('  Jacobiano J(P):');
        disp(J_P);
        disp('  Autovalori (Poli):');
        disp(poli_P');

        % Classificazione
        if all(real(poli_P) < 0)
            disp('  -> STABILE (Nodo/Fuoco Stabile)');
            plot(P_num(1), P_num(2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
            text(P_num(1)+0.1, P_num(2), ['P', num2str(i), ' (Stabile)'], 'Color', 'g', 'FontWeight', 'bold');
        elseif any(real(poli_P) > 0) && any(real(poli_P) < 0)
            disp('  -> INSTABILE (Punto di Sella)');
            plot(P_num(1), P_num(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
            text(P_num(1)+0.1, P_num(2), ['P', num2str(i), ' (Sella)'], 'Color', 'r', 'FontWeight', 'bold');
        else
            disp('  -> INSTABILE (altri casi)');
            plot(P_num(1), P_num(2), 'rx', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
            text(P_num(1)+0.1, P_num(2), ['P', num2str(i), ' (Instabile)'], 'Color', 'r', 'FontWeight', 'bold');
        end
    end
end