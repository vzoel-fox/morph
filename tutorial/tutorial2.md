# Tutorial 2: Advanced Features

Now let's explore MorphFox's powerful advanced features!

## 🎯 What You'll Learn

- Memory management with arenas
- Data structures and structs
- MorphRoutines (lightweight concurrency)
- Performance optimization techniques

## 🧠 Memory Management

MorphFox uses custom memory management for performance:

### Arena Allocation

```morphfox
utama {
    ; Create 4KB arena
    var arena = __mf_arena_create(4096)
    
    ; Allocate memory from arena
    var ptr1 = __mf_arena_alloc(arena, 64)
    var ptr2 = __mf_arena_alloc(arena, 128)
    
    ; Check usage
    var usage = __mf_arena_usage(arena)
    sistem 1, 1, "Arena usage: ", 13
    print_number(usage)
    sistem 1, 1, " bytes\n", 7
    
    ; Instant cleanup - reset entire arena
    __mf_arena_reset(arena)
    sistem 1, 1, "Arena reset - all memory freed!\n", 33
    
    kembali 0
}
```

### Manual Memory Management

```morphfox
utama {
    ; Allocate memory
    var ptr = __mf_mem_alloc(1024)
    
    ; Use memory
    __mf_poke_i64(ptr, 42)
    var value = __mf_load_i64(ptr)
    
    ; Free memory
    __mf_mem_free(ptr)
    
    kembali 0
}
```

## 📊 Data Structures

### Simulating Structs

```morphfox
; Point struct: { x: i64, y: i64 }
fungsi create_point(x: i64, y: i64) -> ptr
    var point = __mf_mem_alloc(16)  ; 2 * 8 bytes
    __mf_poke_i64(point + 0, x)     ; x coordinate
    __mf_poke_i64(point + 8, y)     ; y coordinate
    kembali point
tutup_fungsi

fungsi point_distance(p1: ptr, p2: ptr) -> i64
    var x1 = __mf_load_i64(p1 + 0)
    var y1 = __mf_load_i64(p1 + 8)
    var x2 = __mf_load_i64(p2 + 0)
    var y2 = __mf_load_i64(p2 + 8)
    
    var dx = x2 - x1
    var dy = y2 - y1
    
    ; Simplified distance (no sqrt)
    kembali (dx * dx) + (dy * dy)
tutup_fungsi

utama {
    var p1 = create_point(0, 0)
    var p2 = create_point(3, 4)
    
    var dist = point_distance(p1, p2)
    sistem 1, 1, "Distance squared: ", 18
    print_number(dist)  ; Should be 25
    sistem 1, 1, "\n", 1
    
    __mf_mem_free(p1)
    __mf_mem_free(p2)
    
    kembali 0
}
```

## 🔄 MorphRoutines (Concurrency)

MorphRoutines are lightweight threads for concurrent programming:

```morphfox
ambil "../corelib/lib/morphroutine.fox"

; Worker function
fungsi worker_task() -> i64
    sistem 1, 1, "  Worker: Starting...\n", 22
    
    ; Simulate work
    var result = 0
    var i = 0
    selama i < 1000
        result = result + i
        
        ; Cooperative yield every 100 iterations
        jika (i % 100) == 0
            mr_yield(i)
        tutup_jika
        
        i = i + 1
    tutup_selama
    
    sistem 1, 1, "  Worker: Completed!\n", 21
    kembali result
tutup_fungsi

utama {
    sistem 1, 1, "🔄 MorphRoutine Demo\n", 21
    
    ; Create routine with 8KB stack
    var routine = mr_spawn(worker_task, 8192)
    
    jika routine != 0
        sistem 1, 1, "✓ MorphRoutine created\n", 23
        
        ; Let it run for a bit
        mr_sleep(100)  ; 100ms
        
        ; Resume if needed
        var result = mr_resume(routine)
        sistem 1, 1, "✓ Result: ", 10
        print_number(result)
        sistem 1, 1, "\n", 1
        
        ; Cleanup
        mr_destroy(routine)
    lain
        sistem 1, 1, "✗ Failed to create routine\n", 28
    tutup_jika
    
    kembali 0
}
```

## ⚡ Performance Optimization

### Timing and Benchmarking

```morphfox
ambil "../corelib/lib/morphroutine.fox"

fungsi benchmark_function() -> i64
    var start = mr_now()
    
    ; Intensive computation
    var result = 0
    var i = 0
    selama i < 100000
        result = result + (i * i)
        i = i + 1
    tutup_selama
    
    var end = mr_now()
    var duration = end - start
    
    sistem 1, 1, "Computation result: ", 20
    print_number(result)
    sistem 1, 1, "\nTime taken: ", 12
    print_number(duration)
    sistem 1, 1, " ms\n", 4
    
    kembali duration
tutup_fungsi

utama {
    sistem 1, 1, "⚡ Performance Benchmark\n", 25
    
    ; Run benchmark
    var time1 = benchmark_function()
    
    ; Compare with optimized version
    sistem 1, 1, "\nOptimized version:\n", 19
    var time2 = benchmark_function()
    
    sistem 1, 1, "\nPerformance comparison complete!\n", 33
    kembali 0
}
```

### Memory Pool Pattern

```morphfox
; Object pool for frequent allocations
fungsi create_object_pool(object_size: i64, count: i64) -> ptr
    var pool_size = object_size * count
    var pool = __mf_arena_create(pool_size)
    kembali pool
tutup_fungsi

fungsi pool_alloc(pool: ptr, object_size: i64) -> ptr
    kembali __mf_arena_alloc(pool, object_size)
tutup_fungsi

utama {
    ; Create pool for 100 objects of 64 bytes each
    var pool = create_object_pool(64, 100)
    
    ; Fast allocations
    var obj1 = pool_alloc(pool, 64)
    var obj2 = pool_alloc(pool, 64)
    var obj3 = pool_alloc(pool, 64)
    
    sistem 1, 1, "✓ Pool allocations complete\n", 28
    
    ; Reset entire pool at once
    __mf_arena_reset(pool)
    sistem 1, 1, "✓ Pool reset - instant cleanup\n", 31
    
    kembali 0
}
```

## 🎮 Practice Exercises

1. **Memory Manager**: Create a custom allocator with tracking
2. **Concurrent Calculator**: Use MorphRoutines for parallel computation
3. **Data Structure Library**: Implement linked list, stack, queue
4. **Performance Profiler**: Measure and optimize function performance

## 📖 Key Concepts

- **Arena Allocation**: Batch memory management for performance
- **MorphRoutines**: Cooperative lightweight threads
- **Memory Pools**: Efficient allocation patterns
- **Performance Timing**: Benchmarking with `mr_now()`
- **Cooperative Yielding**: `mr_yield()` for fair scheduling

## ✅ Complete Example: Concurrent Prime Finder

```morphfox
ambil "../corelib/lib/morphroutine.fox"

fungsi is_prime(n: i64) -> i64
    jika n < 2
        kembali 0
    tutup_jika
    
    var i = 2
    selama i * i <= n
        jika (n % i) == 0
            kembali 0
        tutup_jika
        i = i + 1
    tutup_selama
    
    kembali 1
tutup_fungsi

fungsi prime_worker() -> i64
    var found = 0
    var n = 2
    
    selama n < 1000
        jika is_prime(n) == 1
            found = found + 1
        tutup_jika
        
        n = n + 1
        
        ; Yield every 10 numbers
        jika (n % 10) == 0
            mr_yield(found)
        tutup_jika
    tutup_selama
    
    kembali found
tutup_fungsi

utama {
    sistem 1, 1, "🔍 Concurrent Prime Finder\n", 28
    
    var routine = mr_spawn(prime_worker, 8192)
    jika routine != 0
        mr_sleep(100)
        var primes = mr_resume(routine)
        
        sistem 1, 1, "Found ", 6
        print_number(primes)
        sistem 1, 1, " primes under 1000\n", 19
        
        mr_destroy(routine)
    tutup_jika
    
    kembali 0
}
```

## 🚀 Next Steps

Continue to [Tutorial 3: Type System](tutorial3.md)

- Advanced types (structs, arrays, unions)
- Generics and type aliases
- Type checking and validation
- Error handling
