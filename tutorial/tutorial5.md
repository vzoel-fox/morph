# Tutorial 5: Real-World Applications

Build production-ready applications with Morph!

## 🎯 What You'll Learn

- Building complete applications
- System integration and APIs
- Networking and I/O operations
- Production deployment strategies
- Performance optimization at scale

## 🏗️ Application Architecture

### Project Structure

```
my_app/
├── src/
│   ├── main.fox          # Entry point
│   ├── core/             # Core business logic
│   ├── network/          # Networking modules
│   ├── storage/          # Data persistence
│   └── utils/            # Utility functions
├── tests/                # Test suite
├── docs/                 # Documentation
└── build.sh             # Build script
```

### Main Application Template

```morph
; main.fox - Application entry point
ambil "core/app_core.fox"
ambil "network/server.fox"
ambil "storage/database.fox"
ambil "../corelib/lib/morphroutine.fox"

; Application configuration
const APP_VERSION = "1.0.0"
const DEFAULT_PORT = 8080
const MAX_CONNECTIONS = 1000

; Global application state
var g_app_running = 1
var g_connection_count = 0

utama {
    sistem 1, 1, "🚀 Morph Application v", 26
    sistem 1, 1, APP_VERSION, 5
    sistem 1, 1, "\n", 1
    sistem 1, 1, "========================\n", 24
    
    ; Initialize application
    var init_result = app_initialize()
    jika init_result != 0
        sistem 1, 1, "❌ Application initialization failed\n", 38
        kembali 1
    tutup_jika
    
    sistem 1, 1, "✅ Application initialized\n", 28
    
    ; Start main application loop
    var exit_code = app_main_loop()
    
    ; Cleanup
    app_cleanup()
    
    sistem 1, 1, "👋 Application shutdown complete\n", 34
    kembali exit_code
}

fungsi app_initialize() -> i64
    sistem 1, 1, "Initializing core systems...\n", 30
    
    ; Initialize memory management
    var memory_ok = init_memory_system()
    jika memory_ok != 1
        kembali -1
    tutup_jika
    
    ; Initialize networking
    var network_ok = init_network_system()
    jika network_ok != 1
        kembali -2
    tutup_jika
    
    ; Initialize storage
    var storage_ok = init_storage_system()
    jika storage_ok != 1
        kembali -3
    tutup_jika
    
    sistem 1, 1, "✅ All systems initialized\n", 28
    kembali 0
tutup_fungsi

fungsi app_main_loop() -> i64
    sistem 1, 1, "Starting main application loop...\n", 34
    
    ; Start server
    var server = start_server(DEFAULT_PORT)
    jika server == 0
        sistem 1, 1, "❌ Failed to start server\n", 27
        kembali 1
    tutup_jika
    
    sistem 1, 1, "🌐 Server listening on port ", 29
    print_number(DEFAULT_PORT)
    sistem 1, 1, "\n", 1
    
    ; Main event loop
    selama g_app_running == 1
        ; Process incoming connections
        handle_connections(server)
        
        ; Perform maintenance tasks
        perform_maintenance()
        
        ; Yield to other routines
        mr_yield(g_connection_count)
        mr_sleep(10)  ; 10ms cycle
    tutup_selama
    
    ; Stop server
    stop_server(server)
    kembali 0
tutup_fungsi

fungsi app_cleanup() -> void
    sistem 1, 1, "Cleaning up resources...\n", 25
    
    cleanup_storage_system()
    cleanup_network_system()
    cleanup_memory_system()
    
    sistem 1, 1, "✅ Cleanup complete\n", 20
tutup_fungsi
```

## 🌐 Networking Module

```morph
; network/server.fox - HTTP server implementation
ambil "../../corelib/lib/morphroutine.fox"

; Server state
const SERVER_STOPPED = 0
const SERVER_RUNNING = 1
const SERVER_ERROR = -1

; Connection handling
const MAX_REQUEST_SIZE = 4096
const CONNECTION_TIMEOUT = 30000  ; 30 seconds

fungsi start_server(port: i64) -> ptr
    sistem 1, 1, "Starting HTTP server on port ", 30
    print_number(port)
    sistem 1, 1, "...\n", 4
    
    ; Create server structure
    var server = __mf_mem_alloc(32)
    __mf_poke_i64(server + 0, port)           ; Port
    __mf_poke_i64(server + 8, SERVER_RUNNING) ; Status
    __mf_poke_i64(server + 16, 0)            ; Connection count
    __mf_poke_i64(server + 24, mr_now())     ; Start time
    
    ; In real implementation, would bind to socket
    sistem 1, 1, "✅ Server started successfully\n", 31
    
    kembali server
tutup_fungsi

fungsi handle_connections(server: ptr) -> void
    var connection_count = __mf_load_i64(server + 16)
    
    ; Simulate incoming connections
    var new_connections = simulate_incoming_requests()
    
    jika new_connections > 0
        ; Spawn worker routines for each connection
        var i = 0
        selama i < new_connections
            var worker = mr_spawn(connection_handler, 8192)
            jika worker != 0
                connection_count = connection_count + 1
                ; In real app, would track worker routines
                mr_destroy(worker)  ; Simplified cleanup
            tutup_jika
            i = i + 1
        tutup_selama
        
        __mf_poke_i64(server + 16, connection_count)
        g_connection_count = connection_count
    tutup_jika
tutup_fungsi

fungsi connection_handler() -> i64
    ; Simulate HTTP request processing
    sistem 1, 1, "📨 Processing HTTP request\n", 27
    
    ; Parse request (simplified)
    var request_type = parse_http_request()
    
    ; Route request
    var response = route_request(request_type)
    
    ; Send response
    send_http_response(response)
    
    sistem 1, 1, "✅ Request completed\n", 21
    kembali 0
tutup_fungsi

fungsi parse_http_request() -> i64
    ; Simulate request parsing
    mr_sleep(5)  ; Parsing time
    kembali 1    ; GET request
tutup_fungsi

fungsi route_request(request_type: i64) -> ptr
    ; Create response structure
    var response = __mf_mem_alloc(24)
    __mf_poke_i64(response + 0, 200)    ; Status code
    __mf_poke_i64(response + 8, 1234)   ; Content length
    __mf_poke_i64(response + 16, mr_now()) ; Timestamp
    
    ; Simulate routing logic
    mr_sleep(2)
    
    kembali response
tutup_fungsi

fungsi send_http_response(response: ptr) -> void
    var status = __mf_load_i64(response + 0)
    var content_length = __mf_load_i64(response + 8)
    
    ; Simulate sending response
    mr_sleep(3)
    
    __mf_mem_free(response)
tutup_fungsi

fungsi simulate_incoming_requests() -> i64
    ; Simulate random incoming requests
    var current_time = mr_now()
    kembali (current_time % 3)  ; 0-2 requests per cycle
tutup_fungsi

fungsi stop_server(server: ptr) -> void
    __mf_poke_i64(server + 8, SERVER_STOPPED)
    sistem 1, 1, "🛑 Server stopped\n", 18
    __mf_mem_free(server)
tutup_fungsi
```

## 💾 Storage Module

```morph
; storage/database.fox - Data persistence
ambil "../../corelib/lib/morphroutine.fox"

; Database operations
const DB_SUCCESS = 0
const DB_ERROR = -1
const DB_NOT_FOUND = -2

; Record structure
const RECORD_ID = 0
const RECORD_DATA = 8
const RECORD_TIMESTAMP = 16
const RECORD_SIZE = 24

var g_database_arena = 0
var g_record_count = 0

fungsi init_storage_system() -> i64
    sistem 1, 1, "Initializing storage system...\n", 32
    
    ; Create database arena (10MB)
    g_database_arena = __mf_arena_create(10 * 1024 * 1024)
    jika g_database_arena == 0
        kembali DB_ERROR
    tutup_jika
    
    g_record_count = 0
    sistem 1, 1, "✅ Storage system ready\n", 24
    kembali 1
tutup_fungsi

fungsi db_insert(id: i64, data: i64) -> i64
    jika g_database_arena == 0
        kembali DB_ERROR
    tutup_jika
    
    ; Allocate record
    var record = __mf_arena_alloc(g_database_arena, RECORD_SIZE)
    jika record == 0
        kembali DB_ERROR
    tutup_jika
    
    ; Fill record
    __mf_poke_i64(record + RECORD_ID, id)
    __mf_poke_i64(record + RECORD_DATA, data)
    __mf_poke_i64(record + RECORD_TIMESTAMP, mr_now())
    
    g_record_count = g_record_count + 1
    
    sistem 1, 1, "💾 Inserted record ID ", 23
    print_number(id)
    sistem 1, 1, "\n", 1
    
    kembali DB_SUCCESS
tutup_fungsi

fungsi db_query(id: i64) -> i64
    ; Simplified query - in real implementation would search records
    sistem 1, 1, "🔍 Querying record ID ", 23
    print_number(id)
    sistem 1, 1, "\n", 1
    
    ; Simulate query time
    mr_sleep(1)
    
    ; Return mock data
    kembali id * 100
tutup_fungsi

fungsi db_update(id: i64, new_data: i64) -> i64
    sistem 1, 1, "✏️  Updating record ID ", 24
    print_number(id)
    sistem 1, 1, " with data ", 11
    print_number(new_data)
    sistem 1, 1, "\n", 1
    
    ; Simulate update time
    mr_sleep(2)
    
    kembali DB_SUCCESS
tutup_fungsi

fungsi db_delete(id: i64) -> i64
    sistem 1, 1, "🗑️  Deleting record ID ", 24
    print_number(id)
    sistem 1, 1, "\n", 1
    
    ; Simulate deletion
    mr_sleep(1)
    
    jika g_record_count > 0
        g_record_count = g_record_count - 1
    tutup_jika
    
    kembali DB_SUCCESS
tutup_fungsi

fungsi db_stats() -> void
    var usage = __mf_arena_usage(g_database_arena)
    
    sistem 1, 1, "📊 Database Statistics:\n", 24
    sistem 1, 1, "Records: ", 9
    print_number(g_record_count)
    sistem 1, 1, "\nMemory used: ", 13
    print_number(usage / 1024)
    sistem 1, 1, " KB\n", 4
tutup_fungsi

fungsi cleanup_storage_system() -> void
    jika g_database_arena != 0
        __mf_arena_reset(g_database_arena)
        sistem 1, 1, "✅ Storage system cleaned up\n", 29
    tutup_jika
tutup_fungsi
```

## 🔧 Utility Functions

```morph
; utils/helpers.fox - Common utilities
ambil "../../corelib/lib/morphroutine.fox"

; String utilities
fungsi string_length(str: ptr) -> i64
    var len = 0
    selama __mf_load_i8(str + len) != 0
        len = len + 1
    tutup_selama
    kembali len
tutup_fungsi

fungsi string_copy(dest: ptr, src: ptr, max_len: i64) -> i64
    var i = 0
    selama i < max_len
        var ch = __mf_load_i8(src + i)
        __mf_poke_i8(dest + i, ch)
        jika ch == 0
            kembali i
        tutup_jika
        i = i + 1
    tutup_selama
    kembali i
tutup_fungsi

; Math utilities
fungsi min(a: i64, b: i64) -> i64
    jika a < b
        kembali a
    tutup_jika
    kembali b
tutup_fungsi

fungsi max(a: i64, b: i64) -> i64
    jika a > b
        kembali a
    tutup_jika
    kembali b
tutup_fungsi

fungsi clamp(value: i64, min_val: i64, max_val: i64) -> i64
    jika value < min_val
        kembali min_val
    tutup_jika
    jika value > max_val
        kembali max_val
    tutup_jika
    kembali value
tutup_fungsi

; Timing utilities
fungsi benchmark_start() -> i64
    kembali mr_now()
tutup_fungsi

fungsi benchmark_end(start_time: i64) -> i64
    kembali mr_now() - start_time
tutup_fungsi

; Logging utilities
fungsi log_info(message: ptr) -> void
    var timestamp = mr_now()
    sistem 1, 1, "[INFO ", 6
    print_number(timestamp)
    sistem 1, 1, "] ", 2
    sistem 1, 1, message, string_length(message)
    sistem 1, 1, "\n", 1
tutup_fungsi

fungsi log_error(message: ptr) -> void
    var timestamp = mr_now()
    sistem 1, 1, "[ERROR ", 7
    print_number(timestamp)
    sistem 1, 1, "] ", 2
    sistem 1, 1, message, string_length(message)
    sistem 1, 1, "\n", 1
tutup_fungsi
```

## 🧪 Testing Framework

```morph
; tests/test_framework.fox - Simple testing framework
ambil "../src/core/app_core.fox"
ambil "../src/storage/database.fox"

var g_tests_run = 0
var g_tests_passed = 0

fungsi test_assert(condition: i64, test_name: ptr) -> void
    g_tests_run = g_tests_run + 1
    
    jika condition == 1
        sistem 1, 1, "✅ PASS: ", 10
        g_tests_passed = g_tests_passed + 1
    lain
        sistem 1, 1, "❌ FAIL: ", 10
    tutup_jika
    
    sistem 1, 1, test_name, string_length(test_name)
    sistem 1, 1, "\n", 1
tutup_fungsi

fungsi test_database() -> void
    sistem 1, 1, "\n🧪 Testing Database Module\n", 28
    
    ; Test initialization
    var init_result = init_storage_system()
    test_assert(init_result == 1, "Database initialization")
    
    ; Test insert
    var insert_result = db_insert(1, 100)
    test_assert(insert_result == DB_SUCCESS, "Record insertion")
    
    ; Test query
    var query_result = db_query(1)
    test_assert(query_result == 100, "Record query")
    
    ; Test update
    var update_result = db_update(1, 200)
    test_assert(update_result == DB_SUCCESS, "Record update")
    
    ; Test delete
    var delete_result = db_delete(1)
    test_assert(delete_result == DB_SUCCESS, "Record deletion")
    
    cleanup_storage_system()
tutup_fungsi

fungsi test_utilities() -> void
    sistem 1, 1, "\n🧪 Testing Utility Functions\n", 29
    
    ; Test math functions
    test_assert(min(5, 3) == 3, "Min function")
    test_assert(max(5, 3) == 5, "Max function")
    test_assert(clamp(10, 0, 5) == 5, "Clamp function")
    
    ; Test timing
    var start = benchmark_start()
    mr_sleep(10)
    var duration = benchmark_end(start)
    test_assert(duration >= 10, "Benchmark timing")
tutup_fungsi

fungsi run_all_tests() -> i64
    sistem 1, 1, "🧪 MorphFox Application Test Suite\n", 36
    sistem 1, 1, "==================================\n", 34
    
    ; Run test suites
    test_database()
    test_utilities()
    
    ; Print summary
    sistem 1, 1, "\n📊 Test Summary:\n", 18
    sistem 1, 1, "Tests run: ", 11
    print_number(g_tests_run)
    sistem 1, 1, "\nTests passed: ", 14
    print_number(g_tests_passed)
    sistem 1, 1, "\nTests failed: ", 14
    print_number(g_tests_run - g_tests_passed)
    sistem 1, 1, "\n", 1
    
    jika g_tests_passed == g_tests_run
        sistem 1, 1, "🎉 All tests passed!\n", 21
        kembali 0
    lain
        sistem 1, 1, "❌ Some tests failed!\n", 22
        kembali 1
    tutup_jika
tutup_fungsi

utama {
    kembali run_all_tests()
}
```

## 🚀 Production Deployment

### Build Script

```bash
#!/bin/bash
# build.sh - Production build script

echo "🏗️  Building MorphFox Application"
echo "================================"

# Clean previous build
rm -rf build/
mkdir -p build/

# Compile application
echo "Compiling main application..."
./bin/morph src/main.fox -o build/app

# Run tests
echo "Running test suite..."
./bin/morph tests/test_framework.fox

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "📦 Application ready: build/app"
else
    echo "❌ Build failed!"
    exit 1
fi

# Package for deployment
echo "Creating deployment package..."
tar -czf build/app-v1.0.0.tar.gz build/app

echo "🚀 Ready for deployment!"
```

### Performance Optimization

```morph
; performance/optimizer.fox - Performance optimization utilities

; Memory pool for frequent allocations
var g_small_object_pool = 0
var g_medium_object_pool = 0
var g_large_object_pool = 0

fungsi init_performance_pools() -> void
    ; Small objects (< 64 bytes)
    g_small_object_pool = __mf_arena_create(1024 * 1024)  ; 1MB
    
    ; Medium objects (64-1024 bytes)
    g_medium_object_pool = __mf_arena_create(4 * 1024 * 1024)  ; 4MB
    
    ; Large objects (> 1024 bytes)
    g_large_object_pool = __mf_arena_create(16 * 1024 * 1024)  ; 16MB
    
    sistem 1, 1, "✅ Performance pools initialized\n", 34
tutup_fungsi

fungsi optimized_alloc(size: i64) -> ptr
    jika size <= 64
        kembali __mf_arena_alloc(g_small_object_pool, size)
    lain jika size <= 1024
        kembali __mf_arena_alloc(g_medium_object_pool, size)
    lain
        kembali __mf_arena_alloc(g_large_object_pool, size)
    tutup_jika
tutup_fungsi

fungsi performance_reset() -> void
    __mf_arena_reset(g_small_object_pool)
    __mf_arena_reset(g_medium_object_pool)
    __mf_arena_reset(g_large_object_pool)
    sistem 1, 1, "🔄 Performance pools reset\n", 28
tutup_fungsi
```

## 📊 Monitoring and Metrics

```morph
; monitoring/metrics.fox - Application monitoring

var g_request_count = 0
var g_error_count = 0
var g_total_response_time = 0

fungsi metrics_record_request(response_time: i64) -> void
    g_request_count = g_request_count + 1
    g_total_response_time = g_total_response_time + response_time
tutup_fungsi

fungsi metrics_record_error() -> void
    g_error_count = g_error_count + 1
tutup_fungsi

fungsi metrics_report() -> void
    sistem 1, 1, "📊 Application Metrics:\n", 24
    sistem 1, 1, "Requests: ", 10
    print_number(g_request_count)
    sistem 1, 1, "\nErrors: ", 9
    print_number(g_error_count)
    
    jika g_request_count > 0
        var avg_response = g_total_response_time / g_request_count
        sistem 1, 1, "\nAvg Response Time: ", 19
        print_number(avg_response)
        sistem 1, 1, " ms", 3
    tutup_jika
    
    sistem 1, 1, "\n", 1
tutup_fungsi
```

## 🎮 Practice Projects

1. **REST API Server**: Build a complete REST API with CRUD operations
2. **Chat Server**: Real-time chat application with WebSocket support
3. **File Server**: HTTP file server with upload/download capabilities
4. **Database Engine**: Simple key-value database with persistence
5. **Game Server**: Multiplayer game server with real-time updates

## 📖 Production Checklist

- ✅ **Error Handling**: Comprehensive error handling and recovery
- ✅ **Logging**: Structured logging with different levels
- ✅ **Monitoring**: Metrics collection and health checks
- ✅ **Testing**: Unit tests, integration tests, load tests
- ✅ **Security**: Input validation, authentication, authorization
- ✅ **Performance**: Memory pools, connection pooling, caching
- ✅ **Deployment**: Build scripts, containerization, CI/CD
- ✅ **Documentation**: API docs, deployment guides, troubleshooting

## 🎉 Congratulations!

You've completed the MorphFox tutorial series! You now have the knowledge to:

- Build high-performance applications with MorphFox
- Leverage advanced memory management for optimal performance
- Use MorphRoutines for scalable concurrent programming
- Deploy production-ready applications with proper monitoring

## 🔗 Next Steps

- **Contribute**: Join the MorphFox community and contribute to the language
- **Optimize**: Profile and optimize your applications for maximum performance
- **Scale**: Deploy your applications at scale with load balancing
- **Innovate**: Build the next generation of high-performance applications

**Welcome to the MorphFox community!** 🦊🚀
