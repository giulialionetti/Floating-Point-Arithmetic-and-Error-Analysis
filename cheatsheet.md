# Floating-Point Arithmetic — Exam Cheat Sheet

---

## 1. Number Representations

### 1.1 Fixed-Point Representation

A fixed-point number has a **fixed number of digits** before and after the radix point. The scaling factor is constant.

**Format:** Given $w$ total bits, $i$ integer bits, $f$ fractional bits, and 1 sign bit:

$$x = (-1)^s \cdot \sum_{k=-f}^{i-1} b_k \cdot 2^{k}$$

**Example — Represent $6.75$ in fixed-point with 4 integer bits, 4 fractional bits:**

| Step | Computation |
|---|---|
| Integer: $6_{10}$ | $= 0110_2$ |
| Fraction: $0.75_{10}$ | $= 0.5 + 0.25 = 0.11_2$ |
| Combined | $0110.1100$ |
| Stored (sign=0) | `0 0110 1100` |

**Example — Represent $-3.125$ in fixed-point (1 sign + 4 int + 4 frac):**

| Step | Computation |
|---|---|
| Integer: $3_{10}$ | $= 0011_2$ |
| Fraction: $0.125_{10}$ | $= 0.001_2$ |
| Sign = 1 (negative) | |
| Stored | `1 0011 0010` |

**Key properties:**
- Range: $[-2^{i-1}, 2^{i-1} - 2^{-f}]$
- Resolution (smallest step): $2^{-f}$
- **Pro:** Predictable precision, simple hardware
- **Con:** Very limited range

---

### 1.2 Floating-Point Representation (IEEE 754)

A floating-point number $x$ is:

$$x = (-1)^s \times (1.f) \times 2^{e - \text{bias}}$$

| Component | Description |
|---|---|
| $s$ | Sign bit (0 = positive, 1 = negative) |
| $e$ | Biased exponent (stored as unsigned integer) |
| $f$ | Fractional mantissa (the leading 1 is implicit) |

#### IEEE 754 Formats

| Format | Total Bits | Sign | Exponent | Mantissa | Bias | Precision $p$ |
|---|---|---|---|---|---|---|
| Half (binary16) | 16 | 1 | 5 | 10 | 15 | 11 |
| Bfloat16 | 16 | 1 | 8 | 7 | 127 | 8 |
| Single (binary32) | 32 | 1 | 8 | 23 | 127 | 24 |
| Double (binary64) | 64 | 1 | 11 | 52 | 1023 | 53 |

> Note: Precision $p$ = mantissa bits + 1 (the implicit leading 1).

#### Special Values

| Type | Exponent $e$ | Fraction $f$ | Value |
|---|---|---|---|
| Zero | 0 | 0 | $(-1)^s \times 0$ |
| Subnormal | 0 | $\neq 0$ | $(-1)^s \times (0.f) \times 2^{1-\text{bias}}$ |
| Normalized | $1 \ldots e_{\max}{-}1$ | any | $(-1)^s \times (1.f) \times 2^{e-\text{bias}}$ |
| Infinity | All 1s | 0 | $(-1)^s \times \infty$ |
| NaN | All 1s | $\neq 0$ | Not a Number |

---

### 1.3 Conversion Examples

#### Example: $-13.625 \to$ Single Precision (binary32)

**Step 1 — Convert to binary:**
- Integer: $13 = 8+4+1 = 1101_2$
- Fraction: $0.625 = 0.5 + 0.125 = 0.101_2$
- Combined: $-1101.101_2$

**Step 2 — Normalize:**

$$-1.101101_2 \times 2^3$$

**Step 3 — Encode fields:**
- Sign $s = 1$
- Exponent: $e = 3 + 127 = 130 = 10000010_2$
- Mantissa: $10110100000000000000000$ (drop leading 1, pad zeros to 23 bits)

**Result:** `1 | 10000010 | 10110100000000000000000` = **0xC15A0000**

#### Example: $0.1_{10} \to$ binary

$0.1 \times 2 = 0.2 \to 0$, $0.2 \times 2 = 0.4 \to 0$, $0.4 \times 2 = 0.8 \to 0$, $0.8 \times 2 = 1.6 \to 1$, $0.6 \times 2 = 1.2 \to 1$, $0.2 \times 2 = \ldots$ (repeats)

$$0.1_{10} = 0.0\overline{0011}_2 \quad \text{(infinite repeating — cannot be exactly represented!)}$$

#### Example: Reading back a binary32 pattern

Given `0 10000001 01000000000000000000000`:
- $s = 0$ → positive
- $e = 10000001_2 = 129$, actual exponent $= 129 - 127 = 2$
- $f = 01_2$ → significand $= 1.01_2 = 1.25$
- Value: $+1.25 \times 2^2 = 5.0$

#### Example: Subnormal number in binary32

Recall the subnormal formula: $x = (-1)^s \times (0.f) \times 2^{1 - \text{bias}}$

When the stored exponent $e = 0$ and the fraction $f \neq 0$, the number is **subnormal** (also called denormalized). There is **no implicit leading 1** — the significand is $0.f$ instead of $1.f$, and the exponent is fixed at $1 - \text{bias}$.

**Given bit pattern:** `0 00000000 10100000000000000000000`

| Field | Bits | Value |
|---|---|---|
| Sign $s$ | `0` | positive |
| Exponent $e$ | `00000000` | $0$ → **subnormal** |
| Fraction $f$ | `10100000000000000000000` | $0.101_2 = 0.625$ |

Since $e = 0$, use the subnormal formula with fixed exponent $1 - 127 = -126$:

$$x = (-1)^0 \times 0.101_2 \times 2^{-126} = 0.625 \times 2^{-126} \approx 7.35 \times 10^{-39}$$

**Why subnormals exist:** Without them, the smallest positive number would be $1.0 \times 2^{-126} \approx 1.18 \times 10^{-38}$, and all smaller values would flush to zero. Subnormals **fill the gap** between zero and the smallest normalized number, at the cost of reduced precision (fewer significant bits, since leading zeros in the significand don't carry information).

**Encoding a subnormal — represent $2^{-149}$ in binary32:**

This is the smallest positive subnormal (only the last fraction bit is set):

$$2^{-149} = 0.\underbrace{00\ldots0}_{22}1_2 \times 2^{-126}$$

| Field | Value |
|---|---|
| Sign | `0` |
| Exponent | `00000000` (signals subnormal) |
| Fraction | `00000000000000000000001` (only bit 23 set) |

Stored: `0 00000000 00000000000000000000001` — this has only **1 significant bit** of precision.

> **Key insight:** Subnormals trade precision for range. As values get smaller, bits "fall off" the left side of the significand, so the number of significant bits decreases — from 23 stored bits down to just 1 for the smallest subnormal.

---

## 2. Representable Numbers and the Gap Between Them

### 2.1 Distribution of Floating-Point Numbers

Floating-point numbers are **not uniformly spaced**. They are denser near zero and sparser for large magnitudes.

Between two consecutive powers of 2, say $[2^e, 2^{e+1})$, there are exactly $2^{p-1}$ equally spaced numbers (where $p$ is the precision, i.e., total significand bits).

### 2.2 Unit in the Last Place (ULP)

The gap between a floating-point number $x$ with exponent $e$ and its neighbor is:

$$\text{ulp}(x) = 2^{e - \text{bias} - (p-1)} = \epsilon \cdot 2^{e - \text{bias}}$$

where $\epsilon = 2^{1-p}$ is the **machine epsilon**.

| Format | Machine epsilon $\epsilon = 2^{1-p}$ | Unit roundoff $u = \epsilon / 2$ |
|---|---|---|
| binary16 | $2^{-10} \approx 9.77 \times 10^{-4}$ | $2^{-11} \approx 4.88 \times 10^{-4}$ |
| binary32 | $2^{-23} \approx 1.19 \times 10^{-7}$ | $2^{-24} \approx 5.96 \times 10^{-8}$ |
| binary64 | $2^{-52} \approx 2.22 \times 10^{-16}$ | $2^{-53} \approx 1.11 \times 10^{-16}$ |

### 2.3 Extremal Values

| | binary32 | binary64 |
|---|---|---|
| Smallest normalized | $2^{-126} \approx 1.18 \times 10^{-38}$ | $2^{-1022} \approx 2.22 \times 10^{-308}$ |
| Largest normalized | $(2 - 2^{-23}) \times 2^{127} \approx 3.4 \times 10^{38}$ | $(2 - 2^{-52}) \times 2^{1023} \approx 1.8 \times 10^{308}$ |
| Smallest subnormal | $2^{-149} \approx 1.4 \times 10^{-45}$ | $2^{-1074} \approx 4.9 \times 10^{-324}$ |

### 2.4 Precision in Decimal Digits

$$\text{decimal digits} \approx -\log_{10}(u)$$

| Format | Approx. decimal digits |
|---|---|
| binary16 | ~3.3 |
| binary32 | ~7.2 |
| binary64 | ~15.9 |

---

## 3. Error Measurement and the Standard Error Model

### 3.1 Absolute and Relative Error

| | Scalar | Vector |
|---|---|---|
| **Absolute error** | $E_a(\hat{x}) = \lvert x - \hat{x}\rvert$ | $E_a(\hat{\mathbf{x}}) = \lVert\mathbf{x} - \hat{\mathbf{x}}\rVert$ |
| **Relative error** | $E_r(\hat{x}) = \dfrac{\lvert x - \hat{x}\rvert}{\lvert x\rvert}$ | Normwise: $\dfrac{\lVert\Delta\mathbf{x}\rVert}{\lVert\mathbf{x}\rVert}$, Componentwise: $\max_i \dfrac{\lvert\Delta x_i\rvert}{\lvert x_i\rvert}$ |

### 3.2 Standard Error Model (Fundamental Theorem)

For any real number $x$:

$$\text{fl}(x) = x(1 + \delta), \quad |\delta| \le u$$

For basic operations $\circ \in \{+, -, \times, /\}$ on floating-point inputs $a, b$:

$$\text{fl}(a \circ b) = (a \circ b)(1 + \delta), \quad |\delta| \le u$$

**Equivalent divisive form:**

$$\text{fl}(a \circ b) = \frac{a \circ b}{1 + \delta'}, \quad |\delta'| \le u$$

**With underflow:**

$$\text{fl}(a \circ b) = (a \circ b)(1 + \delta) + \eta, \quad |\delta| \le u, \; |\eta| \le \underline{u}, \; \delta \cdot \eta = 0$$

### 3.3 Error Accumulation ($\gamma_n$ Notation)

If $|\delta_i| \le u$, $\rho_i = \pm 1$ for $i = 1 \ldots n$, and $nu < 1$:

$$\prod_{i=1}^{n}(1+\delta_i)^{\rho_i} = 1 + \theta_n, \quad |\theta_n| \le \gamma_n := \frac{nu}{1 - nu}$$

### 3.4 The Three Pillars of Error Analysis

$$\boxed{\text{forward error} \lesssim \text{condition number} \times \text{backward error}}$$

| Pillar | Meaning | Depends on |
|---|---|---|
| **Condition number** $K$ | Sensitivity of problem to input perturbations | The problem |
| **Backward error** $\eta(\hat{x})$ | Smallest input perturbation making $\hat{x}$ exact | The algorithm |
| **Forward error** | Actual error $\lvert x - \hat{x}\rvert / \lvert x\rvert$ | Both |

**Backward stability:** An algorithm is backward-stable if $\eta(\hat{x}) = O(u)$.

**Ill-conditioned:** A problem is ill-conditioned if $K \cdot u \ge 1$.

---

## 4. Rounding Modes

### 4.1 The Four IEEE 754 Rounding Modes

| Mode | Symbol | Rule |
|---|---|---|
| Round toward $+\infty$ | $\Delta(x)$ | Smallest FP number $\ge x$ |
| Round toward $-\infty$ | $\nabla(x)$ | Largest FP number $\le x$ |
| Round toward $0$ | $\mathcal{Z}(x)$ | $\Delta(x)$ if $x < 0$; $\nabla(x)$ if $x > 0$ |
| Round to nearest (even) | $\circ(x)$ | Nearest FP number; ties → even last bit |

The first three are **directed rounding modes**. The unit roundoff is:
- $u = \epsilon/2 = 2^{-p}$ for **round-to-nearest**
- $u = \epsilon = 2^{1-p}$ for **directed rounding**

### 4.2 Correct Rounding Requirement

IEEE 754 requires that for $a, b \in \mathbb{F}$ and $\circ \in \{+, -, \times, /\}$:

$$\text{fl}(a \circ b) = \diamond(a \circ_{\text{exact}} b)$$

i.e., compute the exact result, then round with the chosen mode $\diamond$.

### 4.3 Understanding $p$ (Precision) in Toy Examples

In all the examples below we use small toy formats to keep things tractable. The parameter $p$ is the **precision** — the **total number of significand bits including the implicit leading 1**.

$$\text{significand} = \underbrace{1}_{\text{implicit}}.\underbrace{b_1 b_2 \ldots b_{p-1}}_{\text{stored fractional bits}}$$

So $p = 4$ means the significand looks like $1.b_1 b_2 b_3$ — **1 implicit bit + 3 stored bits = 4 total**. Any exact result with more than $p$ significand bits must be rounded.

| Toy $p$ | Significand shape | Stored frac. bits | Analogous to |
|---|---|---|---|
| $p = 4$ | $1.xxx$ | 3 | — |
| $p = 5$ | $1.xxxx$ | 4 | — |
| $p = 24$ | $1.\underbrace{x\ldots x}_{23}$ | 23 | binary32 (single) |
| $p = 53$ | $1.\underbrace{x\ldots x}_{52}$ | 52 | binary64 (double) |

> **How to use it:** When a result like $1.0001_2$ has 5 significant bits but $p = 4$, the 5th bit (and beyond) must be discarded via rounding. The unit roundoff is $u = 2^{-p}$ (round-to-nearest) and the machine epsilon is $\epsilon = 2^{1-p}$.

### 4.4 Rounding Examples

**Setup:** binary with 4-bit significand ($p = 4$), so representable numbers near 1 include: $1.000, 1.001, 1.010, 1.011, 1.100, \ldots$

| Exact result | $\circ(x)$ (nearest) | $\Delta(x)$ (up) | $\nabla(x)$ (down) | $\mathcal{Z}(x)$ (to 0) |
|---|---|---|---|---|
| $1.0011_2$ | $1.010$ | $1.010$ | $1.001$ | $1.001$ |
| $1.0101_2$ | $1.010$ (tie→even) | $1.011$ | $1.010$ | $1.010$ |
| $-1.0011_2$ | $-1.010$ | $-1.001$ | $-1.010$ | $-1.001$ |

### 4.4 Example: Applying Rounding to Addition

Let $a = 1.000_2 \times 2^0 = 1$ and $b = 1.001_2 \times 2^{-3} = 0.001001_2$ in a system with $p = 4$.

Exact: $a + b = 1.001001_2$, but only 4 significand bits fit → must round:

| Mode | Result | Value |
|---|---|---|
| $\circ$ (nearest) | $1.001_2$ | $1.125$ |
| $\Delta$ (up) | $1.010_2$ | $1.25$ |
| $\nabla$ (down) | $1.001_2$ | $1.125$ |

### 4.5 Adding and Subtracting Floating-Point Numbers by Hand

The procedure for addition/subtraction in floating-point has three steps:
1. **Align exponents** — shift the significand of the smaller number right until both exponents match
2. **Add/subtract significands** — perform the binary operation on the aligned significands
3. **Normalize & round** — normalize the result to the form $1.xxx \times 2^E$ and round to $p$ significand bits

---

#### Example 1: Addition — $5.75 + 0.5$ in a toy format ($p = 4$ significand bits)

**Convert to FP:**

| Number | Decimal | Binary | Normalized | Stored |
|---|---|---|---|---|
| $a$ | $5.75$ | $101.11_2$ | $1.0111 \times 2^2$ | $s{=}0,\; e{=}2,\; m{=}1.011$ (rounded to $p{=}4$: $1.100$) |
| $b$ | $0.5$ | $0.1_2$ | $1.000 \times 2^{-1}$ | $s{=}0,\; e{=}{-1},\; m{=}1.000$ |

> Wait — let's use $p = 5$ significand bits here so $a = 1.0111 \times 2^2$ fits exactly. This keeps the example clear.

**With $p = 5$:**
- $a = 1.0111_2 \times 2^{2}$
- $b = 1.0000_2 \times 2^{-1}$

**Step 1 — Align exponents** (match to the larger exponent $2$):

Shift $b$ right by $2 - (-1) = 3$ positions:

$$b = 0.0010\underbrace{00\ldots}_{\text{beyond }p\text{ bits}} \times 2^{2}$$

In our 5-bit significand window: $b_{\text{aligned}} = 0.0010_2 \times 2^2$

**Step 2 — Add significands:**

```
  1.0111    (a)
+ 0.0010    (b aligned)
─────────
  1.1001
```

**Step 3 — Normalize & round:**

Result $= 1.1001_2 \times 2^2$ — already normalized, 5 significand bits, no rounding needed.

$$\text{fl}(5.75 + 0.5) = 1.1001_2 \times 2^2 = 110.01_2 = 6.25_{10} \; \checkmark$$

---

#### Example 2: Addition with rounding — $1.0 + 0.0625$ in $p = 4$ significand bits

- $a = 1.000_2 \times 2^{0}$
- $b = 1.000_2 \times 2^{-4}$ (since $0.0625 = 2^{-4}$)

**Step 1 — Align exponents** (shift $b$ right by 4):

$$b_{\text{aligned}} = 0.0001_2 \times 2^{0}$$

**Step 2 — Add:**

```
  1.000     (a)
+ 0.0001    (b aligned)
─────────
  1.0001
```

**Step 3 — Normalize & round to $p = 4$:**

Exact result: $1.0001_2 \times 2^0$ — this has 5 significant bits but we only have 4.

| Mode | Rounded result | Decimal |
|---|---|---|
| $\circ$ (nearest) | $1.000 \times 2^0$ | $1.0$ ← **$b$ was absorbed!** |
| $\Delta$ (up) | $1.001 \times 2^0$ | $1.125$ |
| $\nabla$ (down) | $1.000 \times 2^0$ | $1.0$ |

With round-to-nearest, $b$ is completely lost — this is **absorption** in action.

---

#### Example 3: Subtraction — $1.0 - 0.875$ in $p = 4$ significand bits

- $a = 1.000_2 \times 2^{0}$
- $b = 1.110_2 \times 2^{-1}$ (since $0.875 = 0.111_2 = 1.110 \times 2^{-1}$)

**Step 1 — Align exponents** (shift $b$ right by 1):

$$b_{\text{aligned}} = 0.1110_2 \times 2^{0}$$

**Step 2 — Subtract:**

```
  1.0000    (a)
- 0.1110    (b aligned)
─────────
  0.0010
```

**Step 3 — Normalize:**

Shift left by 2 positions: $0.0010_2 \times 2^0 = 1.000_2 \times 2^{-3}$

Result: $1.000_2 \times 2^{-3} = 0.125_{10}$ ✓ (exact: $1.0 - 0.875 = 0.125$)

> Notice: the result required 2 left-shifts to normalize. This is **cancellation** — 2 leading significant bits were lost. The result has only 1 meaningful significant bit ($1.000$), and the trailing zeros are just padding, not real precision from the inputs.

---

#### Example 4: Subtraction showing catastrophic cancellation — $p = 4$

- $a = 1.001_2 \times 2^{3} = 1001.0_2 = 9.0$
- $b = 1.000_2 \times 2^{3} = 1000.0_2 = 8.0$

**Step 1 — Exponents already match.**

**Step 2 — Subtract:**

```
  1.001    (a)
- 1.000    (b)
────────
  0.001
```

**Step 3 — Normalize:**

$0.001_2 \times 2^3 = 1.000_2 \times 2^{0} = 1.0$

Result is exact here ($9 - 8 = 1$), but notice 3 leading bits cancelled. If $a$ and $b$ had been rounded from more precise values (carrying error in their trailing bits), those errors would now dominate the result — that's catastrophic cancellation.

---

#### Summary: The Hand-Computation Procedure

```
Input:  a = 1.m_a × 2^(E_a),  b = 1.m_b × 2^(E_b)

1. ALIGN:   If E_a > E_b, shift m_b right by (E_a - E_b) bits
            (bits shifted beyond p positions are lost / used for rounding)

2. OPERATE: Add or subtract the aligned significands

3. NORMALIZE:
   - If result ≥ 2.0:  shift right by 1, increment exponent
   - If result < 1.0:  shift left until leading 1, decrement exponent

4. ROUND:   Truncate to p significand bits using chosen rounding mode
```

---

## 5. Cancellation

### 5.1 What Is Cancellation?

**Cancellation** occurs when subtracting two nearly equal numbers. The leading significant digits cancel, leaving few reliable digits. After normalization, the trailing (unreliable) bits are promoted to significant positions.

### 5.2 Mathematical Condition

When computing $a - b$ where $a \approx b$:

$$\text{Number of digits lost} \approx \log_{10}\!\left(\frac{|a|}{|a - b|}\right)$$

or equivalently in base 2:

$$\text{Bits lost} \approx \log_{2}\!\left(\frac{|a|}{|a - b|}\right)$$

> **Key theorem:** The number of digits lost due to cancellation is **independent of the precision** used. Using binary64 instead of binary32 does not reduce the number of lost digits — you just start with more digits.

### 5.3 Remaining Precision After Cancellation

$$\text{remaining digits} \approx -\log_{10}(u) - \log_{10}\!\left(\frac{|a|}{|a - b|}\right)$$

| Format | Starting digits | After losing 5 digits |
|---|---|---|
| binary32 | 7.2 | ~2.2 |
| binary64 | 15.9 | ~10.9 |

### 5.4 Example

Compute $a - b$ where $a = 1.23456789$ and $b = 1.23456780$ in a system with 9 significant digits:

$$a - b = 0.00000009$$

Digits lost: $\log_{10}(1.23/0.00000009) \approx 7.1$ → only about **2 reliable digits** remain.

**In floating-point (binary64):**
- $a = 1.234\,567\,89 \times 10^0$, $b = 1.234\,567\,80 \times 10^0$
- $a - b = 9.0 \times 10^{-8}$ — after normalization, only the last 1-2 digits of the original numbers contributed, rest is "garbage"

### 5.5 Condition Number Near Roots

The condition number of polynomial evaluation $p(z)$ blows up near roots:

$$K(p, z) = \frac{|z \cdot p'(z)|}{|p(z)|} \to \infty \text{ as } p(z) \to 0$$

This is precisely because of cancellation in the sum $p(z) = \sum a_i z^i$ when the result is near zero.

---

## 6. Absorption

### 6.1 What Is Absorption?

**Absorption** occurs when adding two numbers of **very different magnitudes**. The smaller number's significant digits fall below the precision window and are lost.

### 6.2 Mathematical Condition for Absorption

When computing $\text{fl}(a + b)$ with $|a| \gg |b|$, full absorption occurs when:

$$\boxed{|b| \le u \cdot |a|}$$

where $u = 2^{-p}$ is the unit roundoff. In this case:

$$\text{fl}(a + b) = a$$

The smaller operand $b$ is completely absorbed. More generally, partial absorption occurs when $|b| < \epsilon \cdot |a|$ (machine epsilon), meaning $b$ contributes only a few bits to the result.

### 6.3 Why This Happens

When aligning exponents for addition, the significand of $b$ is shifted right. If the shift exceeds $p$ bits (the significand width), all bits of $b$ fall off and are lost:

- $a = 1.000\ldots0 \times 2^E$
- $b = 1.xxx\ldots x \times 2^{E-k}$
- Aligned: $b = 0.000\ldots01.xxx \times 2^E$
- If $k \ge p$: all bits of $b$ shifted beyond significand width → lost

### 6.4 Example

In binary32 ($p = 24$, $u = 2^{-24}$):

$$a = 2^{24} = 16\,777\,216, \quad b = 1$$

$$a + b = 16\,777\,217 \quad \text{(exact)}$$

But $\text{fl}(a + b) = 16\,777\,216 = a$ because $b = 1 = u \cdot a$, and 1 falls into the bit just below the significand.

**Another example:** Summing $10^{10} + 1.0$ in binary64:
- $u \cdot 10^{10} = 2^{-53} \cdot 10^{10} \approx 1.1 \times 10^{-6}$
- Since $1.0 \gg u \cdot 10^{10}$, partial absorption: some bits of 1.0 survive, but precision is reduced

### 6.5 Absorption in Summation

When summing many numbers, if the running sum grows large relative to remaining terms, later small terms can be fully absorbed. This is why naive left-to-right summation can lose accuracy and why **compensated summation** (Kahan, CompSum) is needed.

---

## 7. Stochastic Arithmetic (CESTAC / DSA / CADNA)

### 7.1 Round-Off Error Model

For the result $R$ of $n$ elementary operations on the exact result $r$:

$$R \approx r + \sum_{i=1}^{n} g_i(d) \cdot 2^{-p} \cdot \alpha_i$$

where $g_i(d)$ depend on the data/algorithm, $\alpha_i$ are individual round-off errors, and $p$ is the significand length.

### 7.2 Number of Significant Digits

The relative error on $R$ is related to the number of significant bits $C_R$:

$$\left|\frac{R - r}{r}\right| = 2^{-C_R}$$

$$\boxed{C_R = p - \log_2\left|\sum_{i=1}^{n} g_i(d) \frac{\alpha_i}{r}\right|}$$

The second term is the **accuracy lost**, and it is **independent of $p$** (independent of precision).

### 7.3 CESTAC Method

**Idea:** Run the same computation $N$ times with **random rounding** (randomly choose $\nabla$ or $\Delta$ at each operation). Then estimate accuracy statistically.

Given $N$ samples $R_1, \ldots, R_N$:

$$\bar{R} = \frac{1}{N}\sum_{i=1}^{N} R_i, \qquad \sigma^2 = \frac{1}{N-1}\sum_{i=1}^{N}(R_i - \bar{R})^2$$

**Number of correct decimal digits:**

$$\boxed{C_{\bar{R}} \approx \log_{10}\!\left(\frac{\sqrt{N}\,|\bar{R}|}{\sigma \cdot \tau_\beta}\right)}$$

where $\tau_\beta$ is the Student's $t$-distribution value for confidence level $\beta$. Typically $N = 3$ and $\beta = 0.95$.

### 7.4 Computational Zero and Stochastic Relations

**Computational zero** ($@.0$): A result $R$ is $@.0$ if all samples $R_i = 0$ or $C_{\bar{R}} \le 0$. It means $R$ cannot be distinguished from 0 due to round-off.

**Stochastic relations** (let $X, Y$ be CESTAC results):

| Relation | Definition |
|---|---|
| $X \stackrel{s}{=} Y$ (stoch. equality) | $X - Y = @.0$ |
| $X \stackrel{s}{>} Y$ (stoch. strict order) | $\bar{X} > \bar{Y}$ and $X \stackrel{s}{\ne} Y$ |
| $X \stackrel{s}{\ge} Y$ (stoch. order) | $\bar{X} \ge \bar{Y}$ or $X \stackrel{s}{=} Y$ |

**Properties of DSA (Discrete Stochastic Arithmetic):**
- $x = 0 \Rightarrow X = @.0$
- $X \stackrel{s}{\ne} Y \Rightarrow x \ne y$
- $X \stackrel{s}{>} Y \Rightarrow x > y$
- $\stackrel{s}{>}$ is transitive
- $\stackrel{s}{=}$ is reflexive and symmetric, but **NOT transitive**
- $\stackrel{s}{\ge}$ is reflexive and antisymmetric, but **NOT transitive**

### 7.5 Instabilities Detected by CADNA

CADNA detects the following **numerical instabilities**:

| Instability | Condition |
|---|---|
| **Unstable multiplication** | Both operands are numerically insignificant |
| **Unstable division** | Divisor is numerically insignificant |
| **Unstable power** | One operand is numerically insignificant |
| **Unstable branching** | Difference between compared values is insignificant |
| **Unstable math function** | Argument of `log`, `sqrt`, `exp` is insignificant |
| **Unstable intrinsic function** | `floor`/`ceil` with inconsistent components, `abs` with sign disagreement |
| **Unstable cancellation** | $\min(\text{accuracy}(a), \text{accuracy}(b)) - \text{accuracy}(a \pm b) > \text{CANCEL\_LEVEL}$ |

### 7.6 Connection to Cancellation and Absorption

- **Cancellation** causes instability because the subtraction of nearly equal values yields a result with far fewer significant digits → CADNA detects this as **unstable cancellation**
- **Absorption** causes instability because adding a small value to a large one effectively loses the small value → this manifests as **loss of information** in the accumulated sum, which CADNA can detect through reduced significant digits
- **Unstable branching** is often a consequence of cancellation or absorption: when a comparison like `if (a > b)` depends on digits that have already been lost to rounding, the branch decision is unreliable

---

## 8. Quick Reference Summary

### Key Formulas

| Concept | Formula |
|---|---|
| FP representation | $x = (-1)^s (1.f) \times 2^{e - \text{bias}}$ |
| Standard error model | $\text{fl}(a \circ b) = (a \circ b)(1 + \delta), \; |\delta| \le u$ |
| Error accumulation | $\gamma_n = \frac{nu}{1 - nu}$ |
| Cancellation digits lost | $\log_{10}(\lvert a\rvert / \lvert a - b\rvert)$ |
| Absorption condition | $\lvert b\rvert \le u \cdot \lvert a\rvert \Rightarrow \text{fl}(a+b) = a$ |
| Correct digits | $\approx -\log_{10}(u) - \log_{10}(\kappa)$ |
| CESTAC digits | $C_{\bar{R}} \approx \log_{10}\!\left(\frac{\sqrt{N}\lvert\bar{R}\rvert}{\sigma \tau_\beta}\right)$ |
| Accuracy lost (bits) | $C_R = p - \log_2\left\lvert\sum g_i(d)\frac{\alpha_i}{r}\right\rvert$ (independent of $p$!) |

### Unit Roundoff Values

| Format | $u$ | Approx. decimal digits |
|---|---|---|
| binary16 (half) | $2^{-11} \approx 4.88 \times 10^{-4}$ | ~3.3 |
| binary32 (single) | $2^{-24} \approx 5.96 \times 10^{-8}$ | ~7.2 |
| binary64 (double) | $2^{-53} \approx 1.11 \times 10^{-16}$ | ~15.9 |
