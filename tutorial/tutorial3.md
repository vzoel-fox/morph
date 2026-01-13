# Tutorial 3: Type System

Explore MorphFox's advanced type system with structs, generics, and unions!

## 🎯 What You'll Learn

- Advanced types (structs, arrays, unions)
- Generics and type aliases
- Type checking and validation
- Error handling patterns

## 🏗️ Type System Overview

MorphFox has a powerful static type system:

```morphfox
; Basic types
var number: i64 = 42        ; 64-bit integer
var pointer: ptr = 0        ; Generic pointer
var text: String = "hello"  ; String type
```

## 📦 Structs and Records

### Defining Structs

```morphfox
; Conceptual struct definition
; struktur Person {
;     name: String,
;     age: i64,
;     active: i64
; }

; Manual struct implementation
const PERSON_NAME = 0
const PERSON_AGE = 8
const PERSON_ACTIVE = 16
const PERSON_SIZE = 24

fungsi create_person(name_hash: i64, age: i64, active: i64) -> ptr
    var person = __mf_mem_alloc(PERSON_SIZE)
    __mf_poke_i64(person + PERSON_NAME, name_hash)
    __mf_poke_i64(person + PERSON_AGE, age)
    __mf_poke_i64(person + PERSON_ACTIVE, active)
    kembali person
tutup_fungsi

fungsi person_get_age(person: ptr) -> i64
    kembali __mf_load_i64(person + PERSON_AGE)
tutup_fungsi

fungsi person_set_age(person: ptr, age: i64) -> void
    __mf_poke_i64(person + PERSON_AGE, age)
tutup_fungsi
```

### Using Structs

```morphfox
utama {
    sistem 1, 1, "👤 Person Management System\n", 29
    
    ; Create person
    var john = create_person(12345, 30, 1)
    
    ; Access fields
    var age = person_get_age(john)
    sistem 1, 1, "John's age: ", 12
    print_number(age)
    sistem 1, 1, "\n", 1
    
    ; Modify fields
    person_set_age(john, 31)
    var new_age = person_get_age(john)
    sistem 1, 1, "Updated age: ", 13
    print_number(new_age)
    sistem 1, 1, "\n", 1
    
    __mf_mem_free(john)
    kembali 0
}
```

## 📋 Arrays and Collections

### Fixed Arrays

```morphfox
; Array of integers: [i64; 5]
fungsi create_int_array(size: i64) -> ptr
    kembali __mf_mem_alloc(size * 8)  ; 8 bytes per i64
tutup_fungsi

fungsi array_set(arr: ptr, index: i64, value: i64) -> void
    __mf_poke_i64(arr + (index * 8), value)
tutup_fungsi

fungsi array_get(arr: ptr, index: i64) -> i64
    kembali __mf_load_i64(arr + (index * 8))
tutup_fungsi

utama {
    sistem 1, 1, "📋 Array Operations\n", 20
    
    ; Create array of 5 integers
    var numbers = create_int_array(5)
    
    ; Fill array
    var i = 0
    selama i < 5
        array_set(numbers, i, i * i)  ; Store squares
        i = i + 1
    tutup_selama
    
    ; Print array
    sistem 1, 1, "Squares: ", 9
    var j = 0
    selama j < 5
        var value = array_get(numbers, j)
        print_number(value)
        sistem 1, 1, " ", 1
        j = j + 1
    tutup_selama
    sistem 1, 1, "\n", 1
    
    __mf_mem_free(numbers)
    kembali 0
}
```

## 🔗 Type Aliases

Type aliases make code more readable:

```morphfox
; Conceptual type aliases:
; type UserId = i64
; type ErrorCode = i64
; type Handle = ptr

; Implementation with constants
const TYPE_USER_ID = 1
const TYPE_ERROR_CODE = 2
const TYPE_HANDLE = 3

fungsi create_user_id(id: i64) -> i64
    ; In real implementation, this would have type checking
    kembali id
tutup_fungsi

fungsi validate_user_id(user_id: i64) -> i64
    ; Simple validation
    jika user_id > 0 dan user_id < 1000000
        kembali 1  ; Valid
    tutup_jika
    kembali 0  ; Invalid
tutup_fungsi

utama {
    sistem 1, 1, "🏷️  Type Aliases Demo\n", 22
    
    var user_id = create_user_id(12345)
    var is_valid = validate_user_id(user_id)
    
    sistem 1, 1, "User ID: ", 9
    print_number(user_id)
    sistem 1, 1, " - Valid: ", 10
    print_number(is_valid)
    sistem 1, 1, "\n", 1
    
    kembali 0
}
```

## 🔀 Union Types

Union types represent values that can be one of several types:

```morphfox
; Union: Result<T> = Ok(T) | Error(String)
const RESULT_OK = 1
const RESULT_ERROR = 2

const RESULT_TYPE = 0
const RESULT_VALUE = 8
const RESULT_SIZE = 16

fungsi create_ok_result(value: i64) -> ptr
    var result = __mf_mem_alloc(RESULT_SIZE)
    __mf_poke_i64(result + RESULT_TYPE, RESULT_OK)
    __mf_poke_i64(result + RESULT_VALUE, value)
    kembali result
tutup_fungsi

fungsi create_error_result(error_code: i64) -> ptr
    var result = __mf_mem_alloc(RESULT_SIZE)
    __mf_poke_i64(result + RESULT_TYPE, RESULT_ERROR)
    __mf_poke_i64(result + RESULT_VALUE, error_code)
    kembali result
tutup_fungsi

fungsi handle_result(result: ptr) -> void
    var result_type = __mf_load_i64(result + RESULT_TYPE)
    var value = __mf_load_i64(result + RESULT_VALUE)
    
    jika result_type == RESULT_OK
        sistem 1, 1, "Success: ", 9
        print_number(value)
        sistem 1, 1, "\n", 1
    lain jika result_type == RESULT_ERROR
        sistem 1, 1, "Error code: ", 12
        print_number(value)
        sistem 1, 1, "\n", 1
    tutup_jika
tutup_fungsi

utama {
    sistem 1, 1, "🔀 Union Types Demo\n", 20
    
    ; Success case
    var ok_result = create_ok_result(42)
    handle_result(ok_result)
    
    ; Error case
    var error_result = create_error_result(404)
    handle_result(error_result)
    
    __mf_mem_free(ok_result)
    __mf_mem_free(error_result)
    
    kembali 0
}
```

## 🧬 Generics (Conceptual)

Generics allow code reuse with different types:

```morphfox
; Conceptual generic function:
; fungsi map<T, U>(arr: []T, func: T -> U) -> []U

; Manual implementation for i64 -> i64
fungsi map_i64_to_i64(arr: ptr, size: i64, transform_func: ptr) -> ptr
    var result = create_int_array(size)
    
    var i = 0
    selama i < size
        var input = array_get(arr, i)
        ; In real implementation, would call transform_func(input)
        var output = input * 2  ; Simple transformation
        array_set(result, i, output)
        i = i + 1
    tutup_selama
    
    kembali result
tutup_fungsi

utama {
    sistem 1, 1, "🧬 Generic-style Operations\n", 28
    
    ; Create input array
    var input = create_int_array(3)
    array_set(input, 0, 1)
    array_set(input, 1, 2)
    array_set(input, 2, 3)
    
    ; Transform array (double each element)
    var output = map_i64_to_i64(input, 3, 0)
    
    ; Print results
    sistem 1, 1, "Input:  ", 8
    var i = 0
    selama i < 3
        print_number(array_get(input, i))
        sistem 1, 1, " ", 1
        i = i + 1
    tutup_selama
    sistem 1, 1, "\n", 1
    
    sistem 1, 1, "Output: ", 8
    var j = 0
    selama j < 3
        print_number(array_get(output, j))
        sistem 1, 1, " ", 1
        j = j + 1
    tutup_selama
    sistem 1, 1, "\n", 1
    
    __mf_mem_free(input)
    __mf_mem_free(output)
    
    kembali 0
}
```

## ✅ Type Validation

```morphfox
; Type checking functions
fungsi validate_person(person: ptr) -> i64
    jika person == 0
        kembali 0  ; Null pointer
    tutup_jika
    
    var age = person_get_age(person)
    jika age < 0 atau age > 150
        kembali 0  ; Invalid age
    tutup_jika
    
    kembali 1  ; Valid
tutup_fungsi

fungsi safe_person_operation(person: ptr) -> i64
    jika validate_person(person) == 0
        sistem 1, 1, "❌ Invalid person data\n", 24
        kembali -1
    tutup_jika
    
    sistem 1, 1, "✅ Person data valid\n", 22
    kembali 0
tutup_fungsi

utama {
    sistem 1, 1, "✅ Type Validation Demo\n", 25
    
    ; Valid person
    var valid_person = create_person(12345, 25, 1)
    safe_person_operation(valid_person)
    
    ; Invalid person (bad age)
    var invalid_person = create_person(67890, -5, 1)
    safe_person_operation(invalid_person)
    
    __mf_mem_free(valid_person)
    __mf_mem_free(invalid_person)
    
    kembali 0
}
```

## 🎮 Practice Exercises

1. **Library System**: Create Book, Author, and Library structs
2. **Generic Container**: Implement a generic-style vector/list
3. **Error Handling**: Build a comprehensive error handling system
4. **Type-Safe API**: Create a type-safe interface for file operations

## 📖 Key Concepts

- **Structs**: Composite data types with named fields
- **Arrays**: Fixed-size collections of same-type elements
- **Type Aliases**: Alternative names for existing types
- **Union Types**: Values that can be one of several types
- **Generics**: Code reuse across different types
- **Type Validation**: Runtime type checking for safety

## ✅ Complete Example: Type-Safe Calculator

```morphfox
; Calculator result type
const CALC_SUCCESS = 1
const CALC_DIVIDE_BY_ZERO = 2
const CALC_OVERFLOW = 3

const CALC_RESULT_TYPE = 0
const CALC_RESULT_VALUE = 8
const CALC_RESULT_SIZE = 16

fungsi calc_add(a: i64, b: i64) -> ptr
    var result = __mf_mem_alloc(CALC_RESULT_SIZE)
    __mf_poke_i64(result + CALC_RESULT_TYPE, CALC_SUCCESS)
    __mf_poke_i64(result + CALC_RESULT_VALUE, a + b)
    kembali result
tutup_fungsi

fungsi calc_divide(a: i64, b: i64) -> ptr
    var result = __mf_mem_alloc(CALC_RESULT_SIZE)
    
    jika b == 0
        __mf_poke_i64(result + CALC_RESULT_TYPE, CALC_DIVIDE_BY_ZERO)
        __mf_poke_i64(result + CALC_RESULT_VALUE, 0)
    lain
        __mf_poke_i64(result + CALC_RESULT_TYPE, CALC_SUCCESS)
        __mf_poke_i64(result + CALC_RESULT_VALUE, a / b)
    tutup_jika
    
    kembali result
tutup_fungsi

fungsi print_calc_result(result: ptr) -> void
    var type = __mf_load_i64(result + CALC_RESULT_TYPE)
    var value = __mf_load_i64(result + CALC_RESULT_VALUE)
    
    jika type == CALC_SUCCESS
        sistem 1, 1, "Result: ", 8
        print_number(value)
        sistem 1, 1, "\n", 1
    lain jika type == CALC_DIVIDE_BY_ZERO
        sistem 1, 1, "Error: Division by zero\n", 24
    lain
        sistem 1, 1, "Error: Unknown\n", 15
    tutup_jika
tutup_fungsi

utama {
    sistem 1, 1, "🧮 Type-Safe Calculator\n", 25
    
    ; Valid operations
    var add_result = calc_add(10, 5)
    print_calc_result(add_result)
    
    var div_result = calc_divide(20, 4)
    print_calc_result(div_result)
    
    ; Error case
    var error_result = calc_divide(10, 0)
    print_calc_result(error_result)
    
    __mf_mem_free(add_result)
    __mf_mem_free(div_result)
    __mf_mem_free(error_result)
    
    kembali 0
}
```

## 🚀 Next Steps

Continue to [Tutorial 4: Concurrency](tutorial4.md)

- MorphRoutines in depth
- Concurrent programming patterns
- Real-time systems
- Performance at scale
