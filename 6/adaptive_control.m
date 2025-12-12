clear all;
close all;
clc;

addpath('6')

% Parametri del sistema
global a_true lambda gamma

% Valore reale del parametro
a_true = 1.5;

% Parametri di progetto del controllore
lambda = 2.0;      % Velocità di convergenza dell'errore (lambda > 0)
gamma  = 5.0;      % Guadagno di adattamento

% Parametri di simulazione
T_sim = 20;
dt = 0.01;
t_span = 0:dt:T_sim;

% Condizioni iniziali
x0 = 2;            % Stato iniziale del sistema
a_hat0 = 0;        % Stima iniziale del parametro 'a' (può partire da 0)
initial_state = [x0; a_hat0];

% Stabilizzazione
disp('Avvio simulazione di stabilizzazione');
type_ref = 1; % Stabilizzazione
[t1, y1] = ode45(@(t,y) system_dynamics(t, y, type_ref), t_span, initial_state);

% Inseguimento di traiettoria
disp('Avvio simulazione di inseguimento');
type_ref = 2; % Inseguimento sinusoide
[t2, y2] = ode45(@(t,y) system_dynamics(t, y, type_ref), t_span, initial_state);

% Ricostruzione segnali di controllo e riferimenti per i grafici
u1 = zeros(length(t1),1);
xd1 = zeros(length(t1),1);
for i=1:length(t1)
    [~, u_val, xd_val] = system_dynamics(t1(i), y1(i,:)', 1);
    u1(i) = u_val;
    xd1(i) = xd_val;
end

u2 = zeros(length(t2),1);
xd2 = zeros(length(t2),1);
for i=1:length(t2)
    [~, u_val, xd_val] = system_dynamics(t2(i), y2(i,:)', 2);
    u2(i) = u_val; 
    xd2(i) = xd_val;
end

plot_res(y1, y2, xd1, xd2, t1, t2, u1, u2, a_true)

