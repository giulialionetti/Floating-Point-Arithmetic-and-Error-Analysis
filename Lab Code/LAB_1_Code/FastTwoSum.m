function [x, y] = FastTwoSum(a, b)
    % Precondition: |a| >= |b|
    x = a + b;           % rounded sum
    y = (a - x) + b;     % exact error
end