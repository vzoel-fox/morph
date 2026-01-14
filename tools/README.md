# MorphFox Tools

## Overview

Tools untuk development dan deployment MorphFox.

## Tools

### 1. `morph` - Compiler/Runner
Main compiler dan interpreter.

```bash
morph script.fox          # Run script
morph script.fox -o out   # Compile to .morph
morph program.morph       # Run compiled
```

### 2. `star` - Config Runner
Process spawner dengan config dari .fall files.

```bash
star spawn data.fall      # Spawn dengan config
star run script.fox       # Run dengan config
star env data.fall        # Load environment
```

### 3. `elsa` - Documentation Processor
Interactive documentation engine untuk .elsa files.

```bash
elsa render doc.elsa      # Render ke terminal
elsa html doc.elsa        # Render ke HTML
elsa validate doc.elsa    # Validate document
```

## File Formats

| Extension | Description | Tool |
|-----------|-------------|------|
| `.fox` | MorphFox source code | morph |
| `.morph` | Compiled bytecode | morph |
| `.fall` | Configuration file | star |
| `.elsa` | Interactive documentation | elsa |

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    USER INTERFACE                        │
├─────────────────────────────────────────────────────────┤
│  morph          │  star           │  elsa               │
│  Compile/Run    │  Config/Spawn   │  Documentation      │
├─────────────────────────────────────────────────────────┤
│                    BOOTSTRAP CORE                        │
│  Lexer → Parser → Codegen → Executor                    │
├─────────────────────────────────────────────────────────┤
│                    CORELIB                               │
│  Memory │ I/O │ Net │ Crypto │ Types                    │
└─────────────────────────────────────────────────────────┘
```

## Building Tools

```bash
# Build all tools
./scripts/build_tools.sh

# Build individual tool
./bin/morph tools/star.fox -o bin/star
./bin/morph tools/elsa.fox -o bin/elsa
```
