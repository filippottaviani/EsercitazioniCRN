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
disp('Regolazione spazio operativo');

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

%% CONTROLLO in traiettoria
% Definizione delle traiettorie desiderata
A_traj = [pi/4; pi/6];      % Ampiezze [rad]
w_traj = [1.0; 1.5];        % Frequenze [rad/s]

% Condizione iniziale
q0 = [2; 2];
dq0 = [1; 1];
x0 = [q0; dq0];

% Simulazione
T_sim = 3;
disp('Avvio simulazione Computed Torque...');
[t, y] = ode45(@(t,y) robot_dynamics_computed_torque(t, y, A_traj, w_traj), [0 T_sim], x0);
disp('Simulazione completata.');

% Risultati (posizione e velocità)
q = y(:, 1:2);
dq = y(:, 3:4);

% Ricostruzione riferimenti per il plot
q_des = zeros(length(t), 2);
dq_des = zeros(length(t), 2);
for i=1:length(t)
    q_des(i,:) = (A_traj .* sin(w_traj*t(i)))';
    dq_des(i,:) = (A_traj .* w_traj .* cos(w_traj*t(i)))';
end

% Calcolo dell'errore
e_q = q_des - q;

% Plot
plot_res_traj(t, q, dq, q_des, e_q)