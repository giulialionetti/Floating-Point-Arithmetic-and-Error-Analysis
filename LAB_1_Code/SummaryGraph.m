clear; close all; clc;

u = eps/2;              % unit roundoff
x = 1.333;              % punto di valutazione
n_list = 3:42;          % gradi del polinomio
gamma = @(k) (k*u)./(1 - k*u);

err = zeros(size(n_list));
condv = zeros(size(n_list));

for k = 1:numel(n_list)
    n = n_list(k);

    % polinomio p_n(x) = (x-1)^n
    p = fliplr(poly(ones(1,n)));   % [a0 ... an] per Horner

    % valore "vero" con alta precisione
    exact = double(vpa((vpa(x,100) - 1)^n, 100));

    % valutazione numerica
    y = Horner(p, x);

    % errore relativo
    err(k) = abs(y - exact) / max(abs(exact), realmin);

    % condizionamento norm-wise
    condv(k) = sum(abs(p).*abs(x).^(0:n)) / max(abs(y), realmin);
end

% bound teorico classico
b_class = gamma(2*n_list).*condv;

% --- grafico
figure('Color','w'); hold on; grid on; box on;
set(gca,'XScale','log','YScale','log');

plot(condv, err, 'k^-','DisplayName','Horner classico');
plot(condv, b_class, 'k:','DisplayName','\gamma_{2n}·cond');

xlabel('Condizionamento');
ylabel('Errore relativo');
title('Condizionamento ed errore relativo diretto — Horner classico');
legend('Location','northwest');
