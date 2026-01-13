# Type Checker - MorphFox Self-Hosting Compiler

## Overview

Type checker untuk MorphFox compiler yang melakukan static type checking pada AST dan menghasilkan typed AST dengan error reporting.

## Type System

### Supported Types

| Type | Constant | Description |
|------|----------|-------------|
| `void` | `TYPE_VOID = 0` | No return value |
| `i64` | `TYPE_I64 = 1` | 64-bit signed integer |
| `ptr` | `TYPE_PTR = 2` | Generic pointer |
| `String` | `TYPE_STRING = 3` | Fat pointer string |
| `function` | `TYPE_FUNCTION = 4` | Function type |
| `error` | `TYPE_ERROR = -1` | Type error marker |

### Type Rules

1. **Literals**: Integer literals → `i64`, String literals → `String`
2. **Arithmetic**: Binary ops (`+`, `-`, `*`, `/`) require `i64` operands
3. **Assignment**: Target and value must have matching types
4. **Variables**: Must be declared before use
5. **Functions**: Return type must match declared type

## API

### Core Functions

```morph
fungsi type_checker_new() -> ptr
```
Creates new type checker context with empty symbol table.

```morph
fungsi type_check_ast(ast: ptr) -> ptr
```
Main entry point. Type checks entire AST and returns type checker context.

```morph
fungsi tc_has_errors(tc: ptr) -> i64
```
Returns number of type errors found.

```morph
fungsi tc_print_errors(tc: ptr) -> i64
```
Prints all type errors to stderr.

### Symbol Table

```morph
fungsi tc_add_symbol(tc: ptr, name: ptr, type: i64) -> i64
fungsi tc_lookup_symbol(tc: ptr, name: ptr) -> ptr
```

### Node Type Checking

```morph
fungsi tc_check_node(tc: ptr, node: ptr) -> i64
fungsi tc_check_literal(tc: ptr, node: ptr) -> i64
fungsi tc_check_identifier(tc: ptr, node: ptr) -> i64
fungsi tc_check_binary(tc: ptr, node: ptr) -> i64
fungsi tc_check_assign(tc: ptr, node: ptr) -> i64
fungsi tc_check_var_decl(tc: ptr, node: ptr) -> i64
fungsi tc_check_function(tc: ptr, node: ptr) -> i64
```

## Usage Example

```morph
ambil "src/type_checker.fox"

utama {
    ; Parse source to AST
    var source = "var x: i64 = 42\nx + 10"
    var parser = parser_new(source, string_length(source))
    var ast = parse_program(parser)
    
    ; Type check
    var tc = type_check_ast(ast)
    
    ; Check for errors
    jika tc_has_errors(tc) > 0
        tc_print_errors(tc)
        kembali 1
    tutup_jika
    
    sistem 1, 1, "Type checking passed!\n", 22
    kembali 0
}
```

## Error Messages

Type checker generates descriptive error messages:

- `"Undefined variable"` - Variable used before declaration
- `"Type mismatch in assignment"` - Assignment type incompatibility
- `"Left operand must be i64"` - Binary operation type error
- `"Right operand must be i64"` - Binary operation type error
- `"Initializer type mismatch"` - Variable initialization type error

## Integration

Type checker integrates with existing compiler pipeline:

```
Lexer → Parser → AST → Type Checker → Typed AST → Codegen
```

## Testing

Run type checker tests:

```bash
cd morph
./bin/morph tests/test_type_checker.fox
```

Test coverage:
- ✅ Basic type inference
- ✅ Symbol table operations
- ✅ Error detection and reporting
- ✅ Variable declarations
- ✅ Binary operations
- ✅ Function type checking

## Implementation Notes

### Memory Management
- Uses `hashmap` for symbol table (O(1) lookup)
- Uses `vector` for error collection
- Manual memory management (no GC)

### Scoping
- Simple scope counter for nested blocks
- Function-level scoping implemented
- Block-level scoping ready for extension

### Built-ins
Pre-registered built-in functions:
- `sistem` - System call interface
- `__mf_mem_alloc` - Memory allocation
- `__mf_load_i64` - Memory read
- `__mf_poke_i64` - Memory write

## Future Enhancements

1. **Advanced Types**: Structs, arrays, function pointers
2. **Generic Types**: Template-like type parameters
3. **Type Inference**: Automatic type deduction
4. **Better Errors**: Line/column information, suggestions
5. **Optimization**: Type-based optimizations

---

**Status**: ✅ IMPLEMENTED - Ready for self-hosting compiler integration
**Next**: Integrate with parser and codegen pipeline
