function detectable = is_detectable(A, C)
    % Utilizzo la dualità con la stabilizzabilità (PBH test)
    detectable = is_stabilizable(A', C');
end