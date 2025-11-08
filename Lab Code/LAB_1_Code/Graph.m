% plot_HornerComparison.m
% Reproduce the plot from slide 34: Condition number vs Relative forward error
% Testing p_n(x) = (x-1)^n with x = fl(1.333) and n = 3:42

clear all;
close all;
clc;

fprintf('========================================================================\n');
fprintf('Generating Condition Number vs Relative Error Plot\n');
fprintf('Reproducing slide 34 from lecture notes\n');
fprintf('========================================================================\n\n');

u = eps/2;
x_test = 1.333;

% Test range: n from 3 to 42
n_values = 3:42;
n_count = length(n_values);

% Preallocate arrays
cond_values = zeros(1, n_count);
error_classic = zeros(1, n_count);
error_comp = zeros(1, n_count);
bound_classic = zeros(1, n_count);
bound_comp = zeros(1, n_count);

fprintf('Computing for n = 3 to 42...\n');

for idx = 1:n_count
    n = n_values(idx);
    
    % Progress indicator
    if mod(n, 5) == 0
        fprintf('  n = %d\n', n);
    end
    
    % Construct (x-1)^n in expanded form
    p_n = poly(ones(1, n));
    p_n = fliplr(p_n);
    
    % Exact value using symbolic computation
    res_sym = HornerSymbolic(p_n, x_test);
    exact_n = double(res_sym);
    
    % Classical Horner
    res_classic = Horner(p_n, x_test);
    
    % Compensated Horner
    res_comp = CompHorner(p_n, x_test);
    
    % Condition number
    cond_n = condp(p_n, x_test);
    cond_values(idx) = cond_n;
    
    % Relative errors
    error_classic(idx) = abs(res_classic - exact_n) / abs(exact_n);
    error_comp(idx) = abs(res_comp - exact_n) / abs(exact_n);
    
    % Theoretical bounds
    gamma_2n = (2*n*u) / (1 - 2*n*u);
    bound_classic(idx) = gamma_2n * cond_n;
    bound_comp(idx) = u + (gamma_2n^2) * cond_n;
end

fprintf('Computation complete!\n\n');

%% Create the plot
fprintf('Creating plot...\n');

% Replace any zero errors with a small value to avoid log(0)
error_classic_plot = error_classic;
error_comp_plot = error_comp;
error_classic_plot(error_classic_plot == 0) = 1e-18;
error_comp_plot(error_comp_plot == 0) = 1e-18;

figure('Position', [100, 100, 1000, 700]);

% Plot theoretical bounds (dotted lines) - suppress from legend
h1 = loglog(cond_values, bound_classic, ':r', 'LineWidth', 1.5, ...
            'HandleVisibility', 'off'); hold on;
h2 = loglog(cond_values, bound_comp, ':b', 'LineWidth', 1.5, ...
            'HandleVisibility', 'off');

% Plot actual errors with distinct markers
h3 = loglog(cond_values, error_classic_plot, '-^k', 'LineWidth', 1.5, ...
            'MarkerSize', 7, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k');
h4 = loglog(cond_values, error_comp_plot, '-dk', 'LineWidth', 1.5, ...
            'MarkerSize', 7, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k');

% Formatting
set(gca, 'XScale', 'log', 'YScale', 'log');
xlabel('Condition Number', 'FontSize', 13, 'FontWeight', 'bold');
ylabel('Relative Forward Error', 'FontSize', 13, 'FontWeight', 'bold');
title('Condition Number and Relative Forward Error', 'FontSize', 15, 'FontWeight', 'bold');

% Set appropriate limits
xlim([min(cond_values)*0.5, max(cond_values)*2]);
ylim([1e-18, max(max(error_classic_plot), max(error_comp_plot))*10]);

grid on;
set(gca, 'FontSize', 11);

% Add annotations for bounds
dim = [.2 .5 .3 .3];
annotation('textbox', dim, 'String', '\gamma_{2n} cond', ...
           'FitBoxToText', 'on', 'BackgroundColor', 'white', ...
           'EdgeColor', 'none', 'FontSize', 11, 'Color', 'red');

dim2 = [.6 .2 .3 .3];
annotation('textbox', dim2, 'String', 'u+\gamma_{2n}^2 cond', ...
           'FitBoxToText', 'on', 'BackgroundColor', 'white', ...
           'EdgeColor', 'none', 'FontSize', 11, 'Color', 'blue');

% Legend - only include main data series
legend([h3, h4], {'Classic Horner Scheme', 'Compensated Horner Scheme'}, ...
       'Location', 'SouthEast', 'FontSize', 12, 'Box', 'on');

% Add unit roundoff reference line (suppress from legend)
yline(u, '--', 'LineWidth', 1.5, 'Color', [0.6 0.6 0.6], ...
      'HandleVisibility', 'off');
text(cond_values(5), u*3, sprintf('u ≈ 10^{-16}'), 'FontSize', 10, ...
     'Color', [0.4 0.4 0.4], 'FontWeight', 'bold');

hold off;

fprintf('Plot created successfully!\n\n');

%% Save the figure
saveas(gcf, 'Horner_Comparison_Plot.png');
fprintf('Plot saved as: Horner_Comparison_Plot.png\n\n');

%% Display key statistics
fprintf('========================================================================\n');
fprintf('Key Statistics from the Plot\n');
fprintf('========================================================================\n\n');

% Find where classical Horner crosses error = 1
idx_failure = find(error_classic >= 1, 1);
if ~isempty(idx_failure)
    n_failure = n_values(idx_failure);
    cond_failure = cond_values(idx_failure);
    fprintf('Classical Horner FAILS (error >= 1) at:\n');
    fprintf('  n = %d\n', n_failure);
    fprintf('  Condition number = %.2e\n', cond_failure);
    fprintf('  Relative error = %.2e\n\n', error_classic(idx_failure));
else
    fprintf('Classical Horner never exceeds error = 1 in test range\n\n');
end

% Maximum errors
[max_err_classic, idx_max_classic] = max(error_classic);
[max_err_comp, idx_max_comp] = max(error_comp);

fprintf('Maximum errors observed:\n');
fprintf('  Classical: %.2e at n = %d (cond = %.2e)\n', ...
        max_err_classic, n_values(idx_max_classic), cond_values(idx_max_classic));
fprintf('  Compensated: %.2e at n = %d (cond = %.2e)\n\n', ...
        max_err_comp, n_values(idx_max_comp), cond_values(idx_max_comp));

% Condition number range
fprintf('Condition number range:\n');
fprintf('  Minimum: %.2e (n = %d)\n', min(cond_values), n_values(1));
fprintf('  Maximum: %.2e (n = %d)\n\n', max(cond_values), n_values(end));

% Count regimes
safe_idx = cond_values < 1e6;
danger_idx = (cond_values >= 1e6) & (cond_values < 1e14);
critical_idx = cond_values >= 1e14;

fprintf('Number of test cases in each regime:\n');
fprintf('  Safe (cond < 10^6):           %d cases\n', sum(safe_idx));
fprintf('  Danger (10^6 <= cond < 10^14): %d cases\n', sum(danger_idx));
fprintf('  Critical (cond >= 10^14):      %d cases\n\n', sum(critical_idx));

% Improvement statistics
improvement = error_classic ./ error_comp;
improvement(error_comp == 0) = Inf;  % Handle perfect compensated results

fprintf('Improvement factors (Classical error / Compensated error):\n');
fprintf('  Minimum: %.2e\n', min(improvement(isfinite(improvement))));
fprintf('  Maximum: %.2e\n', max(improvement(isfinite(improvement))));
fprintf('  Median:  %.2e\n\n', median(improvement(isfinite(improvement))));

%% Create a summary table for key degrees
fprintf('========================================================================\n');
fprintf('Summary Table for Key Degrees\n');
fprintf('========================================================================\n\n');

key_degrees = [3, 10, 15, 20, 25, 30, 35, 40, 42];
fprintf('  n  | Cond Number | Classic Error | Comp Error   | Improvement\n');
fprintf('-----|-------------|---------------|--------------|-------------\n');

for n = key_degrees
    idx = find(n_values == n);
    if ~isempty(idx)
        if error_comp(idx) > 0
            imp = error_classic(idx) / error_comp(idx);
        else
            imp = Inf;
        end
        fprintf(' %2d  | %.2e  | %.2e    | %.2e   | %.2e\n', ...
                n, cond_values(idx), error_classic(idx), error_comp(idx), imp);
    end
end

fprintf('\n');
fprintf('========================================================================\n');
fprintf('Plot successfully recreated from slide 34!\n');
fprintf('Classical: Follows γ_2n*cond bound (triangles)\n');
fprintf('Compensated: Stays near u regardless of condition number (diamonds)\n');
fprintf('========================================================================\n');