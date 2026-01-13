# Self-Hosting Roadmap

## Vision

Transform MorphFox from Assembly-bootstrapped language to fully self-hosting compiler where the compiler is written in MorphFox itself.

## Milestones

### Milestone 0: Enhanced Memory Safety & Exception Handling ✅ COMPLETED

**Goal**: Establish robust foundation with memory safety and exception handling

**Status**: COMPLETED
**Priority**: CRITICAL (Foundation for all development)
**Effort**: 1 week

#### Achievements:

**0.1 Memory Safety System** ✅
- Allocation tracking with metadata
- Bounds checking for all memory access
- NULL pointer protection
- Double-free detection
- Memory leak detection and reporting
- Source location tracking for debugging

**0.2 Exception Handling Framework** ✅
- Exception types and error codes
- Context-aware error reporting
- Exception state management
- Safe error propagation
- Debug location tracking

**0.3 Safe API Layer** ✅
- `mem_alloc()` / `mem_free()` with tracking
- `mem_load()` / `mem_store()` with bounds checking
- `add_safe()` / `div_safe()` with overflow protection
- `exception_throw()` / `exception_clear()` for error handling

**0.4 Comprehensive Testing** ✅
- Memory safety test suite
- Exception handling validation
- Leak detection verification
- Performance impact assessment

**Success Criteria**: ✅ ALL COMPLETED
- [x] All memory operations are bounds-checked
- [x] Exception system handles all error types
- [x] Memory leaks are automatically detected
- [x] Test suite passes with 100% success rate
- [x] Documentation complete and comprehensive

---

### Milestone 1: Enhanced Standard Library (Phase 2 Prep) ✅ COMPLETED

**Goal**: Expand standard library to support compiler implementation needs

**Status**: COMPLETED
**Priority**: HIGH (Blocker for Phase 2)
**Completed**: 2026-01-13

#### Achievements:

**1.1 String Operations** ✅ COMPLETED
- `string_length()`, `string_equals()`, `string_copy()`
- `string_concat()`, `string_substring()`, `string_find_char()`
- `i64_to_string()`, `string_to_i64()`
- Full implementation in `corelib/lib/string.fox`

**1.2 Dynamic Array/Vector** ✅ COMPLETED
- `Vector` structure with buffer, length, capacity
- `vector_new()`, `vector_push()`, `vector_get()`, `vector_set()`
- `vector_length()`, `vector_free()`
- Automatic resizing with 2x growth factor
- Full implementation in `corelib/lib/vector.fox`

**1.3 HashMap/Dictionary** ✅ COMPLETED
- `HashMap` structure with chaining collision resolution
- `hashmap_new()`, `hashmap_insert()`, `hashmap_get()`
- `hashmap_has()`, `hashmap_free()`
- DJB2 hash function for string keys
- Full implementation in `corelib/lib/hashmap.fox`

**1.4 Integration** ✅ COMPLETED
- Updated `std.fox` to include all new components
- Version bumped to v2.0.0 (20000)
- All components use memory safety API
- Documentation in `docs/STDLIB_V2.md`

**Success Criteria**: ✅ ALL COMPLETED
- [x] All string, vector, hashmap APIs implemented
- [x] Memory safety integration complete
- [x] Documentation complete
- [x] Ready for compiler implementation

---

### Milestone 1.5: Type Checker Implementation ✅ COMPLETED

**Goal**: Implement static type checking for MorphFox AST

**Status**: COMPLETED
**Priority**: HIGH (Foundation for self-hosting)
**Completed**: 2026-01-13

#### Achievements:

**1.5.1 Type System** ✅ COMPLETED
- Core types: `void`, `i64`, `ptr`, `String`, `function`
- Type constants and error handling
- Type inference for literals and expressions

**1.5.2 Symbol Table** ✅ COMPLETED
- HashMap-based symbol storage
- Scoped symbol resolution
- Built-in function registration

**1.5.3 Type Checking Rules** ✅ COMPLETED
- Variable declaration and usage validation
- Binary operation type compatibility
- Assignment type matching
- Function type checking

**1.5.4 Error Reporting** ✅ COMPLETED
- Descriptive error messages
- Error collection and reporting
- Integration with compiler pipeline

**Success Criteria**: ✅ ALL COMPLETED
- [x] Type checker validates MorphFox programs
- [x] Symbol table tracks variables and functions
- [x] Error reporting provides clear messages
- [x] Test suite covers all type checking scenarios
- [x] Documentation complete

---

### Milestone 2: Lexer Implementation (Phase 2 Start)

**Goal**: Write tokenizer in MorphFox

**Status**: Not Started
**Priority**: HIGH
**Estimated Effort**: 1-2 weeks

#### Tasks:

**2.1 Token Definition**
```morph
# src/token.fox
struktur Token {
    type: i64,      # TOKEN_INT, TOKEN_STRING, etc
    value: ptr,     # Lexeme
    line: i64,      # Line number
    column: i64     # Column number
}

# Token types (constants)
var TOKEN_INT = 1
var TOKEN_STRING = 2
var TOKEN_FUNGSI = 3
var TOKEN_VAR = 4
# ... etc
```

**2.2 Lexer State Machine**
```morph
# src/lexer.fox
struktur Lexer {
    source: ptr,
    position: i64,
    line: i64,
    column: i64
}

fungsi lexer_new(source: ptr) -> ptr
fungsi lexer_next_token(l: ptr) -> ptr  # Returns Token
fungsi lexer_peek_char(l: ptr) -> i64
fungsi lexer_advance(l: ptr) -> void
```

**2.3 Token Recognition**
- [ ] Recognize keywords (fungsi, var, jika, etc)
- [ ] Recognize identifiers
- [ ] Recognize literals (integers, strings)
- [ ] Recognize operators (+, -, *, /, ==, etc)
- [ ] Recognize delimiters ({, }, (, ), etc)
- [ ] Handle comments (; ... )
- [ ] Handle whitespace
- [ ] Track line/column for error reporting

**Success Criteria**:
- [ ] Lexer can tokenize valid MorphFox programs
- [ ] Test suite passes (compare with bootstrap lexer output)
- [ ] Error reporting for invalid tokens

---

### Milestone 3: Parser Implementation

**Goal**: Write parser in MorphFox

**Status**: Not Started
**Priority**: HIGH
**Estimated Effort**: 2-3 weeks

#### Tasks:

**3.1 AST Definition**
```morph
# src/ast.fox
struktur ASTNode {
    type: i64,      # NODE_FUNCTION, NODE_VAR, etc
    children: ptr,  # Vector of child nodes
    token: ptr,     # Token
    data: i64       # Type-specific data
}
```

**3.2 Recursive Descent Parser**
```morph
# src/parser.fox
struktur Parser {
    lexer: ptr,
    current_token: ptr,
    errors: ptr     # Vector of errors
}

fungsi parser_new(lexer: ptr) -> ptr
fungsi parser_parse(p: ptr) -> ptr  # Returns AST root
fungsi parser_expect(p: ptr, type: i64) -> ptr
fungsi parser_match(p: ptr, type: i64) -> i64
```

**3.3 Grammar Rules**
- [ ] `parse_program()`
- [ ] `parse_function()`
- [ ] `parse_statement()`
- [ ] `parse_expression()`
- [ ] `parse_if()`
- [ ] `parse_while()`
- [ ] `parse_var_decl()`
- [ ] Operator precedence

**Success Criteria**:
- [ ] Parser can parse valid MorphFox programs
- [ ] AST matches bootstrap parser output (structural equivalence)
- [ ] Error reporting with line/column numbers
- [ ] Handles syntax errors gracefully

---

### Milestone 4: Code Generator Implementation

**Goal**: Write RPN bytecode generator in MorphFox

**Status**: Not Started
**Priority**: HIGH
**Estimated Effort**: 2-3 weeks

#### Tasks:

**4.1 Code Generation Context**
```morph
# src/codegen.fox
struktur CodeGen {
    instructions: ptr,  # Vector of RPN instructions
    symbol_table: ptr,  # HashMap
    string_pool: ptr,   # Vector of strings
    label_counter: i64
}

fungsi codegen_new() -> ptr
fungsi codegen_emit(cg: ptr, opcode: i64, operand: i64) -> void
fungsi codegen_generate(cg: ptr, ast: ptr) -> void
```

**4.2 AST → RPN Translation**
- [ ] Translate literals → OP_LIT
- [ ] Translate variables → OP_LOAD/OP_STORE
- [ ] Translate expressions → Stack-based operations
- [ ] Translate if/while → OP_JMP/OP_JZ
- [ ] Translate function calls → OP_CALL
- [ ] Symbol table management
- [ ] Label resolution

**4.3 Bytecode Emission**
```morph
fungsi codegen_write_morph_file(cg: ptr, path: ptr) -> void
# Write .morph file with:
# - Header (VZOELFOX + version)
# - Instruction array
```

**Success Criteria**:
- [ ] Generated bytecode matches bootstrap compiler output
- [ ] Bytecode is executable by runtime (bin/morph executor)
- [ ] All language features supported
- [ ] Byte-for-byte identical output for deterministic builds

---

### Milestone 5: Integration & Testing

**Goal**: Integrate all components and achieve self-compilation

**Status**: Not Started
**Priority**: HIGH
**Estimated Effort**: 1-2 weeks

#### Tasks:

**5.1 Main Entry Point**
```morph
# src/main.fox
utama {
    var args = get_args()

    jika (args.length < 2) {
        print_usage()
        kembali 1
    }

    var source_file = args[1]

    # Read source
    var source = file_read_all(source_file)

    # Compile pipeline
    var lexer = lexer_new(source)
    var parser = parser_new(lexer)
    var ast = parser_parse(parser)

    jika (parser.errors.length > 0) {
        print_errors(parser.errors)
        kembali 1
    }

    var codegen = codegen_new()
    codegen_generate(codegen, ast)

    # Write output
    var output = "output.morph"
    codegen_write_morph_file(codegen, output)

    kembali 0
}
```

**5.2 Compilation Test**
```bash
# Compile self-hosting compiler
./bin/morph src/main.fox -o morph-self

# Test on simple program
./morph-self test.fox -o test.morph
./bin/morph test.fox -o test-bootstrap.morph
diff test.morph test-bootstrap.morph  # Should match!
```

**5.3 Self-Compilation (Dog-fooding)**
```bash
# Compile compiler with itself
./morph-self src/main.fox -o morph-self-2

# Verify identical output
diff morph-self morph-self-2

# Success = Self-hosting achieved! 🎉
```

**Success Criteria**:
- [ ] `morph-self` compiles successfully from bootstrap
- [ ] `morph-self` produces correct output for test programs
- [ ] `morph-self` can compile itself (dog-fooding)
- [ ] Output is deterministic (byte-identical)
- [ ] All test suite passes

---

### Milestone 6: Performance & Optimization

**Goal**: Optimize self-hosting compiler

**Status**: Not Started
**Priority**: MEDIUM
**Estimated Effort**: 2-4 weeks

#### Tasks:

**6.1 Profiling**
- [ ] Measure compilation time vs bootstrap
- [ ] Identify bottlenecks (lexer? parser? codegen?)
- [ ] Memory usage analysis

**6.2 Optimizations**
- [ ] String interning (reduce allocations)
- [ ] AST node pooling
- [ ] Faster hash function for symbol table
- [ ] Buffered file I/O
- [ ] Incremental compilation (future)

**Success Criteria**:
- [ ] Compilation time within 2x of bootstrap compiler
- [ ] Memory usage reasonable (< 100MB for typical programs)

---

### Milestone 7: Bootstrap Retirement

**Goal**: Archive bootstrap compiler, achieve independence

**Status**: Not Started
**Priority**: LOW (Future)
**Estimated Effort**: 1 week

#### Tasks:

**7.1 Verification**
- [ ] All tests pass with self-hosting compiler
- [ ] Self-compilation works reliably
- [ ] Performance acceptable
- [ ] Documentation complete

**7.2 Bootstrap Archive**
```bash
cd /home/ubuntu/morphfox
git tag v1.2-bootstrap-retired
git push origin v1.2-bootstrap-retired

# Add README note
echo "This repository is archived. Bootstrap compiler frozen at v1.2-bootstrap."
echo "Active development continues in morph repository (self-hosting compiler)."
```

**7.3 Morph as Primary**
```bash
cd /home/ubuntu/morph
mv morph-self morph
# Now 'morph' is self-hosting compiler!

# Remove bootstrap binary (optional)
rm -rf bin/morph
```

**Success Criteria**:
- [ ] morphfox repo archived
- [ ] morph repo is primary compiler
- [ ] Self-hosting compiler stable and production-ready

---

## Timeline Estimate

| Milestone | Duration | Status | Completed |
|-----------|----------|--------|-----------|
| M0: Memory Safety | 1 week | ✅ COMPLETED | 2026-01-12 |
| M1: Stdlib | 2-4 weeks | ✅ COMPLETED | 2026-01-13 |
| M2: Lexer | 1-2 weeks | 🚧 NEXT | TBD |
| M3: Parser | 2-3 weeks | ⏳ PENDING | TBD |
| M4: Codegen | 2-3 weeks | ⏳ PENDING | TBD |
| M5: Integration | 1-2 weeks | ⏳ PENDING | TBD |
| M6: Optimization | 2-4 weeks | ⏳ PENDING | TBD |
| M7: Retirement | 1 week | ⏳ PENDING | TBD |
| **REMAINING** | **9-15 weeks** | | |

**Updated estimate**: 3-4 months remaining for full self-hosting

**Next Priority**: Milestone 2 (Lexer Implementation)

## Contributing

Interested in helping? Pick a milestone and start implementing!

Priority areas:
1. **Standard Library** (M1) - Great for beginners
2. **Lexer** (M2) - Learn tokenization
3. **Parser** (M3) - Learn language parsing
4. **Testing** - Write test programs

---

**Last Updated**: 2026-01-12
**Status**: Roadmap Defined, Phase 2 Not Started
