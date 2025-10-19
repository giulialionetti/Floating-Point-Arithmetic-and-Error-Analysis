% Check condition numbers for high n
for n = [25, 30, 35, 40, 42]
    p = fliplr(poly(ones(1,n)));
    cond_val = condp(p, 1.333);
    fprintf('n=%d: cond = %.2e\n', n, cond_val);
end