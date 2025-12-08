function [dydt, u, x_d] = system_dynamics(t, y, type)
    global a_true lambda gamma

    x = y(1);      % Stato attuale
    a_hat = y(2);  % Stima attuale del parametro

    % Definizione Traiettoria Desiderata x_d(t) e sua derivata dx_d(t)
    if type == 1
        % Stabilizzazione
        x_d = 0;
        dx_d = 0;
    else
        % Inseguimento sinusoide
        x_d = sin(t);
        dx_d = cos(t);
    end

    % Calcolo Errore
    e = x - x_d;

    % Legge di Controllo (Certainty Equivalence)
    u = -a_hat * x + dx_d - lambda * e;

    % Dinamica del sistema
    dxdt = a_true * x + u;

    % Legge di adattamento
    da_hat_dt = gamma * x * e;
    dydt = [dxdt; da_hat_dt];
end