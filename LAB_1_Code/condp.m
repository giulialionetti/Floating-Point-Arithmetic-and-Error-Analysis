function cond_number = condp(p, x)
    % condp: Compute condition number for polynomial evaluation
    % 
    % Condition number for evaluating p(x) = sum(a_i * x^i) is:
    %   cond(p,x) = p_tilde(|x|) / |p(x)|
    % where:
    %   p_tilde(|x|) = sum(|a_i| * |x|^i)  (sum of absolute values)
    %   p(x) = sum(a_i * x^i)               (actual polynomial value)
    %
    % Input:
    %   p: coefficient vector [a0, a1, ..., an] where p(x) = sum(ai * x^i)
    %   x: evaluation point
    % Output:
    %   cond_number: condition number cond(p, x)
    %
    % Interpretation:
    %   - cond ≈ 1: Well-conditioned (small perturbations → small changes)
    %   - cond ~ 10^6: Moderately conditioned (some accuracy loss)
    %   - cond > 10^10: Ill-conditioned (significant accuracy loss)
    %   - cond > 10^14: Severely ill-conditioned (catastrophic errors)
    %
    % The condition number measures the sensitivity of p(x) to 
    % perturbations in the coefficients.
    
    n = length(p) - 1;  % degree of polynomial
    
    % Compute p_tilde(|x|) = sum(|a_i| * |x|^i)
    % This is the "absolute value polynomial"
    powers = abs(x) .^ (0:n);  % [1, |x|, |x|^2, ..., |x|^n]
    p_tilde = sum(abs(p) .* powers);
    
    % Compute p(x) = sum(a_i * x^i)
    % CRITICAL: Use exact computation for condition number!
    % Otherwise, for ill-conditioned polynomials, Horner gives wrong p(x)
    % which makes the condition number unreliable
    
    % Try to use symbolic computation if available
    try
        px_sym = HornerSymbolic(p, x);
        px = double(px_sym);
    catch
        % Fallback: use compensated Horner (much better than classical)
        warning('condp:NoSymbolic', ...
                'Symbolic computation failed, using CompHorner instead');
        px = CompHorner(p, x);
    end
    
    % Condition number
    if abs(px) == 0
        cond_number = Inf;  % Undefined (dividing by zero)
        warning('condp:ZeroDenominator', ...
                'p(x) = 0, condition number is infinite');
    else
        cond_number = p_tilde / abs(px);
    end
end