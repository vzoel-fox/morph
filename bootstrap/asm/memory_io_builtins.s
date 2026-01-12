; ==============================================================================
; MEMORY BUILTINS IMPLEMENTATION (x86_64 Assembly)
; ==============================================================================

.include "bootstrap/asm/macros.inc"

.section .text

; ==============================================================================
; Memory Operations
; ==============================================================================

.global __mf_mem_alloc
__mf_mem_alloc:
    ; Input: %rdi = size
    ; Output: %rax = pointer (or 0 if failed)
    call mem_alloc
    ret

.global __mf_mem_free  
__mf_mem_free:
    ; Input: %rdi = ptr, %rsi = size
    call mem_free
    ret

.global __mf_load_i64
__mf_load_i64:
    ; Input: %rdi = addr
    ; Output: %rax = value
    movq (%rdi), %rax
    ret

.global __mf_poke_i64
__mf_poke_i64:
    ; Input: %rdi = addr, %rsi = value
    movq %rsi, (%rdi)
    ret

.global __mf_load_byte
__mf_load_byte:
    ; Input: %rdi = addr
    ; Output: %rax = byte (zero-extended)
    xorq %rax, %rax
    movb (%rdi), %al
    ret

.global __mf_poke_byte
__mf_poke_byte:
    ; Input: %rdi = addr, %rsi = value
    movb %sil, (%rdi)
    ret

; ==============================================================================
; I/O Operations (Linux syscalls)
; ==============================================================================

.global __mf_io_read
__mf_io_read:
    ; Input: %rdi = fd, %rsi = buf, %rdx = count
    ; Output: %rax = bytes read (or -errno)
    movq $0, %rax       ; SYS_read
    syscall
    ret

.global __mf_io_write
__mf_io_write:
    ; Input: %rdi = fd, %rsi = buf, %rdx = count
    ; Output: %rax = bytes written (or -errno)
    movq $1, %rax       ; SYS_write
    syscall
    ret

.global __mf_io_open
__mf_io_open:
    ; Input: %rdi = path, %rsi = flags
    ; Output: %rax = fd (or -errno)
    movq $2, %rax       ; SYS_open
    movq $0644, %rdx    ; mode
    syscall
    ret

.global __mf_io_close
__mf_io_close:
    ; Input: %rdi = fd
    ; Output: %rax = 0 (or -errno)
    movq $3, %rax       ; SYS_close
    syscall
    ret

; ==============================================================================
; Timer Operations
; ==============================================================================

.global __mf_timer_now
__mf_timer_now:
    ; Output: %rax = timestamp (nanoseconds)
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp      ; timespec struct
    
    movq $228, %rax     ; SYS_clock_gettime
    movq $1, %rdi       ; CLOCK_MONOTONIC
    leaq -16(%rbp), %rsi
    syscall
    
    ; Convert to nanoseconds: sec * 1e9 + nsec
    movq -16(%rbp), %rax    ; seconds
    movq $1000000000, %rcx
    mulq %rcx               ; rax = sec * 1e9
    addq -8(%rbp), %rax     ; add nanoseconds
    
    leave
    ret

.global __mf_timer_sleep
__mf_timer_sleep:
    ; Input: %rdi = milliseconds
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp      ; timespec struct
    
    ; Convert ms to sec/nsec
    movq %rdi, %rax
    movq $1000, %rcx
    xorq %rdx, %rdx
    divq %rcx           ; rax = sec, rdx = remaining ms
    
    movq %rax, -16(%rbp)    ; tv_sec
    movq %rdx, %rax
    movq $1000000, %rcx
    mulq %rcx               ; convert remaining ms to ns
    movq %rax, -8(%rbp)     ; tv_nsec
    
    movq $35, %rax      ; SYS_nanosleep
    leaq -16(%rbp), %rdi
    xorq %rsi, %rsi     ; remaining = NULL
    syscall
    
    leave
    ret
