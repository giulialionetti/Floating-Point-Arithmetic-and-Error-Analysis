# AFAE — Mechanical Exercises Overview

> Exercises grouped by type, with direct links to solved examples.
> Focus on these for **efficient exam prep** — they follow repeatable procedures.

---

## 1. IEEE 754 Conversions & Representations

**What you need to do:** Convert decimal ↔ binary ↔ hex, identify sign/exponent/mantissa fields, handle special values (subnormals, ±∞, NaN).

| Skill | Procedure |
|---|---|
| Decimal → IEEE 754 binary | 1) Sign bit. 2) Convert to binary. 3) Normalize to `1.f × 2^E`. 4) Bias exponent. 5) Write mantissa. |
| IEEE 754 binary → Decimal | 1) Extract s/e/f. 2) Check special cases (e=0, e=all 1s). 3) Compute `(-1)^s × 1.f × 2^(e-bias)`. |
| Subnormal numbers | e=0, implicit bit is 0: value = `(-1)^s × 0.f × 2^(1-bias)`. |
| Rounding to nearest | Round to nearest representable; break ties to even. |

### Exercises to practice:

| Exercise | What it asks | Link |
|---|---|---|
| **Tutorial 2, Ex 2** — IEEE 754 single precision representations | Represent 13, 0.4375, −0.4375, 1+2⁻²⁴, 1+2⁻²⁴−2⁻²⁵, 1+2⁻²⁴+2⁻²⁵, 1/7, 2⁻¹³⁰ in binary32 | [tutorial_02.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/tutorial_02.pdf) |
| ↳ Solved | Full step-by-step for all 8 numbers including subnormal 2⁻¹³⁰ | [tutorial_02_solved.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/solutions/tutorial_02_solved.pdf) |
| **Tutorial 1, Ex 5** — Double precision hex/binary | Read double precision via hex union cast, decompose x into E and m | [tutorial_01.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/tutorial_01.pdf) (p.4) |
| ↳ Solved | Detailed IEEE 754 double precision bit extraction | [tutorial1_ex5_solved.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/solutions/tutorial1_ex5_solved.pdf) |
| **Tutorial 2, Ex 1** — Signed integer representations | Sign-magnitude, one's complement, two's complement for 19 and −19 | [tutorial_02.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/tutorial_02.pdf) |
| ↳ Solved | All three methods compared | [tutorial_02_solved.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/solutions/tutorial_02_solved.pdf) |

---

## 2. Fixed-Point Arithmetic

**What you need to do:** Determine bit-width, range, quantization step; convert reals to fixed-point; compute absolute/relative errors; design fixed-point realizations for expressions.

| Skill | Procedure |
|---|---|
| Format (m, l) — number of bits | `m - l + 1` (including sign bit at position m) |
| Range | `[-2^m, 2^m - 2^l]` |
| Quantization step | `Δ = 2^l` |
| Conversion to fixed-point | Convert to binary, truncate/round to nearest representable |
| Absolute error | `|x - fl(x)| ≤ Δ/2 = 2^(l-1)` |

### Exercises to practice:

| Exercise | What it asks | Link |
|---|---|---|
| **Exam Ex 5** — Fixed-point arithmetic (6 pts) | Format (6,−4) properties; represent 9.3452, 0.03434, −2.18625 in 8-bit; compute errors; design fixed-point realization for `9.3452x + 0.03434y − 2.18625z` with 8×8→16 multiplier | [exam-CCA.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/exam-CCA.pdf) (p.3) |
| ↳ Solved | Complete step-by-step for all 4 parts | [ex_5_solved.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/solutions/ex_5_solved.pdf) |

---

## 3. Floating-Point Arithmetic: fl() Computations & Absorption

**What you need to do:** Apply the standard model `fl(a ∘ b) = (a ∘ b)(1+δ)` with `|δ| ≤ u`; trace through specific computations; identify absorption/cancellation.

| Skill | Procedure |
|---|---|
| Standard model application | Write `fl(x ∘ y) = (x ∘ y)(1+δ)`, `|δ| ≤ u`, chain for multiple ops |
| Absorption detection | `fl(M + x) = M` when `|x| < ulp(M)/2` |
| Cancellation detection | `fl(a - b)` when a ≈ b: relative error blows up |
| Products in [1,2) | Spacing is `u = 2⁻⁵³`, so `fl(result)` is either floor or ceil |

### Exercises to practice:

| Exercise | What it asks | Link |
|---|---|---|
| **Exam Ex 1** — fl(x × fl(1/x)) analysis (4 pts) | Show result is either 1 or 1−u for x ∈ [1,2) in double precision | [exam-CCA.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/exam-CCA.pdf) (p.1) |
| ↳ Solved (+ variations) | Step-by-step error model application, 3 variations included | [ex_1_solved_and_some_variations.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/solutions/ex_1_solved_and_some_variations.pdf) |
| **Exam Ex 2** — Absorption in recursive summation (4 pts) | Find possible values of `fl(Σxᵢ)` for {1,2,3,4,M,−M} with absorption | [exam-CCA.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/exam-CCA.pdf) (p.1) |
| ↳ Solved (+ variations) | All permutation cases analyzed | [ex_2_solved_with_variations.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/solutions/ex_2_solved_with_variations.pdf) |
| **Tutorial 2, Ex 2.2** — Product a⊗b in single precision | Compute fl(4097 × 8449) step by step with rounding | [tutorial_02.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/tutorial_02.pdf) |
| ↳ Solved | Bit-level product and rounding analysis | [tutorial_02_solved.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/solutions/tutorial_02_solved.pdf) |

---

## 4. EFT Algorithms: FastTwoSum / TwoSum / TwoProduct

**What you need to do:** Trace algorithms step by step; prove `s + t = a + b` exactly; show what breaks with directed rounding; provide counterexamples.

| Algorithm | Key Property |
|---|---|
| `FastTwoSum(a,b)` → `[s,t]` | `s + t = a + b` exactly (requires `|a|≥|b|`, round-to-nearest) |
| `TwoSum(a,b)` → `[s,t]` | `s + t = a + b` exactly (no ordering requirement, round-to-nearest) |
| `TwoProduct(a,b)` → `[p,e]` | `p + e = a × b` exactly (uses FMA or Dekker splitting) |

### Exercises to practice:

| Exercise | What it asks | Link |
|---|---|---|
| **Exam Ex 3** — FastTwoSum with directed rounding (4 pts) | Show `s+t = a+b` fails with rounding toward +∞; provide counterexample; prove `z = s−a` is exact | [exam-CCA.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/exam-CCA.pdf) (p.1) |
| ↳ Solved (+ 5 variations) | Counterexamples for all directed rounding modes, full proofs | [ex_3_solved_with_variations.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/solutions/ex_3_solved_with_variations.pdf) |
| **More Exercises — TwoProduct with directed rounding** | Same pattern as Ex 3 but for multiplication; counterexample + Sterbenz analysis | [twoproduct_exercise.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/more%20exercises/twoproduct_exercise.pdf) |
| **Lab 1 code** — FastTwoSum, TwoSum, TwoProduct, Split | MATLAB implementations with test scripts | [Lab Code/LAB_1_Code/](Floating-Point-Arithmetic-and-Error-Analysis/Lab%20Code/LAB_1_Code/) |

---

## 5. Summation & Error Bound Analysis

**What you need to do:** Draw summation trees; derive backward error bounds using γₙ notation; compare algorithms (recursive, pairwise, compensated, mixed precision).

| Key formula | Meaning |
|---|---|
| Recursive sum: `|θᵢ| ≤ γₙ₋₁` | `γₙ = nu/(1-nu)` |
| Pairwise sum: `|θᵢ| ≤ γ_⌈log₂n⌉` | Tree depth reduces error |
| Compensated sum (Kahan): error `≈ u` | Uses EFT to capture errors |

### Exercises to practice:

| Exercise | What it asks | Link |
|---|---|---|
| **Exam Ex 7** — Mixed precision blocked summation (3 pts) | Draw tree for n=12, b₁=3, b₂=2; derive `f(n,b₁,b₂,u₁,u₂,u₃)` bound; find optimal b₁,b₂; assign fp64/32/16 to u₁,u₂,u₃ | [exam-CCA.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/exam-CCA.pdf) (p.4) |
| ↳ Solved (+ variations) | Tree diagram, backward error derivation, optimal choices | [ex_7_solved_with_variations.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/solutions/ex_7_solved_with_variations.pdf) |
| **Tutorial 3, Ex 1** — Summation condition number + backward stability | Prove cond(Σpᵢ); prove recursive summation backward-stable; bound relative error; redo for dot product | [tutorial_03.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/tutorial_03.pdf) |
| ↳ Solved | Full proofs for summation and dot product | [tutorial_03_solved.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/solutions/tutorial_03_solved.pdf) |

---

## 6. CESTAC / CADNA / Discrete Stochastic Arithmetic (DSA)

**What you need to do:** Interpret CADNA output; compare DSA vs classic floating-point results; identify instability types (cancellation, convergence, branching); explain when DSA over/underestimates accuracy.

| Concept | Key fact |
|---|---|
| CADNA runs N=3 samples | Random rounding → estimate significant digits |
| Instability types | Cancellation (most common), unstable branching, unstable multiplication |
| Computational zero (`@.0`) | Result has no significant digits → numerically zero |
| `fl(a−b)` cancellation | CADNA detects loss of accuracy when `a ≈ b` |

### Exercises to practice:

| Exercise | What it asks | Link |
|---|---|---|
| **Exam Ex 4** — Stochastic arithmetic / CADNA analysis (4 pts) | Solve linear system AX=B; compare binary32 classic vs DSA results; identify cancellation instability; analyze binary64 improvement | [exam-CCA.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/exam-CCA.pdf) (p.2) |
| ↳ Solved | Gaussian elimination trace, DSA output interpretation, instability explanation | [ex_4_solved.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/solutions/ex_4_solved.pdf) |
| **Lab 2 code** — CADNA programs | Gauss, Hilbert, Jacobi, logistic, Muller, Newton, Rump examples with `_cad` versions | [Lab Code/LAB_2_Code/](Floating-Point-Arithmetic-and-Error-Analysis/Lab%20Code/LAB_2_Code/) |

---

## 7. Rounding Error Analysis: Stochastic vs Deterministic Rounding

**What you need to do:** Interpret backward error plots; explain why SR gives √(nu) growth vs nu for deterministic; compare RTN, RZ, SR.

| Rounding mode | Error growth | Why |
|---|---|---|
| Round-to-Zero (RZ) | `O(nu)` — linear | Systematic bias, errors accumulate coherently |
| Round-to-Nearest (RTN) | Between `O(√nu)` and `O(nu)` | Some cancellation but not guaranteed |
| Stochastic Rounding (SR) | `O(√nu)` | Unbiased `E[fl(x)] = x`, errors are independent → CLT applies |

### Exercises to practice:

| Exercise | What it asks | Link |
|---|---|---|
| **Exam Ex 6** — Rounding error in matrix-vector products (3 pts) | Analyze backward error plot for fp16 y=Ax comparing RTN, RZ, SR; explain growth rates | [exam-CCA.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/exam-CCA.pdf) (p.3) |
| ↳ Solved | Full plot analysis with theoretical justification | [ex_6_solved.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/solutions/ex_6_solved.pdf) |

---

## 8. Mixed Precision Iterative Refinement

**What you need to do:** Fill in error tables given κ(A) and precision assignments; apply the rule `ε ≈ max{κ·u_f, (κ·max{u_f, u_r})^(k+1)}`.

| Key rule | Meaning |
|---|---|
| `ε_fwd ≥ κ · u_f` | Factorization precision sets the floor |
| High `u_r` helps convergence | Better residual → faster convergence per iteration |
| More iterations don't help if `u_f` is bad | Can't refine past `κ · u_f` |

### Exercises to practice:

| Exercise | What it asks | Link |
|---|---|---|
| **Exam Ex 8** — Mixed precision iterative refinement (2 pts) | Complete table: 7 precision configurations × {1, 10} iterations for κ(A)=10³ | [exam-CCA.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/exam-CCA.pdf) (p.4–5) |
| ↳ Solved (+ variations) | Completed table with reasoning for each cell | [ex_8_solved_with_variations.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/solutions/ex_8_solved_with_variations.pdf) |

---

## 9. Conditioning & Error Analysis (more proof-heavy)

**What you need to do:** Compute condition numbers; apply forward/backward error analysis framework; prove backward stability.

### Exercises to practice:

| Exercise | What it asks | Link |
|---|---|---|
| **Tutorial 3, Ex 1** — Summation & dot product conditioning + stability | Prove condition number formula; prove backward stability; derive error bounds | [tutorial_03.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/tutorial_03.pdf) |
| ↳ Solved | | [tutorial_03_solved.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/solutions/tutorial_03_solved.pdf) |
| **Tutorial 3, Ex 2** — Polynomial evaluation conditioning | Condition number of Horner's method | [tutorial_03.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/tutorial_03.pdf) |
| ↳ Solved | | [tutorial_03_solved.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/solutions/tutorial_03_solved.pdf) |
| **Tutorial 3, Ex 4** — Conditioning of matrix inverse | Prove κ(A) = ‖A‖·‖A⁻¹‖; distance to singularity; singular value connection | [tutorial_03.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/tutorial_03.pdf) (p.2) |
| ↳ Solved | | [tutorial_03_solved.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Tutorials/solutions/tutorial_03_solved.pdf) |
| **More Exercises — Multiple roots** | Interval arithmetic verification of ill-conditioned polynomial roots | [multiple roots problem.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/more%20exercises/Numerical%20Example%20of%20the%20multiple%20roots%20problem.pdf) |

---

## 10. Multi-Precision & Interval Arithmetic

**What you need to do:** Perform interval operations; understand inclusion property; apply to verification.

| Operation | Rule |
|---|---|
| `[a,b] + [c,d]` | `[a+c, b+d]` |
| `[a,b] − [c,d]` | `[a−d, b−c]` |
| `[a,b] × [c,d]` | `[min(ac,ad,bc,bd), max(ac,ad,bc,bd)]` |
| `1/[c,d]` (0∉[c,d]) | `[1/d, 1/c]` |

### Exercises to practice:

| Exercise | What it asks | Link |
|---|---|---|
| **More Exercises — Multiple roots** | Apply interval Newton to verify roots of degree-7 polynomial; Krawczyk operator | [multiple roots problem.pdf](Floating-Point-Arithmetic-and-Error-Analysis/Exam/more%20exercises/Numerical%20Example%20of%20the%20multiple%20roots%20problem.pdf) |
| **Lab 3 code** — Intlab exercises | MATLAB interval arithmetic with INTLAB | [Lab Code/LAB_3_Code/](Floating-Point-Arithmetic-and-Error-Analysis/Lab%20Code/LAB_3_Code/) |

---

## Suggested Study Order (most mechanical → most proof-heavy)

| Priority | Category | Time needed | Payoff |
|---|---|---|---|
| ⭐⭐⭐ | 1. IEEE 754 Conversions | 30 min | Very high — pure procedure |
| ⭐⭐⭐ | 2. Fixed-Point Arithmetic | 30 min | Very high — pure procedure |
| ⭐⭐⭐ | 3. fl() Computations & Absorption | 45 min | Very high — apply standard model |
| ⭐⭐⭐ | 8. Mixed Precision IR Table | 20 min | Very high — just apply one formula |
| ⭐⭐ | 6. CADNA / DSA Interpretation | 30 min | High — conceptual, read & understand |
| ⭐⭐ | 7. Rounding Mode Comparison | 20 min | High — memorize 3 growth rates |
| ⭐⭐ | 4. EFT Algorithms (FastTwoSum etc.) | 45 min | High — step-by-step + counterexamples |
| ⭐⭐ | 5. Summation Trees & Error Bounds | 45 min | Medium-high — draw tree + formula |
| ⭐ | 9. Conditioning & Proofs | 60 min | Lower — more mathematical |
| ⭐ | 10. Interval Arithmetic | 30 min | Lower — less likely on exam |
