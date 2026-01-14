# Wrapper & Daemon Binaries Documentation

## 🔒 **SECURITY STRATEGY: WRAPPER ABSTRACTION**

**CRITICAL**: Wrapper builtins HARUS dipertahankan untuk:
1. **Memory Security**: Source code asli memory allocator tidak terlihat di userland
2. **Daemon Protection**: Cara kerja cleaner daemon tetap tersembunyi
3. **System Isolation**: User code tidak bisa akses direct ke low-level operations

## 🎯 **CRITICAL BINARIES TO MAINTAIN**

### **1. Memory Management Wrappers** 🔒
- **File**: `build/linux/alloc.o`, `build/linux/arena.o`, `build/linux/pool.o`
- **Purpose**: **ABSTRACTION LAYER** - Hide real memory implementation
- **Security**: User code hanya bisa akses via wrapper functions
- **Why Keep**: 
  - Source code asli memory allocator tidak exposed
  - Prevent direct syscall manipulation
  - Control memory access patterns
- **Functions**: 
  - `mem_alloc()` - **WRAPPER** untuk internal allocator
  - `mem_free()` - **WRAPPER** untuk internal deallocator
  - Arena & pool - **HIDDEN** implementation details

### **2. Daemon Cleaner** 🔒
- **File**: `corelib/platform/x86_64/asm/daemon_cleaner.s`
- **Binary**: `morph_daemon` (compiled binary only)
- **Security**: **SOURCE CODE TIDAK DIDISTRIBUSI**
- **Why Keep**: 
  - Cara kerja cleanup algorithm tersembunyi
  - TTL logic tidak terlihat user
  - Memory monitoring strategy protected
  - Prevents reverse engineering cleanup patterns

### **3. System Call Wrappers** 🔒
- **Files**: `build/linux/builtins.o`, `build/linux/runtime.o`
- **Purpose**: **SYSCALL ABSTRACTION** - Hide direct kernel access
- **Security**: User tidak bisa bypass wrapper layer
- **Functions**:
  - `__sys_write()` - **CONTROLLED** write access
  - `__sys_read()` - **FILTERED** read access  
  - `__sys_exit()` - **MONITORED** exit handling
  - `__mf_print_int()` - **SAFE** output utilities

### **4. Scheduler & Context Switching** 🔒
- **Files**: `build/linux/scheduler.o`, `build/linux/context.o`
- **Purpose**: **CONCURRENCY ABSTRACTION** - Hide threading internals
- **Security**: Context switching logic tidak exposed
- **Functions**:
  - `scheduler_spawn()` - **WRAPPER** untuk thread creation
  - `scheduler_yield()` - **CONTROLLED** context switching
  - `morph_switch_context()` - **HIDDEN** low-level implementation

## 🔧 **DEPLOYMENT STRATEGY**

### **Phase 1: Preserve Security Wrappers** 🔒
```bash
# CRITICAL: Keep wrapper binaries - NEVER distribute source
cp build/linux/alloc.o /usr/local/lib/morph/
cp build/linux/runtime.o /usr/local/lib/morph/
cp build/linux/scheduler.o /usr/local/lib/morph/
cp build/linux/builtins.o /usr/local/lib/morph/

# Hide source code - only distribute compiled objects
rm -rf corelib/platform/x86_64/asm/  # Remove from distribution
```

### **Phase 2: Build Protected Daemon** 🔒
```bash
# Build daemon - distribute binary only
as --64 corelib/platform/x86_64/asm/daemon_cleaner.s -o daemon_cleaner.o
as --64 corelib/platform/x86_64/asm/morph_daemon_main.s -o daemon_main.o
ld daemon_main.o daemon_cleaner.o -o morph_daemon

# SECURITY: Remove source after build
rm daemon_cleaner.o daemon_main.o
# Only distribute: morph_daemon (binary)
```

### **Phase 3: Self-hosting with Abstraction** 🔒
- Self-hosting compiler **HANYA** akses via wrapper functions
- **TIDAK ADA** direct syscall access dari user code
- Daemon berjalan sebagai **BLACK BOX** system service
- Memory implementation **TERSEMBUNYI** dari userland

## 📋 **SECURITY CHECKLIST**

### **Before Distribution:**
- [ ] Remove all assembly source files dari package
- [ ] Verify hanya compiled objects yang included
- [ ] Test wrapper functions work tanpa source
- [ ] Confirm daemon binary standalone
- [ ] Check tidak ada debug symbols exposed

### **Runtime Security:**
- [ ] User code tidak bisa bypass wrappers
- [ ] Memory allocator implementation hidden
- [ ] Daemon logs tidak expose internal logic
- [ ] Syscall access controlled via wrappers only

## 🚨 **SECURITY PRINCIPLES**

1. **Wrapper Abstraction**: User tidak pernah lihat real implementation
2. **Binary Distribution**: Hanya compiled objects, bukan source
3. **Black Box Daemon**: Cara kerja cleanup algorithm tersembunyi
4. **Controlled Access**: Semua system operations via wrapper layer

## 🎯 **ROLLBACK PROCEDURE** 🔒

Jika self-hosting gagal:
```bash
# 1. Restore bootstrap (wrapper-compatible)
cp morph_v1.2_backup bin/morph

# 2. Restore wrapper objects (PROTECTED)
cp /usr/local/lib/morph/*.o build/linux/

# 3. Restart daemon (BLACK BOX)
./morph_daemon restart

# 4. Test - user masih tidak bisa lihat internals
./bin/morph test_input.fox
```

**Security Guarantee**: Wrapper layer memastikan source code asli tidak pernah exposed ke userland, bahkan saat rollback.
