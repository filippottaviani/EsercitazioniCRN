clear;
clc;
close all;

pkg load control;

addpath('1', '2', 'funzioni')

% Parametri del sistema
M = 2.0;    % Massa del carrello [kg]
m = 0.1;    % Massa del pendolo [kg]
l = 0.5;    % Lunghezza del pendolo [m]
g = 9.81;   % Accelerazione di gravità [m/s^2]

% Tempo per l'integrazione di P_inf
T_horizon = 10

% Definizione delle modello linearizzato
A = [0, 1, 0, 0;
     0, 0, -m*g/M, 0;
     0, 0, 0, 1;
     0, 0, (M+m)*g/(M*l), 0];

B = [0;
     1/M;
     0;
     1/(M*l)];

C = [1, 0, 0, 0;
      0, 0, 1, 0];

D = zeros(size(C,1), size(B,2));

% (A,B) deve essere controllabile
if is_controllable(A, B)
    disp('La coppia (A, B) è controllabile')
else
    error('ARE non risolvibile: la coppia (A, B) non è controllabile!');
end

% (A, C) deve essere osservabile
if is_observable(A, C)
    disp('La coppia (A, C) è osservabile')
else
    error('ARE non risolvibile: la coppia (A, C) non è osservabile!');
end

% Progetto del regolatore LQR
Q_reg = diag([10, 1, 100, 1]); % Pesi sugli stati: [pos, v_pos, theta, v_theta]
R_reg = 0.1;                   % Peso sull'ingresso di controllo

K_fun = lqr(A, B, Q_reg, R_reg);
P_inf_reg = solve_ARE_through_DRE(A, B, Q_reg, R_reg, T_horizon);
K_cal = inv(R_reg) * B' * P_inf_reg;
disp('\nGuadagno del controllore K:\n');
disp('Guadagno K della funzione lqr');
disp(K_fun);
disp('Guadagno K calcolato dalla mia ARE');
disp(K_cal);
K = K_cal

% Progetto dell'osservatore dello stato
Q_obs = diag([100, 100, 100, 100]); % Rumore di processo fittizio
R_obs = diag([1, 1]);               % Rumore di misura fittizio (su pos e angolo)

% Calcolo il guadagno dell'osservatore per dualità
L_fun = lqr(A', C', Q_obs, R_obs)';
P_inf_obs = solve_ARE_through_DRE(A', C', Q_obs, R_obs, T_horizon);
L_cal = (inv(R_obs) * C * P_inf_obs)';
disp('Guadagno dell osservatore L:\n');
disp('Guadagno L della funzione lqr');
disp(L_fun);
disp('Guadagno L calcolato dalla mia ARE');
disp(L_cal);
L = L_cal

% Simulazione del sistema a ciclo chiuso
t_span = 0:0.01:10;

% Condizione iniziale
x0_sys = [1; 0; 0.3; 0]; 
x0_obs = [0; 0; 0; 0];  
x0_total = [x0_sys; x0_obs];

% Definizione della dinamica completa
dynamics = @(t, z) closed_loop_dynamics(t, z, A, B, C, K, L);

[t, z] = ode45(dynamics, t_span, x0_total);

% Estrazione stati
x_real = z(:, 1:4); % Stati veri
x_hat = z(:, 5:8); % Stati stimati

% Plot dello stato
plot_state(x_real, x_hat, t)
