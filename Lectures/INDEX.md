# AFAE Lecture Index

> **Floating-Point Arithmetic and Error Analysis** — Master 2 CCA, Sorbonne University

---

## Lecture 1–2: Introduction & Floating-Point Arithmetic

📄 [slides.pdf](Lecture1-2/slides.pdf)

| Topic | Page |
|---|---|
| Introduction | 2 |
| Number representations | 9 |
| Representing numbers to compute with them | 21 |
| Floating-point arithmetic | 34 |
| Use of Computer Arithmetic: Historical Failures | 68 |
| Conclusion | 90 |

---

## Lecture 3: Error Analysis & Summation/Dot Product Algorithms

📄 [slides.pdf](Lecture3/slides.pdf)

| Topic | Page |
|---|---|
| Floating-point arithmetic (recap) | 2 |
| Error analysis and increase of accuracy | 5 |
| Summation algorithms | 20 |
| Dot product algorithms | 32 |
| Polynomial evaluation algorithms | 35 |

---

## Lecture 4: Numerical Validation Using Stochastic Arithmetic

📄 [slides_AFAE.pdf](Lecture4/slides_AFAE.pdf)

*Lecturer: Fabienne Jézéquel (LIP6)*

| Topic | Page |
|---|---|
| **Floating-Point Arithmetic & IEEE 754** | |
| Representation of real numbers | 3 |
| The IEEE 754 standard | 4 |
| Single / double / half precision | 5–6 |
| Rounding modes (4 modes of IEEE 754) | 7–8 |
| Inconsistency of floating-point arithmetic | 11 |
| Round-off error model | 12 |
| **The CESTAC Method** | |
| The CESTAC method (Contrôle et Estimation Stochastique des Arrondis de Calculs) | 15 |
| The random rounding mode | 16 |
| Student test for confidence interval | 18 |
| On the number of runs | 23 |
| Self-validation of the CESTAC method | 28 |
| **Stopping Criteria & Computational Zero** | |
| The problem of stopping criteria (iterative algorithms) | 29 |
| The concept of computational zero | 31 |
| Stochastic definitions | 32 |
| **The CADNA Library** | |
| The CADNA library — overview | 34 |
| CADNA — Discrete Stochastic Arithmetic implementation | 35 |
| Numerical debugging with CADNA | 36 |
| How to implement CADNA (6 steps) | 37 |
| Declaration, initialization, termination | 38–41 |
| Changes in type of variables | 42 |
| Changes in printing/reading statements | 43–45 |
| Rump's example with CADNA | 46–57 |
| Contributions of CADNA (direct methods) | 59 |
| Contributions of CADNA (iterative methods) | 61 |
| Approximation methods & dynamical control | 63–68 |
| Tools related to CADNA / SAM library | 69–72 |
| **Numerical Applications** | |
| Mandelbrot set computed on GPU with CADNA | 73–75 |
| Reproducibility failures in wave propagation code | 76–84 |
| Shallow-water simulation on GPU | 85–86 |
| **Precision Autotuning** | |
| Mixed precision for performance/energy efficiency | 88 |
| Precision autotuning tools overview | 89 |
| PROMISE (PRecision OptiMISE) | 95–101 |
| Precision auto-tuning using PROMISE — MICADO application | 102 |
| **Neural Network Precision Tuning** | |
| Neural network computing overview | 103–104 |
| Sine NN, MNIST NN, CIFAR NN, Pendulum NN | 105–119 |
| Conclusion & References | 120–122 |

---

## Lecture 5: Large Scale Rounding Error Analysis & Conditioning

📄 [slides.pdf](Lecture5/slides.pdf)

*Lecturer: Stef Graillat (LIP6/PEQUAN, Sorbonne University)*

| Topic | Page |
|---|---|
| Pioneers of rounding error analysis | 2 |
| Bibliography | 3 |
| Different sources of error | 4 |
| Objectives of rounding error analysis | 5 |
| Well-posed problems, ill-posed problems | 6 |
| Absolute error, relative error | 7 |
| Conditioning of a problem | 8 |
| Conditioning of polynomial evaluation | 9 |
| Conditioning for linear systems | 12–14 |
| Some remarks on the condition number | 15 |
| Error analysis | 16 |
| Forward error analysis | 18 |
| Backward error analysis | 19 |
| Advantages of backward error analysis | 20 |
| Stability of algorithms and backward error | 23 |
| Standard model for floating-point arithmetic | 24–26 |
| With underflow | 27 |
| Backward stability in finite precision | 28 |
| Accuracy of the solution | 29 |

---

## Lecture 6: Interval Analysis & Multiple Precision Arithmetic

📄 [slides.pdf](Lecture6/slides.pdf)

| Topic | Page |
|---|---|
| Interval analysis and self-validating methods | 3 |
| Multiple precision arithmetic | 41 |

---

## Lecture 7: Verified Solution of Linear Systems & Iterative Refinement

📄 Part 1: [slides1.pdf](Lecture7/slides1.pdf) — Verified Solution of Linear Systems

| Topic | Page |
|---|---|
| **Preliminary results** | 6 |
| Triangular linear systems | 6 |
| Inverse of triangular matrices | 10 |
| LU factorization and solution of linear systems | 13 |
| Normwise conditioning of linear systems | 22 |
| **Verified solution of linear systems** | 26 |
| General principle | 27 |
| Four methods to upper bound | 35 |
| Upper bound | 42 |
| Synthesis | 46 |
| Numerical experiments | 50 |
| References | 63 |

📄 Part 2: [slides2.pdf](Lecture7/slides2.pdf) — Iterative Refinement & Matrix Inversion

| Topic | Page |
|---|---|
| **Iterative refinement** | 2 |
| Error analysis | 5 |
| Computation of a verified solution | 11 |
| Numerical experiments | 15 |
| **Inversion of ill-conditioned matrices** | 22 |
| Statement of the problem | 23 |
| Rump's algorithm | 26 |
| Conclusion | 32 |
| References | 34 |

---

## Lecture 8: Compensated Algorithms & Probabilistic Error Analysis

📄 Part 1: [slides1.pdf](Lecture8/slides1.pdf) — Compensated Algorithms

| Topic | Page |
|---|---|
| Introduction | 2 |
| Dealing with accumulation | 13 |
| Dealing with cancellation | 23 |
| Adaptive precision summation | 60 |
| Conclusion | 71 |

📄 Part 2: [slides2.pdf](Lecture8/slides2.pdf) — Probabilistic Error Analysis

| Topic | Page |
|---|---|
| Introduction | 2 |
| Random data | 17 |
| Random errors | 24 |
| Stochastic rounding | 49 |
| Random data and random errors | 65 |

---

## Lecture 9–10: Precision Emulation, Linear Systems & Block Low-Rank Approximations

📄 [slides.pdf](Lecture9-10/slides.pdf)

| Topic | Page |
|---|---|
| Precision emulation | 2 |
| Linear systems | 44 |
| Block low-rank approximations | 98 |

---

## Lecture 11: Implementation of Mathematical Functions

📄 [slides.pdf](Lecture11/slides.pdf)

| Topic | Page |
|---|---|
| Introduction | 5 |
| Overview of the implementation of a function | 11 |
| Polynomial approximation | 19 |
| Argument reduction | 35 |
| How to obtain good performances? | 43 |
| Correctly rounded functions | 49 |
| Automation | 56 |
| Conclusion | 61 |

---

## Quick Reference: Where to Find a Topic

| Topic | Lecture |
|---|---|
| **Fundamentals** | |
| Number representations | [Lecture 1–2](Lecture1-2/slides.pdf) |
| IEEE 754 standard | [Lecture 1–2](Lecture1-2/slides.pdf), [Lecture 4](Lecture4/slides_AFAE.pdf) |
| Floating-point arithmetic | [Lecture 1–2](Lecture1-2/slides.pdf), [Lecture 3](Lecture3/slides.pdf) |
| Rounding modes | [Lecture 4](Lecture4/slides_AFAE.pdf) |
| Historical failures of computer arithmetic | [Lecture 1–2](Lecture1-2/slides.pdf) |
| **Error Analysis** | |
| Error analysis & increase of accuracy | [Lecture 3](Lecture3/slides.pdf) |
| Forward error analysis | [Lecture 5](Lecture5/slides.pdf) |
| Backward error analysis | [Lecture 5](Lecture5/slides.pdf) |
| Conditioning (general, polynomial, linear systems) | [Lecture 5](Lecture5/slides.pdf) |
| Stability of algorithms | [Lecture 5](Lecture5/slides.pdf) |
| Probabilistic / stochastic error analysis | [Lecture 8 Part 2](Lecture8/slides2.pdf) |
| Stochastic rounding | [Lecture 8 Part 2](Lecture8/slides2.pdf) |
| **Algorithms** | |
| Summation algorithms | [Lecture 3](Lecture3/slides.pdf) |
| Dot product algorithms | [Lecture 3](Lecture3/slides.pdf) |
| Polynomial evaluation algorithms | [Lecture 3](Lecture3/slides.pdf) |
| Compensated algorithms (accumulation, cancellation) | [Lecture 8 Part 1](Lecture8/slides1.pdf) |
| Adaptive precision summation | [Lecture 8 Part 1](Lecture8/slides1.pdf) |
| **Numerical Validation** | |
| CESTAC method | [Lecture 4](Lecture4/slides_AFAE.pdf) |
| CADNA library | [Lecture 4](Lecture4/slides_AFAE.pdf) |
| Discrete Stochastic Arithmetic (DSA) | [Lecture 4](Lecture4/slides_AFAE.pdf) |
| Numerical debugging | [Lecture 4](Lecture4/slides_AFAE.pdf) |
| Precision autotuning / PROMISE | [Lecture 4](Lecture4/slides_AFAE.pdf) |
| Neural network precision tuning | [Lecture 4](Lecture4/slides_AFAE.pdf) |
| **Interval & Verified Methods** | |
| Interval analysis and self-validating methods | [Lecture 6](Lecture6/slides.pdf) |
| Multiple precision arithmetic | [Lecture 6](Lecture6/slides.pdf) |
| Verified solution of linear systems | [Lecture 7 Part 1](Lecture7/slides1.pdf) |
| Iterative refinement | [Lecture 7 Part 2](Lecture7/slides2.pdf) |
| Inversion of ill-conditioned matrices | [Lecture 7 Part 2](Lecture7/slides2.pdf) |
| **Linear Algebra & Advanced Topics** | |
| LU factorization | [Lecture 7 Part 1](Lecture7/slides1.pdf) |
| Precision emulation | [Lecture 9–10](Lecture9-10/slides.pdf) |
| Linear systems (advanced) | [Lecture 9–10](Lecture9-10/slides.pdf) |
| Block low-rank approximations | [Lecture 9–10](Lecture9-10/slides.pdf) |
| **Function Implementation** | |
| Implementation of mathematical functions | [Lecture 11](Lecture11/slides.pdf) |
| Polynomial approximation | [Lecture 11](Lecture11/slides.pdf) |
| Argument reduction | [Lecture 11](Lecture11/slides.pdf) |
| Correctly rounded functions | [Lecture 11](Lecture11/slides.pdf) |
