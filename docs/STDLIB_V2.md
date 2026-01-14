# Standard Library v2.0 - Self-Hosting Ready

## Overview

Standard Library v2.0 menyediakan komponen-komponen essential untuk implementasi self-hosting compiler Morph. Library ini mencakup string operations, dynamic arrays (Vector), dan hash tables (HashMap).

## Components

### 1. String Operations (`string.fox`)

```morph
; Basic string operations
fungsi string_length(s: ptr) -> i64
fungsi string_equals(a: ptr, b: ptr) -> i64
fungsi string_copy(dst: ptr, src: ptr) -> i64
fungsi string_concat(a: ptr, b: ptr) -> ptr
fungsi string_substring(s: ptr, start: i64, end: i64) -> ptr
fungsi string_find_char(s: ptr, c: i64) -> i64

; Conversion functions
fungsi i64_to_string(n: i64) -> ptr
fungsi string_to_i64(s: ptr) -> i64
```

**Usage Example:**
```morph
var hello = "Hello"
var world = "World"
var greeting = string_concat(hello, world)
var len = string_length(greeting)  ; Returns 10
```

### 2. Vector - Dynamic Array (`vector.fox`)

```morph
struktur Vector {
    buffer: ptr,
    length: i64,
    capacity: i64
}

fungsi vector_new() -> ptr
fungsi vector_push(v: ptr, item: i64) -> i64
fungsi vector_get(v: ptr, index: i64) -> i64
fungsi vector_set(v: ptr, index: i64, value: i64) -> i64
fungsi vector_length(v: ptr) -> i64
fungsi vector_free(v: ptr) -> void
```

**Usage Example:**
```morph
var v = vector_new()
vector_push(v, 10)
vector_push(v, 20)
var item = vector_get(v, 0)  ; Returns 10
vector_free(v)
```

### 3. HashMap - Hash Table (`hashmap.fox`)

```morph
struktur HashMap {
    buckets: ptr,
    size: i64,
    capacity: i64
}

fungsi hashmap_new() -> ptr
fungsi hashmap_insert(h: ptr, key: ptr, value: i64) -> i64
fungsi hashmap_get(h: ptr, key: ptr) -> i64
fungsi hashmap_has(h: ptr, key: ptr) -> i64
fungsi hashmap_free(h: ptr) -> void
```

**Usage Example:**
```morph
var h = hashmap_new()
hashmap_insert(h, "name", 100)
var value = hashmap_get(h, "name")  ; Returns 100
hashmap_free(h)
```

## Memory Safety

Semua komponen menggunakan memory safety API:
- `mem_alloc_safe()` / `mem_free_safe()` untuk allocation tracking
- `mem_load_safe()` / `mem_store_safe()` untuk bounds checking
- Automatic cleanup pada error conditions

## Integration

Library terintegrasi melalui `std.fox`:

```morph
ambil "../corelib/lib/std.fox"

fungsi utama() -> i64
    var version = stdlib_version()  ; Returns 20000 (v2.0.0)
    ; Use string, vector, hashmap functions...
    kembali 0
tutup_fungsi
```

## Compiler Usage

Komponen ini dirancang khusus untuk mendukung self-hosting compiler:

- **String operations**: Untuk lexer token processing
- **Vector**: Untuk AST node storage, instruction arrays
- **HashMap**: Untuk symbol table, identifier lookup

## Performance

- **Vector**: O(1) amortized push, O(1) random access
- **HashMap**: O(1) average case insert/lookup dengan chaining
- **String**: Optimized untuk compiler workloads

## Testing

Test suite tersedia di `tests/test_stdlib_v2.fox`:

```bash
cd morph
./bin/morph tests/test_stdlib_v2.fox
```

## Version History

- **v1.0.0**: Basic I/O, memory, threading
- **v2.0.0**: Added string, vector, hashmap for self-hosting

---

**Status**: ✅ READY FOR SELF-HOSTING COMPILER IMPLEMENTATION
