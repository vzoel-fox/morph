# Module System v2.1.1 - Path & Symbol Resolution

## Overview

Module System v2.1.1 menyediakan sistem import yang clean dan modern untuk Morph. Sistem ini menggunakan path resolution dan symbol management, menggantikan sistem link-based yang lama dengan syntax yang lebih readable dan maintainable.

## New Import Syntax

### Basic Import
```morph
gunakan std                    ; Import all symbols from std module
gunakan math                   ; Import all symbols from math module
gunakan bitwise                ; Import all symbols from bitwise module
```

### Specific Symbol Import
```morph
gunakan std.string_length      ; Import only string_length function
gunakan math.pow               ; Import only pow function
gunakan bitwise.popcount       ; Import only popcount function
```

### Multiple Symbol Import
```morph
gunakan std.{string_length, vector_new, hashmap_new}
gunakan math.{pow, sqrt, abs}
gunakan bitwise.{popcount, ctz, clz}
```

### Import with Alias
```morph
gunakan math sebagai m         ; Import math module as 'm'
gunakan bitwise sebagai bits   ; Import bitwise module as 'bits'
gunakan fixed_point sebagai fp ; Import fixed_point module as 'fp'
```

### Combined Syntax
```morph
gunakan std.{vector_new, hashmap_new} sebagai containers
gunakan math.{pow, sqrt} sebagai calc
```

## Usage Examples

### Direct Import Usage
```morph
gunakan std.string_length
gunakan std.vector_new

fungsi utama() -> i64
    var text = "Hello World"
    var len = string_length(text)    ; Direct usage
    
    var v = vector_new()             ; Direct usage
    vector_push(v, len)
    
    kembali 0
tutup_fungsi
```

### Aliased Module Usage
```morph
gunakan math sebagai m
gunakan bitwise sebagai bits

fungsi calculate() -> i64
    var result = m.pow(2, 8)         ; 256
    var bit_count = bits.popcount(result)  ; 1
    kembali result + bit_count
tutup_fungsi
```

### Mixed Import Styles
```morph
gunakan std.{string_length, vector_new}  ; Specific imports
gunakan math sebagai m                   ; Module alias
gunakan bitwise.popcount                 ; Single function

fungsi process_data() -> i64
    var text = "Data"
    var len = string_length(text)    ; Direct import
    var power = m.pow(len, 2)        ; Aliased module
    var bits = popcount(power)       ; Direct function import
    
    kembali bits
tutup_fungsi
```

## Module System Architecture

### Module Structure
```morph
struktur Module {
    name: ptr,          ; Module name ("std", "math", etc.)
    path: ptr,          ; File path ("corelib/lib/std.fox")
    symbols: ptr,       ; HashMap of exported symbols
    loaded: i64,        ; Load status (0=not loaded, 1=loaded)
    dependencies: ptr   ; Vector of dependency names
}
```

### Symbol Structure
```morph
struktur Symbol {
    name: ptr,          ; Symbol name ("string_length")
    type: i64,          ; Symbol type (function, variable, constant)
    address: i64,       ; Memory address or value
    module: ptr         ; Parent module reference
}
```

### Symbol Types
```morph
const SYMBOL_FUNCTION = 1    ; Functions
const SYMBOL_VARIABLE = 2    ; Variables
const SYMBOL_CONSTANT = 3    ; Constants
const SYMBOL_STRUCTURE = 4   ; Structure definitions
```

## Search Path System

### Default Search Paths
1. `corelib/lib/` - Standard library modules
2. `corelib/core/` - Core system modules  
3. `src/` - User source modules

### Adding Custom Paths
```morph
module_add_search_path("custom/modules")
module_add_search_path("third_party/libs")
```

### Module Resolution
1. Check if module already loaded
2. Search in all registered paths
3. Look for `module_name.fox`
4. Load and parse module
5. Register in module registry

## API Reference

### Module Management
```morph
fungsi module_init() -> i64                    ; Initialize module system
fungsi module_load(name: ptr) -> ptr           ; Load module by name
fungsi module_add_symbol(module: ptr, name: ptr, type: i64, addr: i64) -> i64
fungsi module_get_symbol(module: ptr, name: ptr) -> ptr
fungsi module_is_loaded(name: ptr) -> i64      ; Check if loaded
fungsi module_cleanup() -> void                ; Cleanup system
```

### Import System
```morph
fungsi import_init() -> i64                    ; Initialize import system
fungsi import_module(name: ptr) -> i64         ; Import entire module
fungsi import_symbol(module: ptr, symbol: ptr) -> i64  ; Import specific symbol
fungsi import_module_as(module: ptr, alias: ptr) -> i64  ; Import with alias
fungsi import_resolve_symbol(name: ptr) -> ptr ; Resolve symbol reference
fungsi import_cleanup() -> void                ; Cleanup import system
```

### Utility Functions
```morph
fungsi module_find_file(name: ptr) -> ptr      ; Find module file in paths
fungsi module_list_symbols(module: ptr) -> ptr ; List all module symbols
fungsi import_get_stats() -> ptr               ; Get import statistics
```

## Benefits Over Old System

### Old System (Link-based)
```morph
ambil "corelib/lib/string.fox"     ; Full path required
ambil "corelib/lib/vector.fox"     ; Repetitive paths
ambil "corelib/lib/hashmap.fox"    ; Hard to maintain
```

### New System (Path & Symbol)
```morph
gunakan std.{string_length, vector_new, hashmap_new}  ; Clean and concise
```

### Advantages
1. **Cleaner syntax**: More readable import statements
2. **Path independence**: No need to specify full paths
3. **Symbol resolution**: Import only what you need
4. **Namespace management**: Aliases prevent naming conflicts
5. **Dependency tracking**: Automatic dependency resolution
6. **Performance**: Lazy loading and symbol caching

## Compiler Integration

### Lexer Changes
- New keyword: `gunakan` (use/import)
- New keyword: `sebagai` (as)
- Support for qualified names (`module.symbol`)
- Support for symbol lists (`{symbol1, symbol2}`)

### Parser Changes
- Parse import statements
- Build import dependency graph
- Resolve symbol references
- Handle module aliases

### Code Generation
- Generate module loading code
- Resolve symbol addresses
- Optimize direct symbol access
- Handle runtime module loading

## Migration Guide

### From Old System
```morph
; OLD
ambil "corelib/lib/std.fox"

fungsi utama() -> i64
    var len = string_length("hello")
    kembali 0
tutup_fungsi
```

### To New System
```morph
; NEW
gunakan std.string_length

fungsi utama() -> i64
    var len = string_length("hello")  ; Same usage!
    kembali 0
tutup_fungsi
```

## Performance

- **Module loading**: O(1) after first load (cached)
- **Symbol resolution**: O(1) hash table lookup
- **Import processing**: O(n) where n = number of imports
- **Memory usage**: Minimal overhead per module/symbol

## Future Enhancements

1. **Conditional imports**: Import based on platform/features
2. **Version constraints**: Specify minimum module versions
3. **Circular dependency detection**: Prevent import cycles
4. **Hot reloading**: Reload modules during development
5. **Package management**: Download and manage external modules

---

**Status**: ✅ READY FOR COMPILER INTEGRATION

The module system provides a solid foundation for modern, maintainable Morph code with clean import syntax and efficient symbol resolution.
