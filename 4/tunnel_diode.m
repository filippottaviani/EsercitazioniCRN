clc;
clear all;
close all;

addpath('4')
pkg load control
pkg load symbolic

% Definisco le variabili simboliche per l'analisi
syms x1 x2

% Costanti del circuito
R = 1;
L = 1;
C = 1;
alpha = 3;
beta = 1;

% Definisco le equazioni di stato (il sistema non lineare f(x))
f1 = -R/L * x1 + 1/L * x2;
f2 = -1/C * x1 + alpha/C * x2 - beta/C * x2^3;
f = [f1; f2];

disp('Sistema non lineare dx/dt = f(x):');
disp(['dx1/dt = ', char(f1)]);
disp(['dx2/dt = ', char(f2)]);

% Trovo i punti (x1, x2) tali che f(x) = 0 (analiticamente)
P1 = [0; 0];
P2 = [sqrt(2); sqrt(2)];
P3 = [-sqrt(2); -sqrt(2)];

% Convertiamo in double per l'analisi numerica
P1_num = double(P1);
P2_num = double(P2);
P3_num = double(P3);

disp('\nTrovati 3 punti di equilibrio:');
disp('P1:'); disp(P1_num');
disp('P2:'); disp(P2_num');
disp('P3:'); disp(P3_num');

% Calcoliamo la matrice Jacobiana J = df/dx
disp('')
disp('Calcolo Matrice Jacobiana J(x)...');

J = jacobian(f, [x1, x2]);

disp('J(x1, x2) =');
disp(J);


%% Analizzo e classifico i punti di equilibrio
disp('')
disp('Analisi di stabilità per ciascun equilibrio:');

analyze_equilibrium_point(J, x1, x2, P1_num)
analyze_equilibrium_point(J, x1, x2, P2_num)
analyze_equilibrium_point(J, x1, x2, P3_num)

% Creiamo una funzione "handle" per ode45
fun_diodo = @(t, x) [
    -R/L * x(1) + 1/L * x(2);
    -1/C * x(1) + alpha/C * x(2) - beta/C * x(2)^3
];
disp('')
disp('Avvio simulazione e plot del ritratto di fase...');

plot_vector_field(R, L, C, alpha, beta, P1_num, P2_num, P3_num, fun_diodo)