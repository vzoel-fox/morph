# Tutorial 1: Getting Started with MorphFox

Welcome to your first MorphFox tutorial! Let's learn the basics.

## 🎯 What You'll Learn

- Variables and basic types
- Arithmetic operations  
- Simple functions
- Control flow (if/else, loops)

## 📝 Your First Program

Create a file called `hello.fox`:

```morphfox
utama {
    sistem 1, 1, "Hello, MorphFox!\n", 17
    kembali 0
}
```

Run it:
```bash
./bin/morph hello.fox
```

## 🔢 Variables and Types

MorphFox has several basic types:

```morphfox
utama {
    ; Integer variables
    var age = 25
    var year = 2026
    
    ; Print variables
    sistem 1, 1, "Age: ", 5
    print_number(age)
    sistem 1, 1, "\n", 1
    
    kembali 0
}
```

## ➕ Arithmetic Operations

All basic math operations are supported:

```morphfox
utama {
    var a = 10
    var b = 5
    
    var sum = a + b        ; Addition: 15
    var diff = a - b       ; Subtraction: 5  
    var product = a * b    ; Multiplication: 50
    var quotient = a / b   ; Division: 2
    var remainder = a % b  ; Modulo: 0
    
    kembali 0
}
```

## 🔧 Functions

Define reusable code with functions:

```morphfox
; Function definition
fungsi add_numbers(x: i64, y: i64) -> i64
    kembali x + y
tutup_fungsi

fungsi square(n: i64) -> i64
    kembali n * n
tutup_fungsi

utama {
    var result = add_numbers(15, 25)  ; Returns 40
    var squared = square(7)           ; Returns 49
    
    kembali 0
}
```

## 🔀 Control Flow

### If/Else Statements

```morphfox
utama {
    var number = 42
    
    jika number > 40
        sistem 1, 1, "Number is greater than 40\n", 27
    lain jika number == 40
        sistem 1, 1, "Number is exactly 40\n", 22
    lain
        sistem 1, 1, "Number is less than 40\n", 24
    tutup_jika
    
    kembali 0
}
```

### Loops

```morphfox
utama {
    ; While loop
    var i = 1
    selama i <= 5
        print_number(i)
        sistem 1, 1, " ", 1
        i = i + 1
    tutup_selama
    
    sistem 1, 1, "\n", 1
    kembali 0
}
```

## 🛠️ Helper Functions

You'll need this helper function for printing numbers:

```morphfox
fungsi print_number(n: i64)
    jika n == 0
        sistem 1, 1, "0", 1
        kembali
    tutup_jika
    
    jika n < 0
        sistem 1, 1, "-", 1
        n = 0 - n
    tutup_jika
    
    var digits = 0
    var temp = n
    selama temp > 0
        digits = digits + 1
        temp = temp / 10
    tutup_selama
    
    var buffer = __mf_mem_alloc(digits + 1)
    var i = digits - 1
    selama n > 0
        var digit = n % 10
        __mf_poke_i8(buffer + i, 48 + digit)
        n = n / 10
        i = i - 1
    tutup_selama
    
    sistem 1, 1, buffer, digits
tutup_fungsi
```

## 🎮 Practice Exercises

1. **Calculator**: Create functions for add, subtract, multiply, divide
2. **Factorial**: Write a function to calculate factorial of a number
3. **FizzBuzz**: Print numbers 1-100, but "Fizz" for multiples of 3, "Buzz" for 5
4. **Prime Check**: Function to check if a number is prime

## 📖 Key Concepts

- **`utama`**: Main function (entry point)
- **`var`**: Declare variables
- **`fungsi`**: Define functions
- **`jika/lain`**: If/else statements
- **`selama`**: While loops
- **`kembali`**: Return from function
- **`tutup_jika/tutup_selama/tutup_fungsi`**: Close blocks

## ✅ Complete Example

```morphfox
fungsi factorial(n: i64) -> i64
    jika n <= 1
        kembali 1
    tutup_jika
    kembali n * factorial(n - 1)
tutup_fungsi

utama {
    sistem 1, 1, "🦊 MorphFox Calculator\n", 23
    
    var num = 5
    var fact = factorial(num)
    
    sistem 1, 1, "Factorial of ", 13
    print_number(num)
    sistem 1, 1, " is ", 4
    print_number(fact)
    sistem 1, 1, "\n", 1
    
    kembali 0
}
```

## 🚀 Next Steps

Ready for more? Continue to [Tutorial 2: Advanced Features](tutorial2.md)

- Memory management
- Data structures
- MorphRoutines
- Performance optimization
