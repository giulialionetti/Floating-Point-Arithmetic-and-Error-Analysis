clc
addpath("G:\Il mio Drive\APPLIED MATHEMATICS\AFAE\intlab")
startintlab

%% Exercise 1: Range of f(x) = x^2 - 4x on X = [1, 4]
disp('--- Exercise 1 ---');

X = infsup(1, 4); % interval definition

% Three equivalent expressions
f1 = X.^2 - 4*X;
f2 = X .* (X - 4);
f3 = (X - 2).^2 - 4;

disp('f1 = X^2 - 4X => '); disp(f1);
disp('f2 = X*(X - 4) => '); disp(f2);
disp('f3 = (X - 2)^2 - 4 => '); disp(f3);
disp('Note: f3 gives tighter bounds due to reduced dependency problem.');
% Interpretation:
% The three expressions give different enclosures for f(X) on [1,4].
%   f1 = X.^2 - 4*X   →  [-15, 12]
%   f2 = X.*(X - 4)   →  [-12, 0]
%   f3 = (X - 2).^2 - 4 → [-4, 0]
%
% The exact mathematical range of f(x) = x^2 - 4x on [1,4] is [-4, 0].
% Only f3 matches this range accurately.
%
% Reason:
% Interval arithmetic suffers from the "dependency problem" — X appears
% multiple times in f1 and f2, causing overestimation of bounds.
% In f3, the expression is reformulated to minimize variable repetition,
% reducing dependency and producing a much tighter enclosure.
    
%% 

%% Exercise 2: Invertibility of a matrix
clc; clear; format long;
disp('--- Exercise 2 ---');

n = 3;
A = rand(n); % random matrix
R = inv(mid(A)); % approximate inverse using midpoint
I = eye(n);

normVal = norm(I - R*A,1);

if normVal < 1
    disp('Matrix A is invertible.');
else
    disp('Matrix A might be singular or nearly singular.');
end

% Interval verification
% MATLAB dp has machine epsilon ≈ 2.22e−16, we choose eps of 1e-14 
Aint = infsup(A - 1e-14, A + 1e-14); 
Rint = inv(Aint);
disp(Rint * Aint)
disp('Certified invertibility checked via interval inversion:');
disp(Rint);

% Interpretation (Exercise 2):
% We take R ≈ inv(mid(A)) as an approximate inverse of A.
% If the matrix norm ||I - R*A||_1 is smaller than 1,
% then A must be invertible (nonsingular).
%
% Reason:
% When ||I - R*A|| < 1, the matrix (I - (I - R*A)) can be written
% as a convergent Neumann series, which means it has an inverse.
% Therefore, A itself must also be invertible.
%
% If inv(Aint) produces a finite interval matrix (no large or infinite bounds),
% that confirms A is nonsingular for all possible values within Aint.
% A "blow-up" or huge radii would mean A is close to singular.

%% Exercise 3.1  Interval Gaussian Elimination Solver
clc; clear; format long;
disp('--- Exercise 3.1 ---');

% 1. Define system A*x = b with known exact solution x = ones(n,1)
n = 4;

% Hilbert matrix is ill-conditioned but invertible
A = hilb(n);

% Construct b so that the true solution is x = ones(n,1)
b = sum(A,2);

% Create interval versions of A and b
eps = 1e-14;
Aint = infsup(A - eps, A + eps);
bint = infsup(b - eps, b + eps);

% Interval Gaussian Elimination 
Awork = Aint;
bwork = bint;
det_sign = 1;

for k = 1:n-1
    % choose largest midpoint in column k 
    [~, p] = max(abs(mid(Awork(k:n,k))));
    p = p + k - 1;
    if p ~= k
        % Swap rows in both A and b
        tmp = Awork(k,:); Awork(k,:) = Awork(p,:); Awork(p,:) = tmp;
        tb  = bwork(k);   bwork(k)   = bwork(p);   bwork(p)   = tb;
        det_sign = -det_sign;
    end

    % Elimination step
    for i = k+1:n
        m = Awork(i,k) / Awork(k,k);
        Awork(i,k:n) = Awork(i,k:n) - m*Awork(k,k:n);
        bwork(i)     = bwork(i) - m*bwork(k);
        Awork(i,k)   = intval(0);  
    end
end

% Back substitution
xint = intval(zeros(n,1));
xint(n) = bwork(n) / Awork(n,n);
for i = n-1:-1:1
    rhs = bwork(i) - Awork(i,i+1:n) * xint(i+1:n);
    xint(i) = rhs / Awork(i,i);
end

% Results
disp('Interval solution enclosure xint:');
disp(xint);

% Check if enclosure contains the true solution (x = ones)
disp('Each interval should contain 1:');
disp(all(inf(xint) <= 1 & sup(xint) >= 1));

% Verify enclosure consistency: Aint*xint ⊂ bint ?
disp('Check inclusion Aint*xint ⊂ bint:');
disp(all(inf(Aint*xint) <= sup(bint) & sup(Aint*xint) >= inf(bint)));

% Interval solution enclosure xint:
%   1.00000000______
%   1.00000000______
%   1.00000000______
%   1.00000000______
% Each interval should contain 1:
%   1
% Check inclusion Aint*xint ⊂ bint:
%   1

% Interpretation (Exercise 3.1):
% xint shows the interval enclosure for each component of the true solution.
% "Each interval should contain 1" verifies that the true solution x = ones(n,1)
% lies inside the computed enclosure (1 = true).
% "Aint*xint ⊂ bint" confirms that the interval solution is self-consistent:
% when substituting xint back into A*x = b, the resulting interval still
% falls within the known uncertainty range of b.
% Since both checks return 1, the interval GE solver correctly
% encloses the exact solution of the system.

%% 3.2
disp('--- Exercise 3.2 ---');

% solves A*x = b using interval Gaussian elimination (x = A^{-1}b)
xint = Aint \ bint;
% This formulation is correct, we checked with
disp('enclsure check to make sure we compute correct: Aint*xint ⊂ bint =')
disp(all(inf(Aint*xint) <= sup(bint) & sup(Aint*xint) >= inf(bint)))
disp('Interval solution enclosure X:');
disp(xint);

% Comment:
% The true solution is x = ones(n,1).
% The enclosure bounds should contain 1 in each component
% and be very narrow if A,b are well-conditioned.

% approximate inverse --> we estimate based on A
% R depends on A, so we compute it from Aint to reflect uncertainty in A.  
% I is the exact identity matrix for computational purpose,
% so we don't give it a range.  

R = inv(mid(Aint));        
I = eye(n);
X = xint; % candidate interval 

% we assume 
disp("we assume: b+(I−RA)X⊂int(X) which is...")
disp(all(inf(R*bint + (I - R*Aint)*X) > inf(X) & sup(R*bint + (I - R*Aint)*X) < sup(X)))

KX = R*bint + (I - R*Aint)*X;

disp('Krawczyk inclusion test K(X) = Rb + (I - RA)X:');
disp(KX);

% Check inclusion numerically
disp( 'Inclusion verified: if K(X) ⊂ int(X) is equal to one...')
disp(all( inf(KX) > inf(X) & sup(KX) < sup(X) ))

%enclsure check to make sure we compute correct: Aint*xint ⊂ bint =
%   1
%Interval solution enclosure X:
%   1.0000000000____
%   1.000000000_____
%   1.000000000_____
%   1.000000000_____
%we assume: b+(I−RA)X⊂int(X) which is...
%   1
%Krawczyk inclusion test K(X) = Rb + (I - RA)X:
%   1.0000000000____
%   1.000000000_____
%   1.000000000_____
%   1.000000000_____
%Inclusion verified: if K(X) ⊂ int(X) is equal to one...
%   1

% Interpretation (Exercise 3.2):
% xint shows the interval enclosure for each component of the true solution.
% "Each interval should contain 1" verifies that the true solution x = ones(n,1)
% lies inside the computed enclosure (1 = true).
% "Aint*xint ⊂ bint" confirms that the interval solution is self-consistent:
% when substituting xint back into A*x = b, the resulting interval still
% falls within the known uncertainty range of b.
% Since both checks return 1, the interval GE solver correctly
% encloses the exact solution of the system.


%% 3.3  Determinant inclusion using interval Gaussian elimination
disp('--- Exercise 3.3 ---');

% copy of interval matrix
Awork = Aint;
n = size(Aint,1);
det_sign = 1;           % track sign changes from row swaps

for k = 1:n-1
    % Pivot: choose largest midpoint entry in column k
    [~, p] = max(abs(mid(Awork(k:n,k))));
    p = p + k - 1;
    if p ~= k
        tmp = Awork(k,:); Awork(k,:) = Awork(p,:); Awork(p,:) = tmp;
        det_sign = -det_sign;     % row swap flips determinant sign
    end
    % Elimination
    for i = k+1:n
        m = Awork(i,k) / Awork(k,k);
        Awork(i,k:n) = Awork(i,k:n) - m*Awork(k,k:n);
    end
end
% Now we have a upper triangular version of A_int
disp('Awork = ')
disp(Awork)

% Determiniant for UT matrix is given by
det_int = det_sign * prod(diag(Awork));
disp('Interval enclosure of det(A):'); 
disp(det_int);


if inf(det_int) > 0 || sup(det_int) < 0
    disp('Determinant interval does NOT include 0 --> A is proven nonsingular.');
else
    disp('Determinant interval includes 0: cannot certify invertibility.');
end

det_mid = det(mid(Aint));  % determinant of midpoint matrix
fprintf('Det(mid(A)) = %.18e\n', det_mid);
fprintf('Width of determinant interval: %.2e\n', diam(det_int));

%--- Exercise 3.3 ---
%Awork = 
%   1.00000000000000   0.50000000000000   0.3333333333333_   0.25000000000000
%  -0.0000000000000_   0.0833333333333_   0.0888888888889_   0.0833333333333_
%  -0.0000000000000_  -0.0000000000000_  -0.005555555556__  -0.008333333333__
%  -0.0000000000000_   0.0000000000000_   0.000000000000__   0.000357142857__
%Interval enclosure of det(A):
%  1.0e-006 *
%   0.165343915_____
%Determinant interval does NOT include 0 --> A is proven nonsingular.
%Det(mid(A)) = 1.653439153439300098e-07
%Width of determinant interval: 2.80e-16

% Interpretation (Exercise 3.3):
% After GE, Awork is upper triangular, and the determinant is obtained as 
% the product of its diagonal entries (times the row-swap sign).
% The resulting interval enclosure (≈ 1.65×10⁻⁷) is very narrow and does 
% not include zero, which confirms that the Hilbert matrix is provably 
% nonsingular. The small determinant value also illustrates the matrix's
% strong ill-conditioning.

%% 3.4 Gerschgorin circles implemted on GE pivotting 
% This last implementation uses Gershgorin circles to guide pivoting during 
% GE. At each iteration, we check whether any Gershgorin disc of the 
% current submatrix includes zero. 
% 
% If it does, that means the corresponding diagonal element is not strongly 
% dominant, so dividing by it could cause numerical instability or large 
% interval widening. To prevent this, we identify the row with the largest 
% Gershgorin margin -> the most diagonally dominant row.
% Then we swap it to the pivot position. 

% This improves conditioning in the intermediate steps, 
% reducing error growth and leading to a tighter ad more reliable interval 
% enclosure.
disp('--- Exercise 3.4 ---');

% copy of interval matrix
Awork = Aint;           
% define n
n = size(Aint,1);
% track sign changes from row swaps
det_sign = 1;           

for k = 1:n-1
    % --- Extract current submatrix ---
    subA = Awork(k:n, k:n);
    mSub = mid(subA);
    magSub = mag(subA);

    % --- Compute Gershgorin margins for each candidate row ---
    diag_center = abs(diag(mSub));
    row_offdiag = sum(magSub,2) - diag(magSub);
    margins = diag_center - row_offdiag;

    % --- Choose pivot row with largest positive margin ---
    [~, rel_pivot] = max(margins);
    p = rel_pivot + k - 1;

    % --- If Gershgorin check shows poor dominance, warn and pivot ---
    if margins(rel_pivot) <= 0
        fprintf('Step %d: Some discs include 0, swapping to improve dominance.\n', k);
    end
    if p ~= k
        tmp = Awork(k,:); Awork(k,:) = Awork(p,:); Awork(p,:) = tmp;
        det_sign = -det_sign;
        fprintf(' Swapped rows %d and %d.\n', k, p);
    end

    % --- Standard elimination step ---
    for i = k+1:n
        m = Awork(i,k) / Awork(k,k);
        Awork(i,k:n) = Awork(i,k:n) - m*Awork(k,k:n);
    end
end

% --- Determinant enclosure from resulting upper-triangular interval matrix ---
disp('Upper-triangular interval matrix after Gershgorin-guided elimination:');
disp(Awork);

det_int = det_sign * prod(diag(Awork));
disp('Interval enclosure of det(A):');
disp(det_int);

det_mid = det(mid(Aint));
fprintf('Det(mid(A)) = %.18e\n', det_mid);
fprintf('Width of determinant interval: %.2e\n', diam(det_int));

% --- Verify nonsingularity ---
if inf(det_int) > 0 || sup(det_int) < 0
    disp('Determinant interval excludes 0 → matrix proven nonsingular.');
else
    disp('Determinant interval includes 0 → cannot certify invertibility.');
end

%--- Exercise 3.4 ---
% Step 1: Some discs include 0, swapping to improve dominance.
% Step 2: Some discs include 0, swapping to improve dominance.
%  Swapped rows 3 and 4.
% Upper-triangular interval matrix after Gershgorin-guided elimination:
%    1.00000000000000   0.50000000000000   0.3333333333333_   0.25000000000000
%   -0.0000000000000_   0.0833333333333_   0.0833333333333_   0.0750000000000_
%   -0.0000000000000_   0.0000000000000_   0.008333333333__   0.012857142857__
%   -0.0000000000000_  -0.0000000000000_   0.000000000000__  -0.000238095238__
% Interval enclosure of det(A):
%   1.0e-006 *
%    0.165343915_____
% Det(mid(A)) = 1.653439153439300098e-07
% Width of determinant interval: 4.46e-16
% Determinant interval excludes 0 → matrix proven nonsingular.

% We used Gershgorin discs on each GE step to pick a more diagonally dominant
% pivot row when a disc included 0 (weak dominance). This changed the
% elimination path (note the row swap at step 2) and produced a clean
% upper-triangular Awork.
%
% Outcome:
% The determinant enclosure matches the earlier result (~1.6534e−7) and 
% still excludes 0, so nonsingularity is certified.
% Here, the interval width is slightly different (4.46e−16 vs 
% 2.80e−16 before): Gershgorin pivoting improves robustness but doesn't 
% guarantee a tighter enclosure every time. The method is valuable when 
% naive pivoting risks dividing by weak pivots or when discs suggest 
% potential instability; it can reduce overestimation in tougher cases.


%% Demonstration of the Gershgorin-enhanced method 
% In the Hilbert example, both the standard and Gershgorin-guided methods 
% gave similar determinant intervals. To better show the distinct strengths 
% of each approach, we now test two contrasting matrices:
%
%  (1) A nearly diagonal matrix with a very weak first pivot — used to 
%      demonstrate how Gershgorin may *overreact*, widening intervals.
%
%  (2) A badly scaled Hilbert matrix — used to demonstrate how Gershgorin 
%      pivoting improves *robustness* in highly ill-conditioned systems.
%
% Both cases use the same determinant-inclusion framework from 3.3
% and 3.4 for comparison.

%% Case 1: Weak-first-pivot, nearly diagonally dominant
% Goal: show that Gershgorin can detect potential instability, we want to
% know how this propagates to our final range.

n = 8; epsA = 1e-14;
A = eye(n);
A(1,1) = 1e-12;                    % very weak first pivot
A(1,2:end) = 0.9/(n-1);            % large off-diagonals in row 1
for i = 2:n
    A(i,i) = 1;
    A(i,[1:i-1,i+1:end]) = 1e-2;   % small off-diagonals elsewhere
end

A = A + 1e-12*randn(n);            % tiny perturbation
b = A*ones(n,1);

Aint = infsup(A - epsA, A + epsA);  bint = infsup(b - epsA, b + epsA);


% Results:
% Exercise 3.3 (standard GE)
%   det(A) ≈ [-0.008473321344, -0.008473321343] → narrow interval, excludes 0
% Exercise 3.4 (Gershgorin pivoting)
%   det(A) ≈ 1e+12 * [-0.686, 1.911] → very wide interval, includes 0

% Interpretation:
% Gershgorin identified the weak first pivot and applied large corrections, 
% which unnecessarily inflated the interval enclosure by over 10¹²×.
% The standard GE handled this structured system better, proving that the 
% tiny first pivot was still numerically stable. Gershgorin is thus more 
% conservative here — robust but overly cautious.

%% Case 2: Badly scaled Hilbert matrix
% Goal: show that Gershgorin pivoting can prevent catastrophic rounding or 
% divergence in ill-conditioned systems.

n = 8; epsA = 1e-14;
S = diag(10.^linspace(0,6,n));     % heavy row scaling
A = S * hilb(n);
b = A*ones(n,1);
Aint = infsup(A - epsA, A + epsA);  bint = infsup(b - epsA, b + epsA);

% Results:
% Exercise 3.3 (standard GE)
%   det(A) ≈ 1e-8 * [0.27, 0.27] → narrow, excludes 0
% Exercise 3.4 (Gershgorin pivoting)
%   det(A) ≈ 1e-8 * [0, 0.__] → widened interval, includes 0

% Interpretation:
% The heavy scaling made several pivots extremely small. While the standard 
% GE still produced a finite determinant, its stability is not guaranteed. 
% Gershgorin pivoting detected these weak pivots and rearranged rows to 
% preserve numerical safety, even though this widened the determinant 
% interval. In real ill-conditioned problems, that trade-off is preferable 
% because it prevents arithmetic blow-up and maintains a valid inclusion.