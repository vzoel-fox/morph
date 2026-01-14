# Type Checker + AI Hint Integration

## Overview

Type checker sekarang terintegrasi dengan AI-Readable Hint System dari corelib untuk memberikan diagnostics yang lebih informatif.

## Fitur Baru

### 1. AI-Enhanced Error Reporting
```fox
tc_error_hint(tc, HINT_SEMANTIC_UNDEFINED_VARIABLE, 
    "Variable not declared", "Add 'var name = ...' before use")
```

### 2. Source Location Tracking
```fox
tc_set_location(tc, line, col)  ; Set lokasi untuk hint
```

### 3. Structured Output untuk AI
```
HINT:2001|CAT:2|SEV:2|LOC:42:10|MSG:Undefined variable|FIX:Declare before use
```

### 4. Human-Readable Output
```
[WARNING] Line 42, Column 10: Undefined variable
  Suggestion: Declare variable before use with 'var name = value'
```

## Hint Codes yang Digunakan

| Code | Category | Description |
|------|----------|-------------|
| 2001 | Semantic | Undefined variable |
| 2002 | Semantic | Type mismatch |
| 2003 | Semantic | Unreachable code |
| 2004 | Semantic | Unused variable |

## API Functions

### Core
- `type_checker_new()` - Create type checker dengan AI hints enabled
- `tc_error_hint(tc, code, msg, suggestion)` - Report error dengan AI hint
- `tc_set_location(tc, line, col)` - Set source location

### Output
- `tc_print_errors(tc)` - Print errors (basic)
- `tc_print_errors_ai(tc)` - Print errors dengan AI analysis

## Integration dengan Compiler Pipeline

```fox
; Di main.fox atau compiler entry point
var tc = type_checker_new()
type_check_ast(ast)

jika tc_has_errors(tc) > 0
    tc_print_errors_ai(tc)  ; AI-enhanced output
    kembali 1
tutup_jika
```

## Test

```bash
./bin/morph tests/test_type_checker_ai.fox
```
