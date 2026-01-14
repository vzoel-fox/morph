# RPN Stack VM Executor - Morph Self-Hosting

## Overview

RPN Stack VM Executor adalah virtual machine yang mengeksekusi instruksi RPN dari file .morph yang telah dikompilasi. Ini memberikan **validation loop** yang essential untuk self-hosting compiler.

## 🏗️ Architecture

```
.morph File (Stripe-Protected)
         ↓
    File Loader + Unprotection
         ↓
    RPN Instructions Array
         ↓
    Stack VM Execution
         ↓
    Result Value
```

## 🔧 VM Structure (48 bytes)

```morph
VM State:
├── VM_STACK (0)              : Vector of stack values
├── VM_SYMBOLS (8)            : HashMap for variables
├── VM_PC (16)                : Program counter
├── VM_INSTRUCTIONS (24)      : RPN instruction array
├── VM_INSTRUCTION_COUNT (32) : Number of instructions
└── VM_RUNNING (40)           : Execution state flag
```

## 📚 Supported RPN Opcodes

### Data Operations
```morph
OP_LIT = 1     ; Push literal value to stack
OP_LOAD = 2    ; Load variable by hash
OP_STORE = 3   ; Store variable by hash
```

### Arithmetic Operations
```morph
OP_ADD = 10    ; Pop b,a -> Push (a + b)
OP_SUB = 11    ; Pop b,a -> Push (a - b)
OP_MUL = 12    ; Pop b,a -> Push (a * b)
OP_DIV = 13    ; Pop b,a -> Push (a / b)
```

### Stack Operations
```morph
OP_DUP = 4     ; Duplicate top of stack
OP_POP = 5     ; Discard top of stack
```

## 🔄 Execution Model

### Stack-Based Computation
```
Example: 5 + 3
Instructions: [LIT 5, LIT 3, ADD]

Step 1: LIT 5  -> Stack: [5]
Step 2: LIT 3  -> Stack: [5, 3]
Step 3: ADD    -> Stack: [8]
Result: 8
```

### Variable Storage
```
Example: var x = 42
Instructions: [LIT 42, STORE hash("x")]

Variables stored in HashMap with string hash as key
```

## 🔒 .morph File Format

### File Structure
```
.morph File:
├── Header: "MORPHFX1" (8 bytes)
├── Version: 1 (8 bytes)
├── Instruction Count (8 bytes)
└── Stripe-Protected Instructions
    ├── Encoded RPN instructions
    └── Protection header (16 bytes)
```

### Loading Process
1. **Header Verification**: Check "MORPHFX1" magic
2. **Version Check**: Ensure version compatibility
3. **Instruction Count**: Read number of RPN instructions
4. **Stripe Unprotection**: Decode protected instruction data
5. **VM Setup**: Load instructions into VM memory

## 🎯 API Functions

### VM Management
```morph
fungsi vm_new() -> ptr                    ; Create new VM
fungsi vm_load_morph_file(vm: ptr, filename: ptr) -> i64
fungsi vm_run(vm: ptr) -> i64             ; Execute until completion
fungsi vm_get_result(vm: ptr) -> i64      ; Get final result
```

### Stack Operations
```morph
fungsi vm_push(vm: ptr, value: i64) -> i64
fungsi vm_pop(vm: ptr) -> i64
fungsi vm_peek(vm: ptr) -> i64
```

### Execution Control
```morph
fungsi vm_execute_instruction(vm: ptr) -> i64
fungsi execute_morph_file(filename: ptr) -> i64  ; One-shot execution
```

### Debugging
```morph
fungsi vm_print_stack(vm: ptr) -> i64
fungsi vm_print_state(vm: ptr) -> i64
```

## 🧪 Testing & Validation

### Test Coverage
```bash
# Executor functionality tests
./bin/morph tests/test_executor.fox

# Complete pipeline test
./bin/morph src/main_complete_pipeline.fox
```

### Validation Examples
```morph
; Test 1: Simple arithmetic
AST: Binary(+, Literal(5), Literal(3))
RPN: [LIT 5, LIT 3, ADD]
Expected Result: 8

; Test 2: Multiplication  
AST: Binary(*, Literal(7), Literal(6))
RPN: [LIT 7, LIT 6, MUL]
Expected Result: 42

; Test 3: Division
AST: Binary(/, Literal(20), Literal(5))
RPN: [LIT 20, LIT 5, DIV]
Expected Result: 4
```

## 🚀 Self-Hosting Validation Loop

### Complete Pipeline
```
1. Source Code (.fox/.elsa)
2. Lexer + Parser → AST
3. AST → Intent Tree (SSA)
4. Intent Tree → RPN Instructions
5. RPN → Stripe-Protected .morph
6. VM Executor → Result Validation
```

### Validation Benefits
- **Immediate Feedback**: Know if generated code works
- **Correctness Verification**: Test compilation accuracy
- **Independence**: No dependency on bootstrap executor
- **Self-Hosting Foundation**: Compiler can execute its own output

## 📊 Performance Characteristics

### Execution Speed
- **Instruction Dispatch**: O(1) per instruction
- **Stack Operations**: O(1) push/pop
- **Variable Access**: O(1) average (HashMap)
- **Safety Checks**: Stack overflow/underflow protection

### Memory Usage
| Component | Size | Notes |
|-----------|------|-------|
| VM State | 48 bytes | Core VM structure |
| Stack Entry | 8 bytes | i64 values |
| Instruction | 16 bytes | Opcode + operand |
| Variable | 16 bytes | Hash + value |

### Safety Features
- **Stack Overflow Protection**: Max 1024 entries
- **Infinite Loop Prevention**: 10,000 cycle limit
- **Division by Zero**: Safe handling
- **File Validation**: Header and version checking

## 🔮 Future Enhancements

### Extended Instruction Set
1. **Control Flow**: JMP, JZ, JNZ for if/while
2. **Function Calls**: CALL, RET, FRAME
3. **Memory Operations**: ALLOC, FREE, MEMCPY
4. **I/O Operations**: PRINT, READ, WRITE

### Optimization Features
1. **JIT Compilation**: Hot path optimization
2. **Register Allocation**: Reduce stack operations
3. **Instruction Fusion**: Combine common patterns
4. **Garbage Collection**: Automatic memory management

### Debugging Support
1. **Breakpoints**: Execution pause points
2. **Step Debugging**: Single instruction execution
3. **Variable Inspection**: Runtime state examination
4. **Call Stack**: Function call tracing

## ✅ Status

**Implementation**: ✅ **COMPLETE**
- Stack VM with core opcodes working
- .morph file loading with stripe protection
- Complete validation loop functional
- Arithmetic operations tested and verified

**Validation Results**:
- ✅ 5 + 3 = 8 ✓
- ✅ 7 * 6 = 42 ✓  
- ✅ 10 - 4 = 6 ✓
- ✅ 20 / 5 = 4 ✓

**Next Steps**:
1. Add control flow opcodes (JMP, JZ, JNZ)
2. Implement function call support (CALL, RET)
3. Extend parser for complex constructs
4. Build complete self-hosting compiler

---

**Architecture**: Stack-based Virtual Machine
**Security**: Stripe-protected .morph execution
**Performance**: Linear execution with safety checks
**Status**: Foundation complete, validation loop working
