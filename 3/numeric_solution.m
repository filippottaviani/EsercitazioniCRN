function [t_num, x_num] = numeric_solution(fun_handle, t_span, x0)

    % Opzioni standard per il risolutore
    options = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
    disp('Avvio risolutore numerico ode45...');
    try
        % ode45 gestisce gli errori di "finite time escape"
        [t_num, x_num] = ode45(fun_handle, t_span, x0, options);
        disp('Soluzione numerica calcolata.');
    catch ME
        disp(['Errore durante ode45: ', ME.message]);
        disp('La simulazione potrebbe essersi interrotta.');
        t_num = [];
        x_num = [];
    end
end