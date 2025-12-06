clear all;
close all;
clc;

addpath('8')

% Parametri del controllore
k1 = 2.0; 
k2 = 5.0;
k3 = 2.5;

global gains
gains = [k1, k2, k3];

% Configurazione della simulazione
T_sim = 15;         % Durata [s]
dt = 0.01;          % Passo
t_span = 0:dt:T_sim;

% Condizioni iniziali del robot (x, y, theta)
q0 = [0; -1; 0]; 

% Simulazione 
disp('Avvio simulazione del robot uniciclo');
[t, q] = ode45(@(t,q) unicycle_dynamics(t, q), t_span, q0);

% Ricostruiamo i segnali di riferimento e di errore per i grafici
x = q(:,1);
y = q(:,2);
theta = q(:,3);
N = length(t);
xd = zeros(N,1);
yd = zeros(N,1);
thetad = zeros(N,1);
e1 = zeros(N,1);
e2 = zeros(N,1);
e3 = zeros(N,1);
v_cmd = zeros(N,1);
w_cmd = zeros(N,1);

for i=1:N
    [dqdt, ref, err, ctrl] = unicycle_dynamics(t(i), q(i,:)');
    xd(i) = ref(1);
    yd(i) = ref(2);
    thetad(i) = ref(3);
    e1(i) = err(1);
    e2(i) = err(2);
    e3(i) = err(3);
    v_cmd(i) = ctrl(1);
    w_cmd(i) = ctrl(2);
end

% Plot delle traiettorie degli errori e dei riferimenti
plot_res(x, y, xd, yd, e1, e2, e3, v_cmd, w_cmd, t, theta)