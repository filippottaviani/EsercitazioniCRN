clear all;
clc;
close all;

addpath('3')

%% ESEMPIO 1: dx/dt = x^2
% Definisco il problema
f1 = @(t, x) x^2; % Funzione di stato
f1_analitica = @(t, x0) x0 ./ (1 - t.*x0); % Soluzione analitica
t_span1 = [0, 5];  % Intervallo di tempo desiderato
x0_1 = 1;          % Condizione iniziale

% Calcolo la soluzione numerica (ode45)
[t_num1, x_num1] = numeric_solution(f1, t_span1, x0_1);

% Calcolo la soluzione analitica (solo per il plotting, evitando l'asintoto)
t_plot_analitico1 = linspace(0, 0.99, 100);
[t_an1, x_an1] = analytical_solution(f1_analitica, t_plot_analitico1, x0_1);

% Plotting
titolo1 = 'Esempio 1: dx/dt = x^2 (Finite Time Escape)';
plot_sol(1, titolo1, t_num1, x_num1, t_an1, x_an1);
ylim([0, 50]); % Limitiamo l'asse y per vedere il comportamento

%% ESEMPIO 2: dx/dt = -x^3
% Definisco il Problema
f2 = @(t, x) -x^3; % Funzione di stato
f2_analitica = @(t, x0) x0 ./ sqrt(1 + 2.*t.*x0.^2); % Soluzione analitica
t_span2 = [0, 5];  % Intervallo di tempo
x0_2 = 5;          % Condizione iniziale

% Calcolo la soluzione numerica (ode45)
[t_num2, x_num2] = numeric_solution(f2, t_span2, x0_2);

% Calcolo l'analitica sugli stessi punti della numerica per un confronto diretto
[t_an2, x_an2] = analytical_solution(f2_analitica, t_num2, x0_2);

% Plotting
titolo2 = 'Esempio 2: dx/dt = -x^3 (Soluzione Completa)';
plot_sol(2, titolo2, t_num2, x_num2, t_an2, x_an2);
