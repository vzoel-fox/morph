# Bootstrap Strategy

## Overview

MorphFox compiler menggunakan **classical bootstrap strategy** yang umum digunakan dalam pengembangan compiler modern (seperti Rust, Go, Zig).

## Timeline & Phases

### Phase 1: Assembly Bootstrap (✅ SELESAI)

**Repository**: [morphfox](https://github.com/VzoelFox/morphfox)
**Tag**: v1.2-bootstrap
**Duration**: Initial development

#### What was built:
- ✅ Lexer (Assembly) - Tokenize source code
- ✅ Parser (Assembly) - Generate Intent/AST
- ✅ Code Generator (Assembly) - Emit RPN bytecode
- ✅ Runtime/Executor (Assembly) - Stack VM
- ✅ Memory Allocator (Assembly) - Custom allocator with page management
- ✅ Platform Abstraction (Assembly) - Linux/Windows/WASM support
- ✅ Core Library (MorphFox) - Types, builtins, standard library

#### Binary Artifacts:
```
bin/morph               # 81KB - Linux x86-64
bin/morph_merged.wat    # 18KB - WebAssembly
```

#### Key Statistics:
- **99 assembly files** (.s for Linux, .asm for Windows, .wat for WASM)
- **22 core library files** (.fox)
- **~14MB** total source code
- **Memory safety**: v1.2 with defensive programming

#### Why Assembly?
- Zero dependencies (no libc, no external runtime)
- Maximum control over memory and execution
- Learning experience (understand low-level details)
- Proof of concept for language design

### Phase 2: Self-Hosting Compiler (🚧 CURRENT PHASE)

**Repository**: [morph](https://github.com/vzoel-fox/morph)
**Status**: Planning / Not Started
**Goal**: Rewrite compiler in MorphFox itself

#### What will be built:
```
src/
├── lexer.fox           # Tokenizer written in MorphFox
├── parser.fox          # Parser written in MorphFox
├── codegen.fox         # Code generator written in MorphFox
├── runtime.fox         # Runtime utilities
├── main.fox            # Entry point
└── utils/
    ├── string.fox      # String utilities
    ├── buffer.fox      # Buffer management
    └── hashmap.fox     # Symbol table implementation
```

#### Process:
1. **Write**: Compiler components in `src/*.fox`
2. **Compile**: Using `bin/morph` (bootstrap compiler)
   ```bash
   ./bin/morph src/main.fox -o morph-self
   ```
3. **Test**: Verify `morph-self` produces identical output
   ```bash
   ./morph-self test.fox > output1.morph
   ./bin/morph test.fox > output2.morph
   diff output1.morph output2.morph  # Should be identical
   ```
4. **Dog-food**: `morph-self` compile itself
   ```bash
   ./morph-self src/main.fox -o morph-self-2
   diff morph-self morph-self-2  # Should be identical
   ```

#### Challenges:
- ❌ **No GC**: Manual memory management only
- ❌ **Limited stdlib**: Need to expand for compiler needs
- ❌ **No dynamic arrays**: Need to implement or work around
- ❌ **No proper string type**: Only ptr + length
- ⚠️ **Debugging**: Limited debugging tools

#### Prerequisites for Phase 2:
Before starting self-hosting rewrite, we need:
1. ✅ Stable bootstrap compiler (DONE)
2. ⚠️ Expanded standard library
   - String operations (split, concat, trim)
   - File I/O wrappers
   - HashMap/Dictionary implementation
   - Dynamic array/vector
3. ⚠️ Better error handling
   - Error messages, not just exit codes
   - Stack traces
4. ⚠️ Testing framework
   - Unit tests for language features
   - Integration tests for compiler

### Phase 3: Independence (🎯 FUTURE)

**Status**: Future Goal
**Goal**: Delete bootstrap compiler, achieve full self-hosting

#### Success Criteria:
- ✅ `morph-self` can compile itself
- ✅ `morph-self` produces byte-identical output (deterministic)
- ✅ All tests pass with `morph-self`
- ✅ Performance comparable to bootstrap compiler
- ✅ Bootstrap compiler no longer needed

#### At this point:
```bash
# Bootstrap compiler can be archived
cd morphfox
git tag v1.2-bootstrap-archived
# morphfox repo becomes reference/documentation only

# morph repo becomes the main compiler
cd morph
./morph-self src/main.fox -o morph
# Now morph is compiled by itself!
```

## Why This Approach?

### Pros:
✅ **Clean separation**: Bootstrap vs self-hosting
✅ **Incremental development**: Can test each phase
✅ **Safety net**: Always have working bootstrap compiler
✅ **Learning**: Understand both Assembly and high-level implementation
✅ **Proof of maturity**: Self-hosting is a milestone for any language

### Cons:
⚠️ **Dual maintenance** (during Phase 2): Need to maintain both compilers
⚠️ **Feature parity**: Self-hosting compiler must match all features
⚠️ **Testing complexity**: Need to test both compilers produce same output

## Historical Examples

Many successful languages used this approach:

| Language | Bootstrap Language | Self-Hosting Achieved |
|----------|-------------------|----------------------|
| **C** | Assembly | 1973 (Dennis Ritchie) |
| **Go** | C | 2015 (Go 1.5) |
| **Rust** | OCaml | 2011 (Rust 0.1) |
| **PyPy** | Python + RPython | 2007 |
| **Zig** | C++ | Not yet (planned) |

**MorphFox Strategy**: Assembly → MorphFox (Current plan)

## Next Steps

### Immediate (Phase 2 Prep):
1. [ ] Expand standard library (see ROADMAP.md)
2. [ ] Add string utilities
3. [ ] Implement HashMap for symbol table
4. [ ] Add file I/O wrappers
5. [ ] Create testing framework

### Short-term (Phase 2 Start):
1. [ ] Design self-hosting compiler architecture
2. [ ] Write lexer in MorphFox
3. [ ] Write parser in MorphFox
4. [ ] Write code generator in MorphFox

### Long-term (Phase 3):
1. [ ] Achieve dog-fooding (compile itself)
2. [ ] Verify deterministic builds
3. [ ] Performance optimization
4. [ ] Archive bootstrap compiler

## References

- Bootstrap compiler source: https://github.com/VzoelFox/morphfox
- Bootstrap tag: v1.2-bootstrap
- Current binary: `bin/morph`
- Core library: `corelib/`

---

**Last Updated**: 2026-01-12
**Current Phase**: Phase 1 Complete → Phase 2 Planning
