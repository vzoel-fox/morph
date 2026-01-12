# Enhanced Memory Safety & Exception Handling (v1.3)

## Overview

Sistem memory safety dan exception handling yang diperkuat untuk mendukung Phase 2 self-hosting compiler. Menyediakan foundation yang aman untuk development stdlib dan compiler.

## Key Features

### 🛡️ Memory Safety Guarantees

1. **Allocation Tracking**
   - Setiap alokasi dilacak dengan metadata
   - Magic number validation
   - Source location tracking (file:line)
   - Leak detection otomatis

2. **Bounds Checking**
   - Validasi akses memori dalam bounds
   - Protection dari buffer overflow
   - Runtime bounds verification

3. **Pointer Validation**
   - NULL pointer detection
   - Double-free protection
   - Invalid pointer access prevention

4. **Memory Debugging**
   - Allocation statistics
   - Leak detection dan reporting
   - Debug information dengan source location

### ⚡ Exception Handling System

1. **Exception Types**
   ```morph
   EXC_MEMORY        ; Memory allocation/deallocation errors
   EXC_BOUNDS        ; Out-of-bounds access
   EXC_NULL_PTR      ; NULL pointer dereference
   EXC_STACK_OVERFLOW; Stack overflow
   EXC_DIV_ZERO      ; Division by zero
   EXC_TYPE_ERROR    ; Type system violations
   EXC_IO_ERROR      ; I/O operations
   EXC_PARSE_ERROR   ; Parsing errors
   ```

2. **Exception Context**
   - Error code dan message
   - Source file dan line number
   - Exception stack untuk nested handling

## API Reference

### Memory Management

```morph
; Safe allocation with tracking
fungsi mem_alloc(size: i64) -> ptr

; Safe deallocation with validation
fungsi mem_free(ptr: ptr) -> void

; Bounds-checked memory access
fungsi mem_load(ptr: ptr, offset: i64) -> i64
fungsi mem_store(ptr: ptr, offset: i64, value: i64) -> void

; Debug location setting (for better error reporting)
fungsi set_debug_location(file: ptr, line: i64) -> void
```

### Exception Handling

```morph
; Initialize exception system
fungsi exception_init() -> void

; Throw exception with context
fungsi exception_throw(code: i64, message: ptr, file: ptr, line: i64) -> void

; Check if exception occurred
fungsi exception_occurred() -> i64

; Clear exception state
fungsi exception_clear() -> void
```

### Safe Arithmetic

```morph
; Overflow-safe addition
fungsi add_safe(a: i64, b: i64, file: ptr, line: i64) -> i64

; Division with zero-check
fungsi div_safe(a: i64, b: i64, file: ptr, line: i64) -> i64
```

### Memory Diagnostics

```morph
; Print memory usage statistics
fungsi mem_print_stats() -> void

; Check for memory leaks
fungsi mem_check_leaks() -> i64
```

## Usage Examples

### Basic Safe Memory Usage

```morph
ambil "corelib/core/memory_safety.fox"

fungsi example_basic() -> void
    ; Initialize exception system
    exception_init()
    
    ; Set debug location for better error reporting
    set_debug_location("example.fox", 10)
    
    ; Safe allocation
    var buffer = mem_alloc(1024)
    jika (buffer == 0) {
        ; Handle allocation failure
        kembali
    }
    
    ; Safe memory access
    mem_store(buffer, 0, 42)
    var value = mem_load(buffer, 0)
    
    ; Safe deallocation
    mem_free(buffer)
    
    ; Check for leaks
    mem_check_leaks()
tutup_fungsi
```

### Exception Handling

```morph
fungsi example_exception_handling() -> void
    exception_init()
    set_debug_location("example.fox", 35)
    
    ; This will trigger bounds exception
    var ptr = mem_alloc(64)
    
    ; Safe: within bounds
    mem_store(ptr, 0, 100)
    
    ; Unsafe: out of bounds (will throw exception)
    ; mem_store(ptr, 64, 200)  ; Don't do this!
    
    ; Check if exception occurred
    jika (exception_occurred()) {
        __mf_print_asciz("Exception caught and handled\n")
        exception_clear()
    }
    
    mem_free(ptr)
tutup_fungsi
```

### Memory Leak Detection

```morph
fungsi example_leak_detection() -> void
    exception_init()
    
    ; Allocate some memory
    var ptr1 = mem_alloc(256)
    var ptr2 = mem_alloc(512)
    
    ; Free only one (create intentional leak)
    mem_free(ptr1)
    
    ; Check for leaks
    var leak_count = mem_check_leaks()
    jika (leak_count > 0) {
        __mf_print_asciz("Memory leaks detected!\n")
    }
    
    ; Clean up
    mem_free(ptr2)
tutup_fungsi
```

## Integration with Phase 2

### Compiler Development Benefits

1. **Safe AST Construction**
   - Tracked allocation untuk AST nodes
   - Automatic leak detection
   - Bounds-checked node access

2. **Symbol Table Safety**
   - Safe hash table operations
   - Protected string operations
   - Memory-safe symbol lookup

3. **Parser Error Recovery**
   - Exception-based error handling
   - Context-aware error messages
   - Safe parser state recovery

### Future Enhancements

1. **Stack Unwinding**
   - Proper exception propagation
   - Automatic cleanup on exceptions
   - Try/catch syntax support

2. **Garbage Collection**
   - Reference counting
   - Mark-and-sweep collector
   - Generational GC

3. **Memory Pools**
   - Type-specific allocators
   - Reduced fragmentation
   - Better performance

## Testing

Run comprehensive tests:

```bash
cd /home/ubuntu/morph
./bin/morph tests/test_memory_safety.fox
```

Expected output:
```
=== MEMORY SAFETY & EXCEPTION HANDLER TESTS ===
Test 1: Basic allocation and deallocation
✓ Basic allocation test passed
Test 2: Bounds checking
✓ Bounds checking test passed
...
✓ All tests passed!
=== MEMORY STATISTICS ===
Total allocated: 0 bytes
Active allocations: 0
No memory leaks detected.
```

## Performance Impact

- **Overhead**: ~40 bytes per allocation (header)
- **Runtime**: ~10-20% slower due to safety checks
- **Benefits**: Eliminates entire classes of bugs
- **Trade-off**: Safety vs performance (configurable in future)

## Migration Path

1. **Phase 1**: Use existing unsafe memory functions
2. **Phase 2**: Migrate to safe memory functions
3. **Phase 3**: Enable full safety by default
4. **Future**: Add compile-time safety analysis

---

**Status**: Ready for Phase 2 development
**Priority**: Foundation for all stdlib and compiler development
**Dependencies**: builtins_v12.fox
