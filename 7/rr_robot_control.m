clear all;
close all;
clc;

addpath('7')

global theta geom

% Parametri dinamici
theta = [10.6125; 0.85; 2.25; 1.6; 80.9325; 14.7150];

% Parametri geometrici (Assunti per la cinematica)
geom.l1 = 0.5; % Lunghezza link 1 [m]
geom.l2 = 0.5; % Lunghezza link 2 [m]

%% CONTROLLO NELLO SPAZIO DEI GIUNTI
disp('\nRegolazione spazio giunti');

% Target: Vogliamo portare il robot in una configurazione specifica
q_des = [0; pi/2]; 

% Condizione iniziale (fermo in posizione diversa: braccio giù)
q0_joint = [-pi/2; 0; 0; 0]; 

% Simulazione
T_sim = 5;

% Chiamata a ode45 per risolvere la dinamica controllata ai giunti
[t_j, y_j] = ode45(@(t,y) robot_dynamics_joint(t, y, q_des), [0 T_sim], q0_joint);

plot_res_joint(t_j, y_j, q_des, T_sim)

%% CONTROLLO NELLO SPAZIO OPERATIVO
disp('\nRegolazione spazio operativo');

% Target in coordinate cartesiane (x, y)
x_des = 0.6; 
y_des = 0.4;
target_pos = [x_des; y_des];

% Condizione iniziale
q0_op = [-pi/2; 0; 0; 0]; 

% Chiamata a ode45 per risolvere la dinamica controllata nello spazio operativo
[t_op, y_op] = ode45(@(t,y) robot_dynamics_operational(t, y, target_pos), [0 T_sim], q0_op);

% Visualizzazione dei risultati
plot_res_op(y_op, target_pos, t_op);

%% CONTROLLO IN TRAIETTORIA NELLO SPAZIO DEI GIUNTI
disp('\nInseguimento di traiettorie nello spazio dei giunti con parametri noti');

% Definizione delle traiettorie desiderata
A_traj = [pi/4; pi/6];      % Ampiezze [rad]
w_traj = [1.0; 1.5];        % Frequenze [rad/s]

% Condizione iniziale
q0 = [0.5; 0.5];
dq0 = [1; 1];
x0 = [q0; dq0];

% Simulazione
T_sim = 5;
disp('Avvio simulazione Computed Torque...');
[t, y] = ode45(@(t,y) robot_dynamics_computed_torque(t, y, A_traj, w_traj), [0 T_sim], x0);

% Risultati
q = y(:, 1:2);
dq = y(:, 3:4);

% Ricostruzione riferimenti per il plot
q_des = zeros(length(t), 2);
dq_des = zeros(length(t), 2);
for i=1:length(t)
    q_des(i,:) = (A_traj .* sin(w_traj*t(i)))';
    dq_des(i,:) = (A_traj .* w_traj .* cos(w_traj*t(i)))';
end

% Plot
plot_res_traj(t, q, dq, q_des, dq_des)

%% CONTROLLO IN TRAIETTORIA NELLO SPAZIO OPERATIVO

%% CONTROLLO ADATTIVO
disp('Inseguimento adattativo (parametri ignoti)...');

% Parametri di attrito "reali"
F_real = [2; 2];

% Parametri Adattativi
Lambda = diag([5, 5]);      % Guadagno sulla posizione
Kd_adapt = diag([20, 20]);  % Guadagno sulla "sliding variable"
Gamma = eye(8) * 2;         % Velocità di apprendimento parametri
Gamma(5,5) = 10;
Gamma(6,6) = 10;

% Condizioni iniziali: stato + stima parametri
theta_hat0 = zeros(8, 1); 
y0_adapt = [x0; theta_hat0]; % [q; dq; theta_hat]
[t_ad, y_ad] = ode45(@(t,y) robot_dynamics_adaptive(t, y, A_traj, w_traj, Lambda, Gamma, Kd_adapt), [0 15], y0_adapt);

% Estrazione dati
q_ad = y_ad(:, 1:2);
dq_ad = y_ad(:, 3:4);
theta_hist = y_ad(:, 5:end);

% Ricostruzione riferimento
q_des_ad = zeros(length(t_ad), 2);
for i=1:length(t_ad)
    q_des_ad(i,:) = (A_traj .* sin(w_traj*t_ad(i)))';
end

% Vettore parametri veri completo
theta_real_full = [theta; F_real];
plot_res_adaptive(t_ad, q_ad, dq_ad, theta_hist, q_des_ad, theta_real_full);