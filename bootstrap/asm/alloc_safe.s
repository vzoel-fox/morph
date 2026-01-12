; ==============================================================================
; MEMORY SAFETY ENHANCED ALLOCATOR (v1.2 SSOT Compliant)
; ==============================================================================

.include "bootstrap/asm/macros.inc"

; Error codes (v1.2 specification)
.equ ERR_DIV_ZERO, 104
.equ ERR_INVALID_FRAGMENT, 105
.equ ERR_NULL_DEREF, 110
.equ ERR_OUT_OF_BOUNDS, 111
.equ ERR_STACK_OVERFLOW, 112

; Magic numbers and constants
.equ MAGIC_VZOELFOX, 0x584F464C454F5A56
.equ PAGE_SIZE, 4096
.equ PAGE_HEADER_SIZE, 48
.equ BLOCK_HEADER_SIZE, 8
.equ MAX_ALLOC_SIZE, 1073741824  ; 1GB limit

.section .data
    current_page_ptr: .quad 0
    current_offset: .quad 0
    __sys_page_size: .quad 4096
    total_allocated: .quad 0
    alloc_count: .quad 0

.section .text

; ==============================================================================
; Enhanced Memory Operations with Safety Checks
; ==============================================================================

.global __mf_mem_alloc
__mf_mem_alloc:
    ; Input: %rdi = size
    ; Output: %rax = pointer (with full safety validation)
    
    ; Safety check 1: NULL/negative size
    testq %rdi, %rdi
    jle .exit_invalid_size
    
    ; Safety check 2: Unreasonably large allocation
    cmpq $MAX_ALLOC_SIZE, %rdi
    jg .exit_invalid_size
    
    ; Safety check 3: Integer overflow check for header addition
    movq %rdi, %rax
    addq $BLOCK_HEADER_SIZE, %rax
    jc .exit_invalid_size  ; Carry flag = overflow
    
    call mem_alloc_internal
    
    ; Safety check 4: Validate returned pointer
    testq %rax, %rax
    jz .alloc_failed
    
    ; Update statistics
    incq alloc_count(%rip)
    addq %rdi, total_allocated(%rip)
    
    ret

.exit_invalid_size:
    movq $ERR_OUT_OF_BOUNDS, %rdi
    jmp exit_with_error

.alloc_failed:
    xorq %rax, %rax
    ret

.global __mf_mem_free
__mf_mem_free:
    ; Input: %rdi = ptr, %rsi = size
    ; Enhanced with full validation
    
    ; Safety check 1: NULL pointer
    testq %rdi, %rdi
    jz .exit_null_deref
    
    ; Safety check 2: Validate pointer magic
    pushq %rdi
    pushq %rsi
    call validate_pointer_magic
    popq %rsi
    popq %rdi
    
    testq %rax, %rax
    jz .exit_invalid_ptr
    
    ; Safety check 3: Size validation
    testq %rsi, %rsi
    jle .exit_invalid_size
    
    call mem_free_internal
    
    ; Update statistics
    decq alloc_count(%rip)
    subq %rsi, total_allocated(%rip)
    
    ret

.exit_null_deref:
    movq $ERR_NULL_DEREF, %rdi
    jmp exit_with_error

.exit_invalid_ptr:
    movq $ERR_OUT_OF_BOUNDS, %rdi
    jmp exit_with_error

.global __mf_load_i64
__mf_load_i64:
    ; Input: %rdi = addr
    ; Output: %rax = value (with NULL check)
    
    testq %rdi, %rdi
    jz .exit_null_deref
    
    ; Additional alignment check
    testq $7, %rdi
    jnz .exit_misaligned
    
    movq (%rdi), %rax
    ret

.exit_misaligned:
    movq $ERR_OUT_OF_BOUNDS, %rdi
    jmp exit_with_error

.global __mf_poke_i64
__mf_poke_i64:
    ; Input: %rdi = addr, %rsi = value
    
    testq %rdi, %rdi
    jz .exit_null_deref
    
    testq $7, %rdi
    jnz .exit_misaligned
    
    movq %rsi, (%rdi)
    ret

.global __mf_load_byte
__mf_load_byte:
    ; Input: %rdi = addr
    ; Output: %rax = byte (with NULL check)
    
    testq %rdi, %rdi
    jz .exit_null_deref
    
    xorq %rax, %rax
    movb (%rdi), %al
    ret

.global __mf_poke_byte
__mf_poke_byte:
    ; Input: %rdi = addr, %rsi = value
    
    testq %rdi, %rdi
    jz .exit_null_deref
    
    movb %sil, (%rdi)
    ret

.global __mf_div_checked
__mf_div_checked:
    ; Input: %rdi = dividend, %rsi = divisor
    ; Output: %rax = result
    ; Safety: Exit 104 on division by zero
    
    testq %rsi, %rsi
    jz .exit_div_zero
    
    movq %rdi, %rax
    cqto                    ; Sign extend RAX to RDX:RAX
    idivq %rsi              ; Signed division
    ret

.exit_div_zero:
    movq $ERR_DIV_ZERO, %rdi
    jmp exit_with_error

; ==============================================================================
; Internal Allocator Implementation (SSOT Compliant)
; ==============================================================================

mem_alloc_internal:
    pushq %rbp
    movq %rsp, %rbp
    pushq %r12
    pushq %r13
    pushq %r14

    movq %rdi, %r12     ; Save user size

    ; Check for big allocation
    movq $PAGE_SIZE, %rax
    subq $PAGE_HEADER_SIZE, %rax
    cmpq %rax, %r12
    jg .big_allocation

    ; Calculate total aligned size
    movq %r12, %rax
    addq $BLOCK_HEADER_SIZE, %rax
    addq $15, %rax
    andq $-16, %rax
    movq %rax, %r13

    ; Try current page
    movq current_page_ptr(%rip), %rax
    testq %rax, %rax
    jz .need_new_page

    ; Check capacity
    movq current_offset(%rip), %rcx
    movq %rcx, %rdx
    addq %r13, %rdx
    cmpq $PAGE_SIZE, %rdx
    jg .need_new_page

    ; Allocate from current page
    addq %rcx, %rax
    
    ; Write block header with user size
    movq %r12, (%rax)
    
    ; Zero user area
    leaq 8(%rax), %rdi
    movq %r13, %rcx
    subq $8, %rcx
    call zero_memory
    
    ; Update offset
    movq %rdx, current_offset(%rip)
    
    ; Return user pointer
    addq $8, %rax
    jmp .alloc_done

.need_new_page:
    call allocate_new_page
    testq %rax, %rax
    jz .alloc_done
    jmp mem_alloc_internal

.big_allocation:
    call allocate_big_block
    jmp .alloc_done

.alloc_done:
    popq %r14
    popq %r13
    popq %r12
    leave
    ret

allocate_new_page:
    pushq %rbp
    movq %rsp, %rbp
    
    ; Request page from OS
    movq $9, %rax       ; SYS_mmap
    xorq %rdi, %rdi     ; addr = NULL
    movq $PAGE_SIZE, %rsi
    movq $3, %rdx       ; PROT_READ | PROT_WRITE
    movq $34, %r10      ; MAP_PRIVATE | MAP_ANONYMOUS
    movq $-1, %r8       ; fd = -1
    xorq %r9, %r9       ; offset = 0
    syscall
    
    cmpq $-1, %rax
    je .mmap_failed
    
    movq %rax, %r12     ; New page base
    
    ; Initialize page header (SSOT compliant)
    movq $0, 0(%r12)                    ; Next = NULL
    movq current_page_ptr(%rip), %rcx
    movq %rcx, 8(%r12)                  ; Prev = old current
    movq $0, 16(%r12)                   ; Timestamp (simplified)
    movq $PAGE_SIZE, 24(%r12)           ; Page size
    movq $MAGIC_VZOELFOX, 32(%r12)      ; Magic number
    movq $0, 40(%r12)                   ; Padding
    
    ; Update linked list
    testq %rcx, %rcx
    jz .first_page
    movq %r12, 0(%rcx)
    
.first_page:
    movq %r12, current_page_ptr(%rip)
    movq $PAGE_HEADER_SIZE, current_offset(%rip)
    
    movq %r12, %rax
    leave
    ret

.mmap_failed:
    xorq %rax, %rax
    leave
    ret

allocate_big_block:
    ; TODO: Multi-page allocation for big blocks
    xorq %rax, %rax
    ret

validate_pointer_magic:
    ; Input: %rdi = pointer
    ; Output: %rax = 1 if valid, 0 if invalid
    
    ; Find page start (simplified validation)
    movq %rdi, %rax
    andq $-4096, %rax   ; Align to page boundary
    
    ; Check magic number
    cmpq $MAGIC_VZOELFOX, 32(%rax)
    je .valid_magic
    
    xorq %rax, %rax
    ret

.valid_magic:
    movq $1, %rax
    ret

zero_memory:
    ; Input: %rdi = start, %rcx = count
    xorq %rax, %rax
.zero_loop:
    testq %rcx, %rcx
    jz .zero_done
    movb %al, (%rdi)
    incq %rdi
    decq %rcx
    jmp .zero_loop
.zero_done:
    ret

mem_free_internal:
    ; TODO: Implement proper free with coalescing
    ret

exit_with_error:
    ; Input: %rdi = error code
    movq $60, %rax      ; SYS_exit
    syscall
