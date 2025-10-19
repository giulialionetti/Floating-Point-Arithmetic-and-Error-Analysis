function [x, y] = Split(a)
    % Split: Error-free split of a floating-point number (Algorithm 1.3)
    % Splits a into two non-overlapping parts x and y such that:
    %   a = x + y, with |y| <= |x|
    %
    % Input:
    %   a: floating-point number
    % Output:
    %   x: high-order part
    %   y: low-order part
    %
    % Properties:
    %   - a = x + y (exactly)
    %   - x and y are non-overlapping
    %   - Used in TwoProduct algorithm
    %
    % For double precision: p = 53, s = 27
    % factor = 2^27 + 1 = 134217729
    
    s = 27;  % ceil(p/2) where p = 53 for double precision
    factor = 2^s + 1;
    
    c = factor * a;
    x = c - (c - a);
    y = a - x;
end