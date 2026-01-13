# AI-Readable Hint & Error System

## Overview

Enhanced hint system yang mengikuti **SSOT (Single Source of Truth)** principles dengan output yang dioptimalkan untuk AI understanding dan human debugging.

## SSOT Compliance

### ✅ Sesuai dengan Prelude SSOT
- **Error Handling**: Mengikuti `Result<T, Error>` pattern dari prelude
- **Memory Management**: Terintegrasi dengan memory safety system
- **ABI Compliance**: Compatible dengan platform abstraction layer
- **Structured Output**: Machine-readable format untuk AI processing

### 🔄 Enhanced dari SSOT Original
- **Structured Hint Codes**: 4-digit codes untuk AI classification
- **Category System**: Semantic grouping (syntax, memory, performance)
- **Severity Levels**: Priority-based error handling
- **Context Awareness**: Source location dan fix suggestions

## AI-Readable Format

### Structured Hint Output
```
HINT:<code>|CAT:<category>|SEV:<severity>|LOC:<line>:<column>|MSG:<message>|FIX:<suggestion>
```

### Example Output
```
HINT:1001|CAT:1|SEV:3|LOC:42:15|MSG:Missing semicolon|FIX:Add ';' at end
HINT:4001|CAT:4|SEV:4|LOC:58:8|MSG:Potential memory leak|FIX:Call mem_free()
HINT:3001|CAT:3|SEV:1|LOC:73:12|MSG:Inefficient loop|FIX:Use iterator pattern
```

### Analysis Summary
```
ANALYSIS|TOTAL:3|SYNTAX:1|MEMORY:1|PERFORMANCE:1|CRITICAL:1|ERRORS:1|WARNINGS:0
```

## Hint Code Structure

### 4-Digit Classification System
- **First Digit**: Category (1=Syntax, 2=Semantic, 3=Performance, 4=Memory, 5=Type, 6=Flow)
- **Last 3 Digits**: Specific error within category

### Categories

#### 1xxx - Syntax Errors
- `1001` - Missing semicolon
- `1002` - Unmatched brace
- `1003` - Invalid identifier
- `1004` - Unexpected token

#### 2xxx - Semantic Issues
- `2001` - Undefined variable
- `2002` - Type mismatch
- `2003` - Unreachable code
- `2004` - Unused variable

#### 3xxx - Performance Hints
- `3001` - Inefficient loop
- `3002` - Redundant allocation
- `3003` - Deep recursion

#### 4xxx - Memory Safety (Critical)
- `4001` - Potential memory leak
- `4002` - Double free
- `4003` - Null pointer dereference
- `4004` - Buffer overflow

#### 5xxx - Type System
- `5001` - Implicit conversion
- `5002` - Precision loss
- `5003` - Unsafe cast

#### 6xxx - Control Flow
- `6001` - Infinite loop
- `6002` - Missing return
- `6003` - Dead code

## Severity Levels

### 1 - INFO (Blue)
- Performance suggestions
- Code style recommendations
- Optimization opportunities

### 2 - WARNING (Yellow)
- Potential issues
- Deprecated usage
- Semantic concerns

### 3 - ERROR (Red)
- Syntax errors
- Type mismatches
- Must fix before compilation

### 4 - CRITICAL (Bright Red)
- Memory safety violations
- System-breaking issues
- Security vulnerabilities

## AI Understanding Benefits

### 🤖 Machine Parsing
1. **Structured Format**: Easy regex parsing
2. **Consistent Schema**: Predictable field order
3. **Numeric Codes**: Efficient classification
4. **Context Information**: Source location data

### 📊 Pattern Recognition
- **Error Clustering**: Group similar issues
- **Severity Analysis**: Priority-based fixing
- **Category Trends**: Identify problem areas
- **Fix Suggestions**: Automated corrections

### 🔍 Code Quality Analysis
- **Complexity Metrics**: Performance hint density
- **Safety Score**: Memory violation count
- **Maintainability**: Semantic issue ratio
- **Best Practices**: Style compliance

## Human-Readable Output

### Color-Coded Display
```
[CRITICAL] Line 58, Column 8: Potential memory leak
  Suggestion: Call mem_free() for every mem_alloc()

[ERROR] Line 42, Column 15: Missing semicolon
  Suggestion: Add ';' at end of line

[WARNING] Line 73, Column 12: Inefficient loop
  Suggestion: Use iterator pattern
```

### ANSI Color Codes
- **CRITICAL**: `\033[91m` (Bright Red)
- **ERROR**: `\033[31m` (Red)
- **WARNING**: `\033[33m` (Yellow)
- **INFO**: `\033[36m` (Cyan)
- **Suggestion**: `\033[32m` (Green)

## Integration with Morph Compiler

### Phase 1 (Current)
- **Bootstrap Integration**: Hint generation dalam bootstrap compiler
- **Memory Safety**: Integration dengan memory safety system
- **Error Reporting**: Enhanced error messages

### Phase 2 (Self-Hosting)
- **Lexer Hints**: Token-level error detection
- **Parser Hints**: Syntax tree validation
- **Semantic Analysis**: Type checking dan flow analysis
- **Code Generation**: Optimization suggestions

### Phase 3 (Advanced)
- **LSP Integration**: Real-time hints dalam editor
- **AI-Assisted Fixes**: Automated code corrections
- **Learning System**: Adaptive hint generation
- **Performance Profiling**: Runtime hint generation

## API Reference

### Core Functions
```morph
fungsi hint_system_init() -> void
fungsi create_hint(code: i64, line: i64, column: i64, message: ptr, suggestion: ptr) -> ptr
fungsi print_hint_structured(hint: ptr) -> void
fungsi print_hint_human(hint: ptr) -> void
fungsi analyze_hints() -> void
```

### Hint Generation
```morph
fungsi generate_syntax_hint(code: i64, line: i64, column: i64, context: ptr) -> ptr
fungsi generate_memory_hint(code: i64, line: i64, column: i64, context: ptr) -> ptr
fungsi determine_severity(code: i64) -> i64
```

## Usage Examples

### Compiler Integration
```morph
# During parsing
jika (missing_semicolon) {
    var hint = generate_syntax_hint(HINT_SYNTAX_MISSING_SEMICOLON, line, col, context)
    print_hint_structured(hint)
}

# During memory analysis
jika (potential_leak_detected) {
    var hint = generate_memory_hint(HINT_MEMORY_POTENTIAL_LEAK, line, col, context)
    print_hint_human(hint)
}
```

### AI Processing
```python
# Parse structured hints
import re

hint_pattern = r'HINT:(\d+)\|CAT:(\d+)\|SEV:(\d+)\|LOC:(\d+):(\d+)\|MSG:([^|]+)\|FIX:(.+)'
matches = re.findall(hint_pattern, compiler_output)

for code, category, severity, line, column, message, fix in matches:
    process_hint(int(code), int(category), int(severity), message, fix)
```

### Statistics Analysis
```morph
analyze_hints()
# Output: ANALYSIS|TOTAL:15|SYNTAX:3|MEMORY:2|PERFORMANCE:5|CRITICAL:1|ERRORS:4|WARNINGS:10
```

## Benefits

### For Developers
1. **Clear Error Messages**: Structured dan actionable
2. **Fix Suggestions**: Concrete steps untuk resolution
3. **Priority Guidance**: Severity-based fixing order
4. **Learning Aid**: Educational error explanations

### For AI Systems
1. **Structured Data**: Machine-parseable format
2. **Pattern Recognition**: Consistent classification
3. **Context Awareness**: Source location dan suggestions
4. **Quality Metrics**: Quantifiable code quality data

### For Tools
1. **IDE Integration**: Real-time hint display
2. **CI/CD Pipeline**: Automated quality checks
3. **Code Review**: Structured feedback
4. **Documentation**: Auto-generated quality reports

---

**Status**: SSOT-compliant, AI-optimized, ready for Phase 2 integration
**Compatibility**: Backward compatible dengan existing error handling
**Performance**: Minimal overhead, structured output
