# Testing the Bootstrap Compiler

This document contains tests to verify the bootstrap compiler works correctly.

## Basic Test

### Test 1: Hello World

```bash
cd /home/ubuntu/morph
./bin/morph examples/hello.fox
```

**Expected Output**:
```
Hello from Morph Self-Hosting Compiler!
Angka: [number]
```

### Test 2: Fibonacci

```bash
cd /home/ubuntu/morph
./bin/morph examples/fibonacci.fox
```

**Expected Output**:
```
Fibonacci ke-10:
```

(Note: Full output requires stdlib expansion for number printing)

## Compilation Test

### Test 3: Compile to .morph bytecode

```bash
cd /home/ubuntu/morph

# Check if morph can read and execute .fox files
./bin/morph examples/hello.fox

# Success if no errors and program executes
```

## Verification Checklist

- [ ] `bin/morph` is executable
- [ ] Can run .fox files
- [ ] Basic I/O works (sistem syscalls)
- [ ] Variables and functions work
- [ ] Control flow (jika/selama) works

## Next Steps After Tests Pass

1. Expand standard library (see docs/ROADMAP.md M1)
2. Start implementing self-hosting compiler in src/
3. Write unit tests for language features
