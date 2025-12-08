clear all;
clc;
close all;

addpath('funzioni','1')
pkg load control

% Definisco il sistema
A = [-1 2; -3 -4];
B = [1; 0];
E = eye(2);
Q = E'*E;
R = 1;

% Scelgo un orizzonte temporale T sufficientemente lungo
T_horizon = 100;

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

% Soluzione della ARE
P_inf = solve_ARE_through_DRE(A, B, Q, R, T_horizon);

fprintf('\nSoluzione dell equazione algebrica di Riccati (ARE)\n')
disp(P_inf)