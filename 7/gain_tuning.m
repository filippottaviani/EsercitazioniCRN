function [Kp_tuned, Kd_tuned] = gain_tuning(omega_des, zeta_des, q_des)
    % Calcolo i guadagni in base all'inerzia nella configurazione target
    [B_des, ~, ~, ~] = get_dynamic_matrices(q_des, [0; 0]);

    % Calcolo i guadagni
    J11 = B_des(1,1);
    J22 = B_des(2,2);
    Kp_tuned = diag([J11 * omega_des^2, J22 * omega_des^2]);
    Kd_tuned = diag([J11 * 2 * zeta_des * omega_des, J22 * 2 * zeta_des * omega_des]);

    fprintf('Guadagni calcolati per omega_n=%.1f e zeta=%.1f:\n', omega_des, zeta_des);
    disp('Kp:');
    disp(Kp_tuned);
    disp('Kd:');
    disp(Kd_tuned);
end