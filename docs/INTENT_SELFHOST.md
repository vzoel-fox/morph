# Intent Tree Self-Hosting Strategy

## Goal

Replace Assembly-based Intent Tree generation with MorphFox-based implementation. This is the **first step towards full self-hosting** compiler.

## Why Intent Tree First?

Instead of rewriting the entire compiler (lexer → parser → codegen → executor), we focus on **Intent Tree** as the intermediate representation:

1. **Modular approach** - Intent Tree is well-defined IR between parsing and codegen
2. **Testable** - Can validate tree structure independently
3. **Incremental** - Can mix Assembly lexer/parser with MorphFox Intent builder
4. **Foundation** - Once Intent works, rest of compiler becomes easier

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│ Phase 1: Bootstrap (Assembly)  ✅ FROZEN               │
│ ┌──────────┐   ┌────────┐   ┌──────────┐   ┌─────────┐│
│ │  Lexer   │──▶│ Parser │──▶│ Intent   │──▶│ Codegen ││
│ │(Assembly)│   │(Asm)   │   │ Builder  │   │  (Asm)  ││
│ └──────────┘   └────────┘   │ (Asm)    │   └─────────┘│
│                               └──────────┘              │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Phase 2: Intent Self-Hosting  🚧 CURRENT                │
│ ┌──────────┐   ┌────────┐   ┌──────────┐   ┌─────────┐│
│ │  Lexer   │──▶│ Parser │──▶│ Intent   │──▶│ Codegen ││
│ │(Assembly)│   │(Asm)   │   │ Builder  │   │  (Asm)  ││
│ └──────────┘   └────────┘   │(MorphFox)│   └─────────┘│
│                               └──────────┘              │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Phase 3: Full Self-Hosting  🎯 FUTURE                   │
│ ┌──────────┐   ┌────────┐   ┌──────────┐   ┌─────────┐│
│ │  Lexer   │──▶│ Parser │──▶│ Intent   │──▶│ Codegen ││
│ │(MorphFox)│   │(MorphFox)  │ Builder  │   │(MorphFox││
│ └──────────┘   └────────┘   │(MorphFox)│   └─────────┘│
│                               └──────────┘              │
└─────────────────────────────────────────────────────────┘
```

## Intent Tree Structure

### Node Layout (48 bytes)

```
Offset  Size  Field      Description
------  ----  --------   -----------
0x00    8     Type       Node type (UNIT/SHARD/FRAGMENT)
0x08    8     Next       Sibling pointer (linked list)
0x10    8     Child      First child pointer
0x18    8     Hint       Metadata (line, column, source)
0x20    8     Data A     Payload field A
0x28    8     Data B     Payload field B
```

### Node Types

**Level 1: UNIT** (Module/File scope)
- `INTENT_UNIT_MODULE = 0x1001`

**Level 2: SHARD** (Function/Block scope)
- `INTENT_SHARD_FUNC = 0x2001` - Function definition
- `INTENT_SHARD_BLOCK = 0x2002` - Generic block

**Level 3: FRAGMENT** (Expression/Statement)
- `INTENT_FRAG_LITERAL = 0x3001` - Literal value
- `INTENT_FRAG_BINARY = 0x3002` - Binary operation (a + b)
- `INTENT_FRAG_UNARY = 0x3003` - Unary operation (-a)
- `INTENT_FRAG_CALL = 0x3004` - Function call
- `INTENT_FRAG_VAR = 0x3005` - Variable access
- `INTENT_FRAG_ASSIGN = 0x3006` - Assignment
- `INTENT_FRAG_IF = 0x3007` - If statement
- `INTENT_FRAG_WHILE = 0x3008` - While loop
- `INTENT_FRAG_RETURN = 0x3009` - Return statement

## Implementation

### Builtins Required

To build Intent Trees in MorphFox, we need memory primitives as builtins:

```fox
; Memory allocation
fungsi __mf_mem_alloc(size: i64) -> ptr

; Memory read/write (i64)
fungsi __mf_load_i64(addr: ptr) -> i64
fungsi __mf_poke_i64(addr: ptr, value: i64) -> void

; Memory read/write (byte)
fungsi __mf_load_byte(addr: ptr) -> i64
fungsi __mf_poke_byte(addr: ptr, value: i64) -> void
```

### Intent Builder API

```fox
; Core node creation
fungsi intent_new_node(type: i64) -> ptr
fungsi intent_set_next(node: ptr, next: ptr) -> void
fungsi intent_set_child(node: ptr, child: ptr) -> void

; Convenience builders
fungsi intent_new_literal(value: i64) -> ptr
fungsi intent_new_var(name: ptr) -> ptr
fungsi intent_new_binary(op: i64, left: ptr, right: ptr) -> ptr
fungsi intent_new_assign(name: ptr, value: ptr) -> ptr
fungsi intent_new_function(name: ptr, body: ptr) -> ptr
fungsi intent_new_module(first_function: ptr) -> ptr
```

## Example Usage

```fox
; Build tree for: x = 42
var lit = intent_new_literal(42)
var assign = intent_new_assign("x", lit)

; Build tree for: y = x + 10
var var_x = intent_new_var("x")
var lit_10 = intent_new_literal(10)
var binop = intent_new_binary('+', var_x, lit_10)
var assign_y = intent_new_assign("y", binop)

; Link statements
intent_set_next(assign, assign_y)

; Wrap in function
var func = intent_new_function("main", assign)

; Wrap in module
var module = intent_new_module(func)
```

## Testing Strategy

1. **Unit Tests** - Test individual node creation
2. **Integration Tests** - Build small trees, verify structure
3. **Comparison Tests** - Compare output with Assembly parser
4. **Dog-fooding** - Use Intent builder to build compiler's own Intent tree

## Current Status

| Component | Status | Location |
|-----------|--------|----------|
| **Builtins Spec** | ✅ Defined | `corelib/core/builtins.fox` |
| **Memory Helpers** | ✅ Defined | `corelib/lib/memory.fox` |
| **Intent Builder** | ✅ Defined | `src/intent_builder.fox` |
| **Builtins Impl** | ⏳ Pending | Need Assembly implementation |
| **Testing** | ⏳ Pending | Need working builtins first |

## Next Steps

1. **Implement Builtins** in Assembly
   - `__mf_mem_alloc` - Wrapper around mem_alloc
   - `__mf_load_i64` / `__mf_poke_i64` - Direct memory access
   - `__mf_load_byte` / `__mf_poke_byte` - Byte access

2. **Test Intent Builder**
   - Create simple nodes
   - Verify memory layout
   - Build small trees

3. **Integration**
   - Parse MorphFox source → Intent Tree (MorphFox)
   - Intent Tree → RPN bytecode (Assembly codegen)
   - Verify output matches

4. **Expand**
   - Once Intent works, replace lexer
   - Then replace parser
   - Then replace codegen
   - Full self-hosting achieved!

## Timeline Estimate

| Milestone | Duration | Status |
|-----------|----------|--------|
| Intent builtins | 1 week | Pending |
| Intent builder test | 1 week | Pending |
| Intent integration | 2 weeks | Pending |
| **Total** | **4 weeks** | Phase 2 |

This is **much faster** than full compiler rewrite (11-19 weeks), proving the value of modular approach!

---

**Last Updated**: 2026-01-12
**Current Phase**: Phase 1 Complete → Phase 2 Planning
