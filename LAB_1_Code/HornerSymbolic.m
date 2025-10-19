function res = HornerSymbolic(p, x)
    % HornerSymbolic: Horner scheme using exact symbolic arithmetic
    % This gives the TRUE exact result for comparison
    %
    % Input:
    %   p: coefficient vector [a0, a1, ..., an] (numeric)
    %   x: evaluation point (numeric)
    % Output:
    %   res: exact symbolic result
    %
    % Note: Result is returned as a symbolic expression
    %       Use double(res) to convert to floating-point
    %       Use vpa(res, digits) for arbitrary precision
    
    % Convert inputs to symbolic
    p_sym = sym(p);
    x_sym = sym(x);
    
    n = length(p_sym) - 1;  % degree of polynomial
    
    % Horner's method in exact arithmetic
    s = p_sym(n+1);  % s_n = a_n
    
    for i = n-1:-1:0
        s = s * x_sym + p_sym(i+1);
    end
    
    res = s;

end