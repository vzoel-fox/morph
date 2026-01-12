# Self-Hosting Compiler Source

This directory will contain the MorphFox self-hosting compiler implementation.

## Status: NOT STARTED (Phase 2)

## Planned Structure

```
src/
├── main.fox              # Entry point
├── lexer.fox             # Tokenizer
├── parser.fox            # Parser (AST generation)
├── codegen.fox           # Code generator (RPN bytecode)
├── token.fox             # Token definitions
├── ast.fox               # AST node definitions
└── utils/
    ├── string.fox        # String utilities
    ├── vector.fox        # Dynamic array
    ├── hashmap.fox       # Hash table (for symbol table)
    └── error.fox         # Error handling
```

## Implementation Strategy

See [../docs/ROADMAP.md](../docs/ROADMAP.md) for detailed milestones.

### Phase 2A: Prerequisites (Milestone 1)
- Expand standard library
- Implement data structures (Vector, HashMap)
- Add string operations
- File I/O wrappers

### Phase 2B: Core Compiler (Milestones 2-4)
- Implement lexer in MorphFox
- Implement parser in MorphFox
- Implement code generator in MorphFox

### Phase 2C: Integration (Milestone 5)
- Integrate all components
- Compile with bootstrap: `../bin/morph main.fox -o morph-self`
- Test: `./morph-self` should work like `../bin/morph`
- Dog-food: `./morph-self main.fox` should compile itself

## How to Start

1. **Start with stdlib** (Milestone 1):
   ```bash
   # Add to corelib/lib/
   # - string.fox
   # - vector.fox
   # - hashmap.fox
   ```

2. **Write lexer** (Milestone 2):
   ```bash
   # Create src/lexer.fox
   # Test: ./bin/morph src/test_lexer.fox
   ```

3. **Write parser** (Milestone 3):
   ```bash
   # Create src/parser.fox
   # Test: ./bin/morph src/test_parser.fox
   ```

4. **Write codegen** (Milestone 4):
   ```bash
   # Create src/codegen.fox
   # Test: ./bin/morph src/test_codegen.fox
   ```

5. **Integrate** (Milestone 5):
   ```bash
   # Create src/main.fox
   ./bin/morph src/main.fox -o morph-self
   ./morph-self examples/hello.fox  # Should work!
   ```

## Current Status

**Phase**: Phase 1 Complete (Bootstrap frozen at v1.2)
**Next**: Phase 2A (Expand stdlib)

See [ROADMAP.md](../docs/ROADMAP.md) for full timeline.

---

**Placeholder**: This directory is currently empty. Implementation will begin after stdlib expansion (Milestone 1).
