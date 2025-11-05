function res = CompHorner(p, x)
    % CompHorner: Compensated Horner Scheme (Algorithm 1.5)
    % Evaluates polynomial p(x) with improved accuracy using EFTs
    %
    % Input:
    %   p: coefficient vector [a0, a1, ..., an] where p(x) = sum(ai * x^i)
    %   x: evaluation point
    % Output:
    %   res: compensated evaluation of p(x)
    %
    % Accuracy: |res - p(x)|/|p(x)| <= u + gamma_2n^2 * cond(p,x)
    %           where gamma_2n^2 ≈ 4n^2 u^2
    %
    % This is a DRAMATIC improvement over classical Horner:
    %   Classical: error ~ nu * cond(p,x)  (linear in u)
    %   Compensated: error ~ u + n^2 u^2 * cond(p,x)  (quadratic in u)
    %
    % For u ≈ 10^-16, this means u^2 ≈ 10^-32, making the 
    % condition-dependent term negligible even for huge cond numbers!
    
    n = length(p) - 1;  % degree of polynomial
    
    % Initialize
    s = p(n+1);  % s_n = a_n
    r = 0;       % r_n = 0 (running compensation term)
    
    % Horner iteration with error tracking
    for i = n-1:-1:0
        % Multiplication with error tracking: [p_i, pi_i] = TwoProduct(s, x)
        [p_i, pi_i] = TwoProduct(s, x);
        
        % Addition with error tracking: [s_i, sigma_i] = TwoSum(p_i, a_i)
        [s, sigma_i] = TwoSum(p_i, p(i+1));
        
        % Accumulate compensation: r_i = fl((r_{i+1} * x + (pi_i + sigma_i)))
        r = r * x + (pi_i + sigma_i);
    end
    
    % Final result: add main result and compensation
    res = s + r;
end