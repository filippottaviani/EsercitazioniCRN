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

% Definizione del target
x_des = 0.6; 
y_des = 0.4;
target_pos = [x_des; y_des];

% Condizione iniziale (q1, q2, dq1, dq2)
q0 = [-pi/2; 0; 0; 0]; 

% Simulazione
T_sim = 5;
[t, y] = ode45(@(t,y) robot_dynamics_operational(t, y, target_pos), [0 T_sim], q0);

% visualizzazione
plot_res_pos(y, target_pos, t, geom);