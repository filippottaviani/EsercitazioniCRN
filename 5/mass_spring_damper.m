clc;
clear all;
close all;

pkg load control;

addpath('5')


% Parametri comuni (M, k1, beta1 > 0)
M = 1.0;
k1 = 1.0;
beta1 = 0.5; % Smorzamento leggero (sottosmorzato)

% Parametro non lineare
k2 = 1.0;     % Termine della molla non lineare

% Caso 1: lineare
f_linear = @(t, x) [
    x(2);
    (1/M) * (-k1*x(1) - beta1*x(2))
];
J_linear = @(x) [0, 1; -k1/M, -beta1/M];

% Caso 2: non lineare (molla "ammorbidente")
f_soft = @(t, x) [
    x(2);
    (1/M) * (-k1*x(1) - k2*x(1)^3 - beta1*x(2))
];
J_soft = @(x) [0, 1; (-k1 - 3*k2*x(1)^2)/M, -beta1/M];

% Caso 3: non lineare (molla "indurente")
f_hard = @(t, x) [
    x(2);
    (1/M) * (-k1*x(1) + k2*x(1)^3 - beta1*x(2))
];
J_hard = @(x) [0, 1; (-k1 + 3*k2*x(1)^2)/M, -beta1/M];

% Condizioni iniziali di esempio (comuni per tutti i plot)
cond_iniziali = [
    1, 0;
    -1, 0;
    0, 1.5;
    0, -1.5;
    1.5, 1.5;
    -1.5, -1.5;
    0.1, 0.1
];

% Caso 1: lineare
P_linear = [0, 0];
analyze_system(1, 'Caso 1: Sistema Lineare', J_linear, P_linear);
plot_phase_portrait(1, f_linear, cond_iniziali);

% Caso 2: non lineare (molla "ammorbidente")
P_soft = [0, 0];
analyze_system(2, 'Caso 2: Molla "Ammorbidente" (Softening)', J_soft, P_soft);
plot_phase_portrait(2, f_soft, cond_iniziali);

% Caso 3: non lineare (molla "indurente")
P_hard = [
    0, 0;
    sqrt(k1/k2), 0;
    -sqrt(k1/k2), 0
];
analyze_system(3, 'Caso 3: Non-Lineare (Hardening)', J_hard, P_hard);
plot_phase_portrait(3, f_hard, cond_iniziali);