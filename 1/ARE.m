clear all;
clc;
close all;

addpath('funzioni','1')
pkg load control

% Definisco il sistema
A = [-1 2; -3 -4];
B = [1; 0];

% 
E = eye(2);
Q = E'*E;
R = 1;

% Q deve essere semidefinita positiva
if ~is_pos_semidefinite(Q)
    error('ARE non risolvibile: Q non è semidefinita positiva!');
end

% R deve essere definita positiva
if ~is_pos_definite(R)
    error('ARE non risolvibile: R non è definita positiva!');
end

% (A,B) deve essere controllabile
if ~is_controllable(A, B)
    error('ARE non risolvibile: la coppia (A, B) non è controllabile!');
end

% (E,A) deve essere osservabile
if ~is_observable(E, A)
    error('ARE non risolvibile: la coppia (A, B) non è osservabile!');
end

% Soluzioni della ARE
P_through_DRE = solve_ARE_through_DRE(A, B, Q, R);
P_shur = solve_ARE_shur(A, B, Q, R)

fprintf('\nSOLUZIONI EQUAZIONE ALGEBRICA DI RICCATI (ARE)\n')
fprintf('\n1. Attraverso la soluzione stazionaria della DRE')
disp('P = ', P_through_DRE)
fprintf('\n2. Attraverso il calcolo del complemento di Shur')
disp('P = ', P_shur)