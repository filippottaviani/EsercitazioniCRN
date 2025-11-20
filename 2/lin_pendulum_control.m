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

% Calcolo del guadagno K
K = lqr(A, B, Q, R);
disp('Guadagno LQR (K):');
disp(K);

% Poli del sistema controllato (ad anello chiuso con stato completo)
poles_controller = eig(A - B*K);
disp('Poli controllore (A-BK):');
disp(poles_controller);

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
L_transpose = place(A', C', P_obs);
L = L_transpose'; % Matrice di guadagno dell'osservatore

disp('Guadagno Osservatore (L):');
disp(L);

% Poli dell'osservatore
poles_observer = eig(A - L*C);
disp('Poli osservatore (A-LC):');
disp(poles_observer);

# Verifico la stabilità del sistema
tol = -1e-6 # per evitare errori di arrotondamento
if max(real(poles_controller)) < tol && max(real(poles_observer)) < tol
    disp('Il sistema a ciclo chiuso è stabile.')
else
    error('Il sistema a ciclo chiuso non è stabile!')
end

%% Simulo il sistema completo (Regolatore + Osservatore)
simulate_system(A, B, C, K, L)