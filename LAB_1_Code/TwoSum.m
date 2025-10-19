function [x, y] = TwoSum(a, b)
    % TwoSum: Error-Free Transformation for addition (Algorithm 1.2)
    % Computes a + b = x + y exactly in floating-point
    % NO precondition required (works for any a, b)
    %
    % Input:
    %   a, b: floating-point numbers
    % Output:
    %   x: rounded sum fl(a + b)
    %   y: exact rounding error
    %
    % Properties:
    %   - a + b = x + y (exactly)
    %   - |y| <= u|x|
    %   - |y| <= u|a + b|
    %
    % Cost: 6 flops (vs 3 for FastTwoSum)
    
    x = a + b;
    z = x - a;
    y = (a - (x - z)) + (b - z);
end