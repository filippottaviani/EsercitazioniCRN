function [Pi, Gamma] = solve_regulation_sylvester(A, B, P, S, C, Q)    
    n = size(A, 1);
    m = size(B, 2);
    nw = size(S, 1);
    p = size(C, 1);
    
    % Numero totale di incognite
    num_unknowns = n*nw + m*nw;
    
    % Riscriviamo Pi*S - A*Pi - B*Gamma = P
    term1 = kron(S', eye(n)) - kron(eye(nw), A);
    term2 = -kron(eye(nw), B);
    
    % Riscriviamo C*Pi + 0*Gamma = -Q    
    term3 = kron(eye(nw), C);
    term4 = zeros(p*nw, m*nw);
    
    % Costruzione matrice sistema
    M_sys = [term1, term2;
             term3, term4];
    knowns = [P(:); -Q(:)];
    
    % Risoluzione sistema lineare
    sol = M_sys \ knowns;
    
    % Estrazione soluzioni e reshape
    vec_Pi = sol(1 : n*nw);
    vec_Gamma = sol(n*nw + 1 : end);
    Pi = reshape(vec_Pi, n, nw);
    Gamma = reshape(vec_Gamma, m, nw);
end