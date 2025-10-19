% test_horner.m
% Test script for Horner scheme with focus on floating-point error analysis
% Based on AFAE lecture slides - Testing in IEEE 754 double precision

clear all;
close all;
clc;

fprintf('========================================================================\n');
fprintf('Floating-Point Error Analysis for Horner Scheme\n');
fprintf('IEEE 754 Double Precision (u = 2^-53 ≈ 1.11e-16)\n');
fprintf('========================================================================\n\n');

u = eps/2;  % unit roundoff for double precision
fprintf('Machine epsilon (eps): %.4e\n', eps);
fprintf('Unit roundoff (u):     %.4e\n\n', u);

%% Test 1: Well-conditioned polynomial - Expected small error
fprintf('Test 1: Well-conditioned polynomial\n');
fprintf('--------------------------------------------------------------------\n');
fprintf('p(x) = 1 + x + x^2 + x^3 at x = 0.5\n');
p1 = [1, 1, 1, 1];
x1 = 0.5;

% Compute "exact" value using higher precision simulation
exact1 = sum(p1 .* (x1 .^ (0:3)));
result1 = Horner(p1, x1);

% Condition number: cond(p,x) = sum|ai||x|^i / |p(x)|
p_tilde1 = sum(abs(p1) .* (abs(x1) .^ (0:3)));
cond1 = p_tilde1 / abs(exact1);

% Error analysis
abs_error1 = abs(result1 - exact1);
rel_error1 = abs_error1 / abs(exact1);
n1 = length(p1) - 1;
gamma_2n1 = (2*n1*u) / (1 - 2*n1*u);
error_bound1 = gamma_2n1 * cond1;

fprintf('Exact result:           %.16e\n', exact1);
fprintf('Horner result:          %.16e\n', result1);
fprintf('Condition number:       %.4e\n', cond1);
fprintf('Relative error:         %.4e\n', rel_error1);
fprintf('Error bound (γ_2n·cond): %.4e\n', error_bound1);
fprintf('Error / Bound ratio:    %.4f\n', rel_error1 / error_bound1);

if rel_error1 <= error_bound1
    fprintf('✓ Error within theoretical bound\n\n');
else
    fprintf('⚠ Error exceeds bound (unusual but possible)\n\n');
end

%% Test 2: Ill-conditioned polynomial (x-1)^n - Key test from slides
fprintf('Test 2: Ill-conditioned polynomial (from slides)\n');
fprintf('--------------------------------------------------------------------\n');
fprintf('p(x) = (x-1)^n for various n, evaluated at x = 1.333\n\n');

x2 = 1.333;
fprintf('Degree | Cond Number | Rel Error  | γ_2n·cond  | Error/Bound\n');
fprintf('-------|-------------|------------|------------|------------\n');

for n = [5, 10, 15, 20, 25, 30]
    % Construct (x-1)^n in expanded form
    p_n = poly(ones(1, n));
    p_n = fliplr(p_n);
    
    % "Exact" value (computed using the factored form)
    exact_n = (x2 - 1)^n;
    
    % Horner evaluation
    result_n = Horner(p_n, x2);
    
    % Condition number
    p_tilde_n = sum(abs(p_n) .* (abs(x2) .^ (0:n)));
    cond_n = p_tilde_n / abs(exact_n);
    
    % Error analysis
    rel_error_n = abs(result_n - exact_n) / abs(exact_n);
    gamma_2n_n = (2*n*u) / (1 - 2*n*u);
    error_bound_n = gamma_2n_n * cond_n;
    
    fprintf('  %2d   | %.2e  | %.2e | %.2e | %.4f\n', ...
            n, cond_n, rel_error_n, error_bound_n, rel_error_n/error_bound_n);
end

fprintf('\nObservation: As condition number increases, relative error grows.\n');
fprintf('When cond·γ_2n > 1, we lose accuracy (exceeds 1/u ≈ 10^16).\n\n');

%% Test 3: Demonstrating loss of accuracy with condition number
fprintf('Test 3: Accuracy loss demonstration (slides Fig. page 34)\n');
fprintf('--------------------------------------------------------------------\n');
fprintf('p_n(x) = (x-1)^n evaluated at x = fl(1.333) for n = 3:42\n\n');

x3 = 1.333;
n_values = 3:5:42;
cond_vals = zeros(size(n_values));
rel_errors = zeros(size(n_values));

fprintf('Degree | Condition Number | Relative Error | Digits Lost\n');
fprintf('-------|------------------|----------------|-------------\n');

for idx = 1:length(n_values)
    n = n_values(idx);
    
    % Construct polynomial
    p_n = poly(ones(1, n));
    p_n = fliplr(p_n);
    
    % Exact and computed values
    exact_n = (x3 - 1)^n;
    result_n = Horner(p_n, x3);
    
    % Condition number and error
    p_tilde_n = sum(abs(p_n) .* (abs(x3) .^ (0:n)));
    cond_n = p_tilde_n / abs(exact_n);
    rel_error_n = abs(result_n - exact_n) / abs(exact_n);
    
    cond_vals(idx) = cond_n;
    rel_errors(idx) = rel_error_n;
    
    % Estimate digits lost
    digits_lost = -log10(rel_error_n);
    if digits_lost < 0
        digits_lost = 0;
    end
    
    fprintf('  %2d   | %.4e       | %.4e     | %.1f\n', ...
            n, cond_n, rel_error_n, 16 - digits_lost);
end

fprintf('\nNote: We start with ~16 decimal digits in double precision.\n');
fprintf('High condition numbers → large relative errors → loss of digits.\n\n');

%% Test 4: Backward error analysis
fprintf('Test 4: Backward error analysis\n');
fprintf('--------------------------------------------------------------------\n');
fprintf('For p(x) = (x-1)^15 at x = 1.5\n');

n4 = 15;
x4 = 1.5;
p4 = poly(ones(1, n4));
p4 = fliplr(p4);

exact4 = (x4 - 1)^n4;
result4 = Horner(p4, x4);

% Forward error
forward_error = abs(result4 - exact4) / abs(exact4);

% Estimate backward error (what perturbation in data explains result?)
% For polynomial evaluation, backward error ≈ u (backward stable)
fprintf('Forward error:  %.4e\n', forward_error);
fprintf('Unit roundoff:  %.4e\n', u);
fprintf('Ratio:          %.4e\n\n', forward_error / u);

fprintf('Interpretation: Forward error >> u indicates problem is ill-conditioned.\n');
fprintf('The algorithm is backward stable (perturbs input by ~u),\n');
fprintf('but condition number amplifies this to large forward error.\n\n');

%% Test 5: Comparison of absolute errors at different magnitudes
fprintf('Test 5: Error behavior across different magnitude results\n');
fprintf('--------------------------------------------------------------------\n');
fprintf('Testing p(x) = x^10 at different x values\n\n');

p5 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];  % x^10
x_vals = [0.5, 1.0, 1.5, 2.0];

fprintf('   x   |   p(x)   | Rel Error | Abs Error\n');
fprintf('-------|----------|-----------|----------\n');

for x = x_vals
    exact = x^10;
    result = Horner(p5, x);
    abs_err = abs(result - exact);
    rel_err = abs_err / abs(exact);
    
    fprintf(' %.1f   | %.2e | %.2e  | %.2e\n', x, exact, rel_err, abs_err);
end

fprintf('\nObservation: Relative error stays roughly constant (~u),\n');
fprintf('but absolute error scales with magnitude of result.\n\n');

%% Test 6: Accumulation of rounding errors
fprintf('Test 6: Rounding error accumulation in summation\n');
fprintf('--------------------------------------------------------------------\n');
fprintf('High-degree polynomial with random coefficients\n');

rng(42);  % for reproducibility
n6 = 50;
p6 = randn(1, n6+1);
x6 = 0.7;

% Compute using Horner
result_horner = Horner(p6, x6);

% Compute directly (more rounding errors)
result_direct = sum(p6 .* (x6 .^ (0:n6)));

% Condition number
p_tilde6 = sum(abs(p6) .* (abs(x6) .^ (0:n6)));
cond6 = p_tilde6 / abs(result_horner);

fprintf('Degree:           %d\n', n6);
fprintf('Condition number: %.4e\n', cond6);
fprintf('Horner result:    %.16e\n', result_horner);
fprintf('Direct result:    %.16e\n', result_direct);
fprintf('Difference:       %.4e\n', abs(result_horner - result_direct));
fprintf('Rel difference:   %.4e\n\n', abs(result_horner - result_direct) / abs(result_horner));

fprintf('Note: Horner (2n flops) accumulates less error than\n');
fprintf('direct evaluation (n multiplications + n additions separately).\n\n');

%% Summary
fprintf('========================================================================\n');
fprintf('Summary of Floating-Point Error Behavior\n');
fprintf('========================================================================\n');
fprintf('1. Horner scheme is backward stable: backward error ~ u\n');
fprintf('2. Forward error ≈ condition number × u (first-order approximation)\n');
fprintf('3. Ill-conditioned problems (large cond) → large forward errors\n');
fprintf('4. Error bound: |p(x) - Horner(p,x)|/|p(x)| ≤ γ_2n·cond(p,x)\n');
fprintf('5. When cond·γ_2n approaches 1/u, we lose all accuracy\n');
fprintf('========================================================================\n');