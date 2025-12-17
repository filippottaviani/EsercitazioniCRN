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

% (A, C) deve essere rilevabile
if is_detectable(A, C)
    disp('La coppia (A, C) è rilevabile')
else
    error('ARE non risolvibile: la coppia (A, C) non è rilevabile!');
end

% FILTRO DI KALMAN-BUCY

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


# REGOLAZIONE DALL'USCITA
omega = 1.0; 
Amp = 0.5; % Ampiezza riferimento

% Matrice dinamica dell'esosistema S (3x3)
S = [0, omega, 0;
    -omega, 0, 0;
     0, 0, 0];

% Matrice di disturbo sull'ingresso P
P_dist = zeros(4, 3);
P_dist(2, 3) = 1/M;  % w3 agisce come una forza costante sul carrello

% Matrice Qw per definire l'errore e = y_d - y
Qw = [-1, 0, 0;  % y1_des = w1
       0, 0, 0]; % y2_des = 0 (angolo equilibrato)

% Verifica condizioni H1
disp('Autovalori Esosistema S:');
disp(eig(S));

% Risoluzione equazioni del regolatore
[Pi, Gamma] = solve_regulation_sylvester(A, B, P_dist, S, C, Qw);

disp('Matrice Pi:'); disp(Pi);
disp('Matrice Gamma:'); disp(Gamma);

% Progetto dell'osservatore esteso
n = size(A,1);
nw = size(S,1);

Ae = [A, P_dist; zeros(nw, n), S];
Ce = [C, Qw];

% Verifico H3: rilevabilità del sistema esteso
if is_detectable(Ae, Ce)
    disp('Il sistema esteso è rilevabile.')
else
    error('Il sistema esteso non è rilevabile.');
end

% Progetto guadagno L_obs per il sistema esteso
Q_obs_ext = diag([100*ones(1,n), 1000*ones(1,nw)]); % Alta fiducia sul modello, incertezza su w
R_obs_ext = diag([0.1, 0.1]); 
L_obs_ext = lqr(Ae', Ce', Q_obs_ext, R_obs_ext)';

disp('Guadagno Osservatore Esteso L_obs_ext:');
disp(L_obs_ext);

% Condizioni iniziali
w0 = [Amp; 0; 0];       % Stato esosistema (generazione sinusoide)
xe0_hat = zeros(n+nw, 1); % Stima iniziale (vuota)

% Stato totale per ode45
z0 = [x0_sys; w0; xe0_hat];
dynamics_fun = @(t, z) output_regulation_dynamics(t, z, A, B, P_dist, C, Qw, S, K, Pi, Gamma, L_obs_ext);
[t, z] = ode45(dynamics_fun, t_span, z0);

% Estrazione dati
x_hist = z(:, 1:4);
w_hist = z(:, 5:7);
xe_hat_hist = z(:, 8:end);
x_hat_hist = xe_hat_hist(:, 1:4);
w_hat_hist = xe_hat_hist(:, 5:end);

% Calcolo segnali d'interesse
y_hist = (C * x_hist')';
y_des_hist = (-Qw * w_hist')'; % y_des derivato da Qw*w = -y_des
u_hist = zeros(length(t), 1);
err_hist = zeros(length(t), 2);

for i = 1:length(t)
    % Legge di controllo: u = K(x_hat - Pi*w_hat) + Gamma*w_hat
    x_h = x_hat_hist(i,:)';
    w_h = w_hat_hist(i,:)';
    u_hist(i) = -K * x_h + (Gamma - K*Pi) * w_h;
    err_hist(i, :) = (C * x_hist(i,:)' + Qw * w_hist(i,:)')'; 
end

% Plot
plot_state_or(t, y_hist, y_des_hist, err_hist,  w_hist, w_hat_hist)