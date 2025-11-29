% Verifica se la coppia è rilevabile
function detectable = is_detectable(C, A, L, tol)
    % Verifico lo spettro della matrice (A-LC)
    det_poles= eig(A - L*C);
    if max(real(det_poles)) < tol
        detectable = true;
    else
        detectable = false;
    end
end