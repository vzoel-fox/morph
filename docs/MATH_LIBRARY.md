# Advanced Mathematics Library v2.1

## Overview

Standard Library v2.1 menambahkan komponen matematika kompleks untuk mendukung komputasi advanced, optimisasi compiler, dan operasi kriptografi. Library ini mencakup matematika dasar, operasi bitwise, dan simulasi floating point.

## Components

### 1. Advanced Mathematics (`math.fox`)

#### Basic Operations with Overflow Protection
```morph
fungsi add_safe(a: i64, b: i64) -> i64     ; Safe addition
fungsi mul_safe(a: i64, b: i64) -> i64     ; Safe multiplication
fungsi abs(x: i64) -> i64                  ; Absolute value
fungsi max(a: i64, b: i64) -> i64          ; Maximum
fungsi min(a: i64, b: i64) -> i64          ; Minimum
```

#### Advanced Functions
```morph
fungsi pow(base: i64, exp: i64) -> i64     ; Power (fast exponentiation)
fungsi sqrt(x: i64) -> i64                 ; Integer square root
fungsi gcd(a: i64, b: i64) -> i64          ; Greatest Common Divisor
fungsi lcm(a: i64, b: i64) -> i64          ; Least Common Multiple
fungsi factorial(n: i64) -> i64            ; Factorial
fungsi fibonacci(n: i64) -> i64            ; Fibonacci sequence
fungsi is_prime(n: i64) -> i64             ; Primality test
fungsi mod_pow(base: i64, exp: i64, mod: i64) -> i64  ; Modular exponentiation
```

#### Utility Functions
```morph
fungsi lerp(a: i64, b: i64, t: i64) -> i64        ; Linear interpolation
fungsi clamp(value: i64, min: i64, max: i64) -> i64  ; Clamp to range
```

### 2. Bitwise Operations (`bitwise.fox`)

#### Basic Bitwise
```morph
fungsi bit_and(a: i64, b: i64) -> i64      ; Bitwise AND
fungsi bit_or(a: i64, b: i64) -> i64       ; Bitwise OR
fungsi bit_xor(a: i64, b: i64) -> i64      ; Bitwise XOR
fungsi bit_not(a: i64) -> i64              ; Bitwise NOT
fungsi bit_shl(a: i64, shift: i64) -> i64  ; Left shift
fungsi bit_shr(a: i64, shift: i64) -> i64  ; Right shift
```

#### Bit Manipulation
```morph
fungsi popcount(x: i64) -> i64              ; Count set bits
fungsi clz(x: i64) -> i64                   ; Count leading zeros
fungsi ctz(x: i64) -> i64                   ; Count trailing zeros
fungsi bit_reverse(x: i64) -> i64           ; Reverse all bits
fungsi is_power_of_2(x: i64) -> i64         ; Check if power of 2
fungsi next_power_of_2(x: i64) -> i64       ; Next power of 2
```

#### Hash Functions & Crypto
```morph
fungsi hash_djb2(data: ptr, len: i64) -> i64       ; DJB2 hash
fungsi hash_fnv1a(data: ptr, len: i64) -> i64      ; FNV-1a hash
fungsi checksum_simple(data: ptr, len: i64) -> i64  ; Simple checksum
fungsi crc32_simple(data: ptr, len: i64) -> i64     ; CRC32 checksum
```

#### Random Number Generation
```morph
fungsi random_seed(seed: i64) -> void               ; Seed RNG
fungsi random() -> i64                              ; Generate random number
fungsi random_range(min: i64, max: i64) -> i64     ; Random in range
```

### 3. Fixed Point Arithmetic (`fixed_point.fox`)

Simulasi floating point menggunakan format Q16.16 (16 bit integer, 16 bit fractional).

#### Conversion
```morph
fungsi fixed_from_int(x: i64) -> i64               ; Int to fixed
fungsi fixed_to_int(x: i64) -> i64                 ; Fixed to int
fungsi fixed_make(integer: i64, frac_1000: i64) -> i64  ; Create from parts
fungsi fixed_to_string(x: i64) -> ptr              ; Convert to string
```

#### Arithmetic
```morph
fungsi fixed_add(a: i64, b: i64) -> i64            ; Addition
fungsi fixed_sub(a: i64, b: i64) -> i64            ; Subtraction
fungsi fixed_mul(a: i64, b: i64) -> i64            ; Multiplication
fungsi fixed_div(a: i64, b: i64) -> i64            ; Division
fungsi fixed_sqrt(x: i64) -> i64                   ; Square root
```

#### Trigonometry & Utilities
```morph
fungsi fixed_sin(x: i64) -> i64                    ; Sine (Taylor series)
fungsi fixed_cos(x: i64) -> i64                    ; Cosine
fungsi fixed_abs(x: i64) -> i64                    ; Absolute value
fungsi fixed_floor(x: i64) -> i64                  ; Floor
fungsi fixed_ceil(x: i64) -> i64                   ; Ceiling
```

## Usage Examples

### Basic Math
```morph
var result = pow(2, 10)          ; 1024
var root = sqrt(144)             ; 12
var is_17_prime = is_prime(17)   ; 1 (true)
var fib_10 = fibonacci(10)       ; 55
```

### Bitwise Operations
```morph
var masked = bit_and(0xFF, 0x0F)     ; 0x0F
var shifted = bit_shl(1, 8)          ; 256
var bits = popcount(0b1101)          ; 3
var next_pow2 = next_power_of_2(10)  ; 16
```

### Fixed Point Math
```morph
var fp_3_5 = fixed_make(3, 500)     ; 3.5 in fixed point
var fp_2_0 = fixed_from_int(2)      ; 2.0 in fixed point
var fp_sum = fixed_add(fp_3_5, fp_2_0)  ; 5.5
var result = fixed_to_int(fp_sum)    ; 5 (truncated)
```

### Hash Functions
```morph
var data = "Hello World"
var hash1 = hash_djb2(data, 11)
var hash2 = hash_fnv1a(data, 11)
var crc = crc32_simple(data, 11)
```

### Random Numbers
```morph
random_seed(12345)
var rand1 = random()                 ; Random number
var dice = random_range(1, 7)        ; 1-6 (dice roll)
```

## Performance Characteristics

- **Basic math**: O(1) for most operations, O(log n) for pow/sqrt
- **Bitwise**: O(1) for all operations
- **Fixed point**: O(1) arithmetic, O(n) for trigonometry
- **Hash functions**: O(n) where n is data length
- **Random**: O(1) generation

## Compiler Integration

Library ini dirancang untuk mendukung:

- **Compiler optimizations**: Constant folding, strength reduction
- **Code generation**: Efficient arithmetic operations
- **Symbol table hashing**: Fast identifier lookup
- **Floating point simulation**: For languages that need FP support

## Memory Safety

- Semua operasi menggunakan overflow protection
- Hash functions handle null pointers gracefully
- Fixed point operations prevent division by zero
- Random number generator uses safe seed management

## Testing

Comprehensive test suite di `tests/test_math_suite.fox`:

```bash
cd morph
./bin/morph tests/test_math_suite.fox
```

Tests cover:
- ✅ Basic math operations
- ✅ Bitwise manipulations
- ✅ Fixed point arithmetic
- ✅ Hash function correctness
- ✅ Random number generation

## Version History

- **v2.0.0**: String, vector, hashmap
- **v2.1.0**: Advanced math, bitwise, fixed point

---

**Status**: ✅ PRODUCTION READY - Advanced mathematical foundation complete
