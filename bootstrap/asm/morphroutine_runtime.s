; ==============================================================================
; MORPHROUTINE RUNTIME IMPLEMENTATION (x86_64 Assembly)
; ==============================================================================

.include "bootstrap/asm/macros.inc"

.section .data
    current_routine: .quad 0        ; Current running routine
    routine_queue: .quad 0          ; Ready queue head
    next_routine_id: .quad 1        ; Next routine ID

.section .text

; ==============================================================================
; MorphRoutine Management
; ==============================================================================

.global __mf_mr_create
__mf_mr_create:
    ; Input: %rdi = func_ptr, %rsi = stack_size
    ; Output: %rax = routine pointer (or 0 if failed)
    pushq %rbp
    movq %rsp, %rbp
    pushq %r12          ; func_ptr
    pushq %r13          ; stack_size
    
    movq %rdi, %r12
    movq %rsi, %r13
    
    ; Allocate routine state (64 bytes)
    movq $64, %rdi
    call __mf_mem_alloc
    testq %rax, %rax
    jz .create_fail
    
    movq %rax, %r14     ; routine state
    
    ; Allocate stack
    movq %r13, %rdi
    call __mf_mem_alloc
    testq %rax, %rax
    jz .create_fail
    
    ; Initialize routine state
    movq %rax, 24(%r14)         ; MR_STATE_STACK = stack_base
    movq %r13, 32(%r14)         ; MR_STATE_STACK_SIZE
    addq %r13, %rax
    movq %rax, 0(%r14)          ; MR_STATE_SP = stack_top
    movq $0, 8(%r14)            ; MR_STATE_STATUS = MR_READY
    
    ; Set routine ID
    movq next_routine_id(%rip), %rax
    movq %rax, 16(%r14)         ; MR_STATE_ID
    incq next_routine_id(%rip)
    
    ; Setup initial stack frame for function call
    movq 0(%r14), %rax          ; Get stack pointer
    subq $8, %rax               ; Make room for return address
    movq %r12, (%rax)           ; Store function pointer
    movq %rax, 0(%r14)          ; Update stack pointer
    
    movq %r14, %rax             ; Return routine pointer
    
    popq %r13
    popq %r12
    leave
    ret

.create_fail:
    xorq %rax, %rax
    popq %r13
    popq %r12
    leave
    ret

.global __mf_mr_yield
__mf_mr_yield:
    ; Input: %rdi = value
    ; Output: %rax = resumed value
    pushq %rbp
    movq %rsp, %rbp
    
    ; Save current routine context
    movq current_routine(%rip), %rax
    testq %rax, %rax
    jz .yield_fail
    
    ; Save stack pointer
    movq %rsp, 0(%rax)          ; MR_STATE_SP
    movq %rdi, 40(%rax)         ; MR_STATE_YIELD_VAL
    movq $2, 8(%rax)            ; MR_STATE_STATUS = MR_BLOCKED
    
    ; Schedule next routine
    call __mf_mr_schedule
    
    ; When resumed, return value is in 40(%rax)
    movq current_routine(%rip), %rax
    movq 40(%rax), %rax
    
    leave
    ret

.yield_fail:
    movq $-1, %rax
    leave
    ret

.global __mf_mr_resume
__mf_mr_resume:
    ; Input: %rdi = routine pointer
    ; Output: %rax = yielded value
    pushq %rbp
    movq %rsp, %rbp
    
    ; Check routine status
    cmpq $2, 8(%rdi)            ; MR_BLOCKED?
    jne .resume_fail
    
    ; Set as current routine
    movq %rdi, current_routine(%rip)
    movq $1, 8(%rdi)            ; MR_STATE_STATUS = MR_RUNNING
    
    ; Restore stack pointer and jump
    movq 0(%rdi), %rsp          ; MR_STATE_SP
    
    ; Return yielded value
    movq 40(%rdi), %rax         ; MR_STATE_YIELD_VAL
    
    leave
    ret

.resume_fail:
    movq $-1, %rax
    leave
    ret

.global __mf_mr_current
__mf_mr_current:
    ; Output: %rax = current routine pointer
    movq current_routine(%rip), %rax
    ret

.global __mf_mr_schedule
__mf_mr_schedule:
    ; Simple round-robin scheduler
    ; TODO: Implement proper ready queue
    ret

.global __mf_mr_destroy
__mf_mr_destroy:
    ; Input: %rdi = routine pointer
    pushq %rbp
    movq %rsp, %rbp
    
    ; Free stack
    movq 24(%rdi), %rax         ; MR_STATE_STACK
    testq %rax, %rax
    jz .skip_stack_free
    
    pushq %rdi
    movq %rax, %rdi
    movq 32(%rdi), %rsi         ; MR_STATE_STACK_SIZE
    call __mf_mem_free
    popq %rdi

.skip_stack_free:
    ; Free routine state
    movq $64, %rsi
    call __mf_mem_free
    
    leave
    ret
