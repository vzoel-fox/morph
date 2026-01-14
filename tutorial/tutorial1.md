# Tutorial 1: Getting Started with Morph

Welcome to your first Morph tutorial! Let's learn the basics.

## 🎯 What You'll Learn

- Variables and basic types
- Arithmetic operations  
- Simple functions
- Control flow (if/else, loops)
- Using standard library

## 📝 Your First Program

Create a file called `hello.fox`:

```morph
ambil "corelib/api.fox"

utama {
    println("Hello, Morph!")
    kembali 0
}
```

Run it:
```bash
./bin/morph hello.fox
```

## 🔢 Variables and Types

Morph has several basic types:

```morph
ambil "corelib/api.fox"

utama {
    ; Integer variables
    var age = 25
    var year = 2026
    
    ; Print variables
    print("Age: ")
    print_int(age)
    println("")
    
    kembali 0
}
```

## ➕ Arithmetic Operations

All basic math operations are supported:

```morph
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

```morph
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

```morph
ambil "corelib/api.fox"

utama {
    var number = 42
    
    jika number > 40
        println("Number is greater than 40")
    lain jika number == 40
        println("Number is exactly 40")
    lain
        println("Number is less than 40")
    tutup_jika
    
    kembali 0
}
```

### Loops

```morph
ambil "corelib/api.fox"

utama {
    ; While loop
    var i = 1
    selama i <= 5
        print_int(i)
        print(" ")
        i = i + 1
    tutup_selama
    
    println("")
    kembali 0
}
```

## 📚 Using Standard Library

MorphFox provides a clean API through `corelib/api.fox`:

```morph
ambil "corelib/api.fox"

utama {
    ; Memory allocation
    var buffer = alloc(1024)
    
    ; File I/O
    var content = read_file("data.txt")
    
    ; Print
    println("Hello World")
    print_int(42)
    
    ; Cleanup
    free(buffer)
    
    kembali 0
}
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
- **`ambil`**: Import library

## ✅ Complete Example

```morph
ambil "corelib/api.fox"

fungsi factorial(n: i64) -> i64
    jika n <= 1
        kembali 1
    tutup_jika
    kembali n * factorial(n - 1)
tutup_fungsi

utama {
    println("🦊 MorphFox Calculator")
    
    var num = 5
    var fact = factorial(num)
    
    print("Factorial of ")
    print_int(num)
    print(" is ")
    print_int(fact)
    println("")
    
    kembali 0
}
```

## 🚀 Next Steps

Ready for more? Continue to [Tutorial 2: Memory & Data Structures](tutorial2.md)
