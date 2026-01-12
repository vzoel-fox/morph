; ==============================================================================
; ARENA & POOL ALLOCATORS (SSOT v1.2 Compliant)
; ==============================================================================

.include "bootstrap/asm/macros.inc"

.section .text

; ==============================================================================
; Arena Allocator (SSOT Compliant)
; ==============================================================================

.global __mf_arena_create
__mf_arena_create:
    ; Input: %rdi = size
    ; Output: %rax = arena pointer (32-byte header + user area)
    
    ; Validate size
    testq %rdi, %rdi
    jle .arena_create_fail
    
    ; Add header size
    addq $32, %rdi
    
    ; Allocate memory
    call __mf_mem_alloc
    testq %rax, %rax
    jz .arena_create_fail
    
    movq %rax, %r8      ; Arena base
    
    ; Initialize header (SSOT layout)
    leaq 32(%r8), %rcx  ; Start = base + 32
    movq %rcx, 0(%r8)   ; [0x00] Start Ptr
    movq %rcx, 8(%r8)   ; [0x08] Current Ptr = Start
    
    ; Calculate end
    movq %rdi, %rdx
    addq %r8, %rdx      ; End = base + total_size
    movq %rdx, 16(%r8)  ; [0x10] End Ptr
    
    movq $0, 24(%r8)    ; [0x18] ID = 0
    
    movq %r8, %rax      ; Return arena pointer
    ret

.arena_create_fail:
    xorq %rax, %rax
    ret

.global __mf_arena_alloc
__mf_arena_alloc:
    ; Input: %rdi = arena, %rsi = size
    ; Output: %rax = allocated pointer
    
    ; Validate arena
    testq %rdi, %rdi
    jz .arena_alloc_fail
    
    ; Validate size
    testq %rsi, %rsi
    jle .arena_alloc_fail
    
    ; Align size to 8 bytes
    addq $7, %rsi
    andq $-8, %rsi
    
    ; Get current and end pointers
    movq 8(%rdi), %rax  ; Current
    movq 16(%rdi), %rcx ; End
    
    ; Check if allocation fits
    movq %rax, %rdx
    addq %rsi, %rdx     ; New current
    
    cmpq %rcx, %rdx
    jg .arena_alloc_fail
    
    ; Update current pointer
    movq %rdx, 8(%rdi)
    
    ; Return old current (allocated block)
    ret

.arena_alloc_fail:
    xorq %rax, %rax
    ret

.global __mf_arena_reset
__mf_arena_reset:
    ; Input: %rdi = arena
    
    testq %rdi, %rdi
    jz .arena_reset_done
    
    ; Reset current = start
    movq 0(%rdi), %rax  ; Start
    movq %rax, 8(%rdi)  ; Current = Start
    
.arena_reset_done:
    ret

.global __mf_arena_usage
__mf_arena_usage:
    ; Input: %rdi = arena
    ; Output: %rax = bytes used
    
    testq %rdi, %rdi
    jz .arena_usage_zero
    
    movq 8(%rdi), %rax  ; Current
    subq 0(%rdi), %rax  ; Current - Start
    ret

.arena_usage_zero:
    xorq %rax, %rax
    ret

.global __mf_arena_capacity
__mf_arena_capacity:
    ; Input: %rdi = arena
    ; Output: %rax = total capacity
    
    testq %rdi, %rdi
    jz .arena_capacity_zero
    
    movq 16(%rdi), %rax ; End
    subq 0(%rdi), %rax  ; End - Start
    ret

.arena_capacity_zero:
    xorq %rax, %rax
    ret

; ==============================================================================
; Pool Allocator (SSOT Compliant)
; ==============================================================================

.global __mf_pool_create
__mf_pool_create:
    ; Input: %rdi = obj_size, %rsi = capacity
    ; Output: %rax = pool pointer
    
    ; Validate obj_size >= 8 (for free list pointer)
    cmpq $8, %rdi
    jl .pool_create_fail
    
    ; Validate capacity
    testq %rsi, %rsi
    jle .pool_create_fail
    
    ; Calculate total size: header(48) + obj_size * capacity
    movq %rdi, %rax
    mulq %rsi           ; obj_size * capacity
    jc .pool_create_fail ; Overflow check
    
    addq $48, %rax      ; Add header size
    jc .pool_create_fail
    
    pushq %rdi          ; Save obj_size
    pushq %rsi          ; Save capacity
    
    movq %rax, %rdi
    call __mf_mem_alloc
    
    popq %rsi           ; Restore capacity
    popq %rdi           ; Restore obj_size
    
    testq %rax, %rax
    jz .pool_create_fail
    
    movq %rax, %r8      ; Pool base
    
    ; Initialize header (SSOT layout - 48 bytes)
    leaq 48(%r8), %rcx  ; Start = base + 48
    movq %rcx, 0(%r8)   ; [0x00] Start Ptr
    movq %rcx, 8(%r8)   ; [0x08] Current Ptr = Start
    
    ; Calculate end
    movq %rdi, %rax
    mulq %rsi           ; obj_size * capacity
    addq %rcx, %rax     ; Start + (obj_size * capacity)
    movq %rax, 16(%r8)  ; [0x10] End Ptr
    
    movq %rdi, 24(%r8)  ; [0x18] Object Size
    movq $0, 32(%r8)    ; [0x20] Free List Head = NULL
    movq $0, 40(%r8)    ; [0x28] Padding
    
    movq %r8, %rax      ; Return pool pointer
    ret

.pool_create_fail:
    xorq %rax, %rax
    ret

.global __mf_pool_alloc
__mf_pool_alloc:
    ; Input: %rdi = pool
    ; Output: %rax = allocated object
    
    testq %rdi, %rdi
    jz .pool_alloc_fail
    
    ; Check free list first
    movq 32(%rdi), %rax ; Free List Head
    testq %rax, %rax
    jnz .pool_alloc_from_free
    
    ; Allocate from bump pointer
    movq 8(%rdi), %rax  ; Current
    movq 16(%rdi), %rcx ; End
    movq 24(%rdi), %rdx ; Object Size
    
    ; Check if object fits
    movq %rax, %r8
    addq %rdx, %r8      ; New current
    
    cmpq %rcx, %r8
    jg .pool_alloc_fail
    
    ; Update current pointer
    movq %r8, 8(%rdi)
    
    ; Zero the object
    pushq %rdi
    pushq %rax
    movq %rax, %rdi     ; Dest
    movq %rdx, %rcx     ; Count
    call zero_memory
    popq %rax
    popq %rdi
    
    ret

.pool_alloc_from_free:
    ; Remove from free list (LIFO)
    movq (%rax), %rcx   ; Next free object
    movq %rcx, 32(%rdi) ; Update free list head
    
    ; Zero the object
    pushq %rdi
    pushq %rax
    movq %rax, %rdi     ; Dest
    movq 24(%rdi), %rcx ; Object size (from original %rdi)
    call zero_memory
    popq %rax
    popq %rdi
    
    ret

.pool_alloc_fail:
    xorq %rax, %rax
    ret

.global __mf_pool_free
__mf_pool_free:
    ; Input: %rdi = pool, %rsi = object
    
    testq %rdi, %rdi
    jz .pool_free_done
    
    testq %rsi, %rsi
    jz .pool_free_done
    
    ; Add to free list (LIFO)
    movq 32(%rdi), %rax ; Current free list head
    movq %rax, (%rsi)   ; obj->next = old_head
    movq %rsi, 32(%rdi) ; free_head = obj
    
.pool_free_done:
    ret

; Helper function (shared)
zero_memory:
    ; Input: %rdi = start, %rcx = count
    xorq %rax, %rax
.zero_loop_pool:
    testq %rcx, %rcx
    jz .zero_done_pool
    movb %al, (%rdi)
    incq %rdi
    decq %rcx
    jmp .zero_loop_pool
.zero_done_pool:
    ret
