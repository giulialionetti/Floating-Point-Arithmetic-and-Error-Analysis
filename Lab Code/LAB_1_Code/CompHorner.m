function res = CompHorner(p, x)
    % CompHorner: Compensated Horner Scheme 
    % Evaluates polynomial p(x) with improved accuracy using Error Free Transformation)
    
    n = length(p)-1;
    s = p(n+1);  
    r = 0;      
    
    
    for i = n-1:-1:0
        [p_i, pi_i] = TwoProduct(s, x)
        [p_i, pi_i] = TwoProduct(s, x);
        
        [s_i, sigma_i] = TwoSum(p_i, a_i)
        [s, sigma_i] = TwoSum(p_i, p(i+1));
        
         r_i = fl((r_{i+1} * x + (pi_i + sigma_i)))
        r = r * x + (pi_i + sigma_i);
    end
    
    
    res = s + r;
end