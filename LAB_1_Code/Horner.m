% ========================================================================
% Classic Horner Scheme
% ========================================================================
function res = Horner(p, x)
    % Evaluates polynomial p at point x using Horner's method
    % Input:
    %   p: coefficient vector [a0, a1, ..., an] where p(x) = sum(ai * x^i)
    %   x: evaluation point
    % Output:
    %   res: p(x)
    
    n = length(p) - 1;  % degree of polynomial
    s = p(n+1);  % start with highest degree coefficient (an)
    
    for i = n-1:-1:0
        s = s * x + p(i+1);
    end
    
    res = s;
end