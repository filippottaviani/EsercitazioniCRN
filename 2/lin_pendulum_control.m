clear all;
clc;
close all;

pkg load control

addpath('funzioni')
addpath('2')

% Definiamo i parametri fisici del carrello e del pendolo
M = 1.0;     % Massa del carrello (kg)
m = 0.1;     % Massa del pendolo (kg)
l = 0.5;     % Lunghezza del pendolo (metri - dal perno al centro di massa)
g = 9.81;    % Accelerazione di gravità (m/s^2)
tol = -1e-6 % per evitare errori di arrotondamento

% Matrice A
A = [0, 1, 0, 0;
     0, 0, -m*g/M, 0;
     0, 0, 0, 1;
     0, 0, (M+m)*g/(M*l), 0];

% Matrice B
B = [0;
     1/M;
     0;
     1/(M*l)];

% Matrice C (Informazione Parziale)
C = [1, 0, 0, 0;   % Misura di x
     0, 0, 1, 0];  % Misura di theta

% Matrice D (nessun legame diretto ingresso-uscita)
D = [0;
     0];

% Creazione del sistema state-space
sys = ss(A, B, C, D);
disp('Sistema (A, B, C, D):');
disp(sys);

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

% Progetto del Regolatore di Stato (LQR)
Q = diag([
    1,   % Penalità su x
    0.1, % Penalità su x_dot
    100, % Penalità ALTA su theta (priorità massima!)
    1,   % Penalità su theta_dot
    ]);

R = 0.1; % Penalità bassa sul comando per avere una risposta rapida

% Calcolo del guadagno K con la mia DRE e con la funzione apposita
P_inf = solve_ARE_through_DRE(A, B, Q, R);
K_cal = inv(R) * B' * P_inf;
K_fun = lqr(A, B, Q, R);
disp('Guadagno LQR (K) calcolato tramite es 1:');
disp(K_cal);
disp('Guadagno LQR (K) calcolato tramite funzione apposita:');
disp(K_fun);
K = K_cal

% Poli del sistema controllato (ad anello chiuso con stato completo)
poles_controller = eig(A - B*K);
disp('Poli controllore (A-BK):');
disp(poles_controller);

%% CASO NON RUMOROSO
% Prendo la parte reale del polo dominante (più lento) del controllore
dominant_pole = max(real(poles_controller));

% Scelgo poli per l'osservatore che siano fino a 5 volte più veloci
P_obs = [
    dominant_pole * 2,
    dominant_pole * 3,
    dominant_pole * 4,
    dominant_pole * 5
    ];

% Uso 'place' per trovare L.
L_luen_t = place(A', C', P_obs);
L_luen = L_luen_t'; % Matrice di guadagno dell'osservatore
disp('Guadagno Osservatore (L):');
disp(L_luen);

% Verifico la stabilità del sistema
if is_stabilizable(A, B, K, tol) < tol && is_detectable(C, A, L_luen, tol)
    disp('Il sistema a ciclo chiuso è stabile.')
else
    error('Il sistema a ciclo chiuso non è stabile!')
end

% Simulo il sistema completo (Regolatore + Osservatore)
simulate_system(A, B, C, K, L_luen)


% CASO RUMOROSO
% Definiamo le caratteristiche del rumore
B_w = B; 

% Covarianza del Rumore di Processo (W) e di Misura (V)
W = 0.1;  % Intensità del disturbo sul processo
V = diag([0.001, 0.001]); % Rumore dei sensori

% Verifico la stabilità del sistema
if is_stabilizable(A, B_w, K, tol) < tol && is_detectable(C, A, L_kalm, tol)
    disp('Il sistema a ciclo chiuso è stabile.')
else
    error('Il sistema a ciclo chiuso non è stabile!')
end

% Calcolo del guadagno L ottimo (dualità con Kalman)
[L_kalm_t, ~, ~] = lqr(A', C', B_w*W*B_w', V);
L_kalm = L_kalm_t'; 
disp('Guadagno Filtro di Kalman (L):');
disp(L_kalm);

% Simulo il sistema completo con rumore
simulate_noisy_system(A, B, C, K, L_kalm, B_w, W, V)