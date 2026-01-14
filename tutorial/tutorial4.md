# Tutorial 4: Concurrency with MorphRoutines

Master concurrent programming with Morph's lightweight MorphRoutines!

## 🎯 What You'll Learn

- MorphRoutines in depth
- Concurrent programming patterns
- Real-time systems design
- Performance optimization at scale

## 🔄 MorphRoutines Overview

MorphRoutines are Morph's lightweight concurrency primitive:

- **Cooperative scheduling**: Explicit yielding
- **Low overhead**: ~64 bytes per routine
- **No GC pauses**: Predictable performance
- **Stack-based**: Isolated execution contexts

## 🚀 Basic MorphRoutine Usage

```morph
ambil "../corelib/lib/morphroutine.fox"

; Simple worker routine
fungsi simple_worker() -> i64
    sistem 1, 1, "Worker: Starting task\n", 22
    
    var result = 0
    var i = 0
    selama i < 1000
        result = result + i
        
        ; Cooperative yield every 100 iterations
        jika (i % 100) == 0
            mr_yield(i)  ; Yield control, pass current progress
        tutup_jika
        
        i = i + 1
    tutup_selama
    
    sistem 1, 1, "Worker: Task completed\n", 23
    kembali result
tutup_fungsi

utama {
    sistem 1, 1, "🔄 Basic MorphRoutine\n", 22
    
    ; Create routine with 8KB stack
    var routine = mr_spawn(simple_worker, 8192)
    
    jika routine != 0
        sistem 1, 1, "✓ Routine created\n", 18
        
        ; Let it run
        mr_sleep(50)  ; 50ms
        
        ; Get final result
        var result = mr_resume(routine)
        sistem 1, 1, "Final result: ", 14
        print_number(result)
        sistem 1, 1, "\n", 1
        
        mr_destroy(routine)
    tutup_jika
    
    kembali 0
}
```

## 🏭 Producer-Consumer Pattern

```morph
ambil "../corelib/lib/morphroutine.fox"

; Shared buffer (simple implementation)
var g_buffer = 0
var g_buffer_size = 0
var g_buffer_count = 0

fungsi init_buffer(size: i64) -> void
    g_buffer = __mf_mem_alloc(size * 8)
    g_buffer_size = size
    g_buffer_count = 0
tutup_fungsi

fungsi buffer_put(value: i64) -> i64
    jika g_buffer_count >= g_buffer_size
        kembali 0  ; Buffer full
    tutup_jika
    
    __mf_poke_i64(g_buffer + (g_buffer_count * 8), value)
    g_buffer_count = g_buffer_count + 1
    kembali 1  ; Success
tutup_fungsi

fungsi buffer_get() -> i64
    jika g_buffer_count == 0
        kembali -1  ; Buffer empty
    tutup_jika
    
    g_buffer_count = g_buffer_count - 1
    kembali __mf_load_i64(g_buffer + (g_buffer_count * 8))
tutup_fungsi

; Producer routine
fungsi producer() -> i64
    sistem 1, 1, "Producer: Starting\n", 19
    
    var produced = 0
    var i = 1
    selama i <= 10
        jika buffer_put(i) == 1
            sistem 1, 1, "Produced: ", 10
            print_number(i)
            sistem 1, 1, "\n", 1
            produced = produced + 1
        lain
            sistem 1, 1, "Buffer full, yielding...\n", 25
            mr_yield(produced)
        tutup_jika
        
        i = i + 1
        mr_sleep(10)  ; Simulate work
    tutup_selama
    
    sistem 1, 1, "Producer: Finished\n", 19
    kembali produced
tutup_fungsi

; Consumer routine
fungsi consumer() -> i64
    sistem 1, 1, "Consumer: Starting\n", 19
    
    var consumed = 0
    var attempts = 0
    
    selama attempts < 20  ; Try up to 20 times
        var value = buffer_get()
        jika value != -1
            sistem 1, 1, "Consumed: ", 10
            print_number(value)
            sistem 1, 1, "\n", 1
            consumed = consumed + 1
        lain
            mr_yield(consumed)  ; Buffer empty, yield
        tutup_jika
        
        attempts = attempts + 1
        mr_sleep(15)  ; Simulate processing
    tutup_selama
    
    sistem 1, 1, "Consumer: Finished\n", 19
    kembali consumed
tutup_fungsi

utama {
    sistem 1, 1, "🏭 Producer-Consumer Pattern\n", 30
    
    ; Initialize shared buffer
    init_buffer(5)
    
    ; Create producer and consumer
    var prod = mr_spawn(producer, 8192)
    var cons = mr_spawn(consumer, 8192)
    
    jika prod != 0 dan cons != 0
        sistem 1, 1, "✓ Both routines created\n", 24
        
        ; Let them run concurrently
        mr_sleep(500)  ; 500ms
        
        ; Get results
        var produced = mr_resume(prod)
        var consumed = mr_resume(cons)
        
        sistem 1, 1, "\nSummary:\n", 10
        sistem 1, 1, "Produced: ", 10
        print_number(produced)
        sistem 1, 1, "\nConsumed: ", 11
        print_number(consumed)
        sistem 1, 1, "\n", 1
        
        mr_destroy(prod)
        mr_destroy(cons)
    tutup_jika
    
    __mf_mem_free(g_buffer)
    kembali 0
}
```

## ⚡ Parallel Processing

```morph
ambil "../corelib/lib/morphroutine.fox"

; Parallel computation task
fungsi parallel_sum(start: i64, end: i64) -> i64
    var sum = 0
    var i = start
    
    selama i <= end
        sum = sum + i
        
        ; Yield periodically for fairness
        jika (i % 1000) == 0
            mr_yield(sum)
        tutup_jika
        
        i = i + 1
    tutup_selama
    
    kembali sum
tutup_fungsi

; Worker wrapper that takes range parameters
fungsi worker1() -> i64
    kembali parallel_sum(1, 25000)
tutup_fungsi

fungsi worker2() -> i64
    kembali parallel_sum(25001, 50000)
tutup_fungsi

fungsi worker3() -> i64
    kembali parallel_sum(50001, 75000)
tutup_fungsi

fungsi worker4() -> i64
    kembali parallel_sum(75001, 100000)
tutup_fungsi

utama {
    sistem 1, 1, "⚡ Parallel Processing Demo\n", 28
    
    var start_time = mr_now()
    
    ; Create 4 worker routines
    var w1 = mr_spawn(worker1, 8192)
    var w2 = mr_spawn(worker2, 8192)
    var w3 = mr_spawn(worker3, 8192)
    var w4 = mr_spawn(worker4, 8192)
    
    sistem 1, 1, "✓ 4 workers created\n", 20
    sistem 1, 1, "Computing sum of 1 to 100,000...\n", 34
    
    ; Let workers run
    mr_sleep(200)  ; 200ms
    
    ; Collect results
    var sum1 = mr_resume(w1)
    var sum2 = mr_resume(w2)
    var sum3 = mr_resume(w3)
    var sum4 = mr_resume(w4)
    
    var total = sum1 + sum2 + sum3 + sum4
    var end_time = mr_now()
    var duration = end_time - start_time
    
    sistem 1, 1, "\nResults:\n", 10
    sistem 1, 1, "Worker 1: ", 10
    print_number(sum1)
    sistem 1, 1, "\nWorker 2: ", 11
    print_number(sum2)
    sistem 1, 1, "\nWorker 3: ", 11
    print_number(sum3)
    sistem 1, 1, "\nWorker 4: ", 11
    print_number(sum4)
    sistem 1, 1, "\n\nTotal: ", 8
    print_number(total)
    sistem 1, 1, "\nTime: ", 7
    print_number(duration)
    sistem 1, 1, " ms\n", 4
    
    ; Cleanup
    mr_destroy(w1)
    mr_destroy(w2)
    mr_destroy(w3)
    mr_destroy(w4)
    
    kembali 0
}
```

## 🎯 Real-Time Task Scheduling

```morph
ambil "../corelib/lib/morphroutine.fox"

; Task priorities
const PRIORITY_HIGH = 1
const PRIORITY_NORMAL = 2
const PRIORITY_LOW = 3

; High priority task (real-time)
fungsi realtime_task() -> i64
    var iterations = 0
    
    selama iterations < 100
        ; Critical real-time work
        var timestamp = mr_now()
        
        ; Simulate real-time processing
        var i = 0
        selama i < 100
            i = i + 1
        tutup_selama
        
        iterations = iterations + 1
        
        ; High priority tasks yield less frequently
        jika (iterations % 50) == 0
            mr_yield(iterations)
        tutup_jika
    tutup_selama
    
    sistem 1, 1, "Real-time task completed\n", 25
    kembali iterations
tutup_fungsi

; Normal priority task
fungsi normal_task() -> i64
    var work_done = 0
    
    selama work_done < 50
        ; Regular processing
        var result = work_done * work_done
        work_done = work_done + 1
        
        ; Normal tasks yield more frequently
        jika (work_done % 10) == 0
            mr_yield(work_done)
        tutup_jika
    tutup_selama
    
    sistem 1, 1, "Normal task completed\n", 22
    kembali work_done
tutup_fungsi

; Background task (low priority)
fungsi background_task() -> i64
    var processed = 0
    
    selama processed < 20
        ; Background processing
        processed = processed + 1
        
        ; Background tasks yield very frequently
        mr_yield(processed)
        mr_sleep(5)  ; Be nice to other tasks
    tutup_selama
    
    sistem 1, 1, "Background task completed\n", 26
    kembali processed
tutup_fungsi

utama {
    sistem 1, 1, "🎯 Real-Time Task Scheduling\n", 30
    
    var start = mr_now()
    
    ; Create tasks with different priorities
    var rt_task = mr_spawn(realtime_task, 8192)
    var normal = mr_spawn(normal_task, 8192)
    var bg_task = mr_spawn(background_task, 8192)
    
    sistem 1, 1, "✓ Tasks created (RT, Normal, Background)\n", 41
    
    ; Run for a while
    mr_sleep(300)  ; 300ms
    
    ; Collect results
    var rt_result = mr_resume(rt_task)
    var normal_result = mr_resume(normal)
    var bg_result = mr_resume(bg_task)
    
    var end = mr_now()
    var total_time = end - start
    
    sistem 1, 1, "\nTask Results:\n", 15
    sistem 1, 1, "Real-time: ", 11
    print_number(rt_result)
    sistem 1, 1, "\nNormal: ", 9
    print_number(normal_result)
    sistem 1, 1, "\nBackground: ", 12
    print_number(bg_result)
    sistem 1, 1, "\nTotal time: ", 12
    print_number(total_time)
    sistem 1, 1, " ms\n", 4
    
    mr_destroy(rt_task)
    mr_destroy(normal)
    mr_destroy(bg_task)
    
    kembali 0
}
```

## 🔧 Performance Monitoring

```morph
ambil "../corelib/lib/morphroutine.fox"

; Performance monitoring routine
fungsi monitor_system() -> i64
    var samples = 0
    var start_time = mr_now()
    
    selama samples < 10
        var current_time = mr_now()
        var uptime = current_time - start_time
        
        sistem 1, 1, "Monitor: Uptime ", 16
        print_number(uptime)
        sistem 1, 1, " ms, Sample ", 12
        print_number(samples + 1)
        sistem 1, 1, "\n", 1
        
        samples = samples + 1
        mr_sleep(100)  ; Sample every 100ms
        mr_yield(samples)
    tutup_selama
    
    kembali samples
tutup_fungsi

; CPU-intensive task for monitoring
fungsi cpu_intensive_task() -> i64
    var cycles = 0
    
    selama cycles < 1000000
        ; Simulate CPU work
        var temp = cycles * cycles
        cycles = cycles + 1
        
        ; Yield occasionally
        jika (cycles % 10000) == 0
            mr_yield(cycles)
        tutup_jika
    tutup_selama
    
    sistem 1, 1, "CPU task: 1M cycles completed\n", 31
    kembali cycles
tutup_fungsi

utama {
    sistem 1, 1, "🔧 Performance Monitoring\n", 27
    
    ; Start monitoring
    var monitor = mr_spawn(monitor_system, 8192)
    var cpu_task = mr_spawn(cpu_intensive_task, 8192)
    
    sistem 1, 1, "✓ Monitor and CPU task started\n", 32
    
    ; Let them run
    mr_sleep(1200)  ; 1.2 seconds
    
    ; Get results
    var monitor_samples = mr_resume(monitor)
    var cpu_cycles = mr_resume(cpu_task)
    
    sistem 1, 1, "\nMonitoring Summary:\n", 20
    sistem 1, 1, "Samples taken: ", 15
    print_number(monitor_samples)
    sistem 1, 1, "\nCPU cycles: ", 12
    print_number(cpu_cycles)
    sistem 1, 1, "\n", 1
    
    mr_destroy(monitor)
    mr_destroy(cpu_task)
    
    kembali 0
}
```

## 🎮 Practice Exercises

1. **Task Queue**: Implement a priority-based task queue system
2. **Load Balancer**: Create a load balancing system with multiple workers
3. **Pipeline**: Build a data processing pipeline with stages
4. **Real-Time Game Loop**: Implement a game loop with fixed timesteps

## 📖 Key Concepts

- **Cooperative Scheduling**: Explicit yielding with `mr_yield()`
- **Stack Isolation**: Each routine has its own stack space
- **Low Overhead**: Minimal memory and CPU cost per routine
- **Predictable Performance**: No GC pauses or preemption
- **Real-Time Friendly**: Deterministic behavior for time-critical tasks

## ✅ Complete Example: Concurrent Web Server Simulation

```morph
ambil "../corelib/lib/morphroutine.fox"

; Request processing simulation
fungsi handle_request(request_id: i64) -> i64
    sistem 1, 1, "Handling request ", 17
    print_number(request_id)
    sistem 1, 1, "\n", 1
    
    ; Simulate request processing time
    var processing_time = (request_id % 3) + 1  ; 1-3 units
    var i = 0
    selama i < processing_time * 100
        i = i + 1
    tutup_selama
    
    ; Yield to allow other requests
    mr_yield(request_id)
    
    sistem 1, 1, "Completed request ", 18
    print_number(request_id)
    sistem 1, 1, "\n", 1
    
    kembali request_id
tutup_fungsi

; Worker routines for different request IDs
fungsi worker_req1() -> i64
    kembali handle_request(1)
tutup_fungsi

fungsi worker_req2() -> i64
    kembali handle_request(2)
tutup_fungsi

fungsi worker_req3() -> i64
    kembali handle_request(3)
tutup_fungsi

fungsi worker_req4() -> i64
    kembali handle_request(4)
tutup_fungsi

fungsi worker_req5() -> i64
    kembali handle_request(5)
tutup_fungsi

utama {
    sistem 1, 1, "🌐 Concurrent Web Server Simulation\n", 37
    
    var start_time = mr_now()
    
    ; Create worker routines for 5 concurrent requests
    var req1 = mr_spawn(worker_req1, 8192)
    var req2 = mr_spawn(worker_req2, 8192)
    var req3 = mr_spawn(worker_req3, 8192)
    var req4 = mr_spawn(worker_req4, 8192)
    var req5 = mr_spawn(worker_req5, 8192)
    
    sistem 1, 1, "✓ 5 request handlers spawned\n", 30
    
    ; Let requests process concurrently
    mr_sleep(200)  ; 200ms
    
    ; Collect results
    var result1 = mr_resume(req1)
    var result2 = mr_resume(req2)
    var result3 = mr_resume(req3)
    var result4 = mr_resume(req4)
    var result5 = mr_resume(req5)
    
    var end_time = mr_now()
    var total_time = end_time - start_time
    
    sistem 1, 1, "\n📊 Server Statistics:\n", 23
    sistem 1, 1, "Requests processed: 5\n", 22
    sistem 1, 1, "Total time: ", 12
    print_number(total_time)
    sistem 1, 1, " ms\n", 4
    sistem 1, 1, "Avg time per request: ", 22
    print_number(total_time / 5)
    sistem 1, 1, " ms\n", 4
    
    ; Cleanup
    mr_destroy(req1)
    mr_destroy(req2)
    mr_destroy(req3)
    mr_destroy(req4)
    mr_destroy(req5)
    
    sistem 1, 1, "✓ All requests completed\n", 25
    kembali 0
}
```

## 🚀 Next Steps

Continue to [Tutorial 5: Real-World Applications](tutorial5.md)

- Building complete applications
- Integration with system APIs
- Networking and I/O
- Production deployment strategies
