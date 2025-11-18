clear all;
close all;
clc;

addpath('6')

%% --- PARAMETRI DEL SISTEMA ---
global a_true lambda gamma

a_true = 1.5;      % Valore REALE del parametro 'a' (instabile se > 0)
                   % Il controllore NON conosce questo valore.

% Parametri di progetto del controllore
lambda = 2.0;      % Velocità di convergenza dell'errore (lambda > 0)
gamma  = 5.0;      % Guadagno di adattamento (velocità stima di 'a')

%% --- CONFIGURAZIONE SIMULAZIONE ---
T_sim = 20;        % Durata simulazione [s]
dt = 0.01;         % Passo di campionamento
t_span = 0:dt:T_sim;

% Condizioni iniziali
x0 = 2;            % Stato iniziale del sistema
a_hat0 = 0;        % Stima iniziale del parametro 'a' (può partire da 0)
initial_state = [x0; a_hat0];

%% --- SCENARIO 1: STABILIZZAZIONE (Target = 0) ---
disp('Avvio simulazione Scenario 1: Stabilizzazione...');
type_ref = 1; % 1 = Stabilizzazione
[t1, y1] = ode45(@(t,y) system_dynamics(t, y, type_ref), t_span, initial_state);

%% --- SCENARIO 2: INSEGUIMENTO TRAIETTORIA (Sinusoide) ---
disp('Avvio simulazione Scenario 2: Inseguimento...');
type_ref = 2; % 2 = Inseguimento Sinusoide
[t2, y2] = ode45(@(t,y) system_dynamics(t, y, type_ref), t_span, initial_state);

%% --- POST-PROCESSING E GRAFICI ---

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

