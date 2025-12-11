function detectable = is_detectable(C, A, L)
    % Verifico lo spettro della matrice (A-LC)
    tol=1e-6
    det_poles= eig(A - L*C);
    if max(real(det_poles)) < tol
        detectable = true;
    else
        detectable = false;
    end
end