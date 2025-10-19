function [x, y] = TwoProduct(a, b)
    % TwoProduct: Error-Free Transformation for multiplication (Algorithm 1.4)
    % Computes a * b = x + y exactly in floating-point
    %
    % Input:
    %   a, b: floating-point numbers
    % Output:
    %   x: rounded product fl(a * b)
    %   y: exact rounding error
    %
    % Properties:
    %   - a * b = x + y (exactly)
    %   - |y| <= u|x|
    %   - |y| <= u|a * b|
    %
    % Uses: Split algorithm (Dekker, 1971)
    % Cost: 17 flops (without FMA)
    %
    % Note: Modern processors with FMA can compute this in 2 flops:
    %   x = a * b
    %   y = fma(a, b, -x)
    
    % Compute rounded product
    x = a * b;
    
    % Split both operands
    [a1, a2] = Split(a);
    [b1, b2] = Split(b);
    
    % Compute exact error using Dekker's formula
    % y = a2*b2 - (((x - a1*b1) - a2*b1) - a1*b2)
    y = a2 * b2 - (((x - a1 * b1) - a2 * b1) - a1 * b2);
end