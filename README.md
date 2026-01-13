# MorphFox Programming Language

[![Version](https://img.shields.io/badge/version-v1.4-blue)](https://github.com/vzoel-fox/morph/releases)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20WASM-lightgrey)]()
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

A high-performance systems programming language with RPN-based runtime, custom memory management, and lightweight concurrency.

## 🚀 Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/vzoel-fox/morph/main/install.sh | bash
```

## ✨ Features

## 🎯 Visi: Path to Self-Hosting

```
┌─────────────────────────────────────────────────────────────┐
│ PHASE 1: Bootstrap (SELESAI) ✅                             │
│ - Compiler ditulis dalam Assembly (morphfox repo)           │
│ - Binary: bin/morph (81KB)                                  │
│ - Status: FROZEN at v1.2-bootstrap                          │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ PHASE 2: Self-Hosting (DALAM PROGRESS) 🚧                   │
│ - Compiler ditulis dalam MorphFox (src/)                    │
│ - Di-compile menggunakan bin/morph (bootstrap)              │
│ - Binary: morph-self                                        │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ PHASE 3: Independence (TARGET) 🎯                           │
│ - Bootstrap compiler bisa dihapus                           │
│ - morph-self compile dirinya sendiri                        │
│ - morphfox repo menjadi archived/reference only             │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Struktur Repository

```
morph/
├── bin/                    # Bootstrap binaries (from morphfox)
│   ├── morph               # Linux x86-64 binary (v1.2-bootstrap)
│   └── morph_merged.wat    # WebAssembly version
├── corelib/                # Core library (needed for compilation)
│   ├── core/               # Core type definitions & builtins
│   ├── lib/                # Standard library
│   └── platform/           # Platform-specific implementations
├── src/                    # Self-hosting compiler source (MorphFox)
│   └── (TODO: compiler written in MorphFox itself)
├── docs/                   # Documentation
│   ├── BOOTSTRAP.md        # Bootstrap strategy
│   └── ROADMAP.md          # Self-hosting roadmap
└── README.md               # This file
```

## 🚀 Quick Start

### Menggunakan Bootstrap Compiler v1.4

```bash
# Compile file .fox
./bin/morph program.fox

# Atau jalankan langsung
./bin/morph star.fox
```

**New in v1.4:** 
- Advanced networking support (HTTP/HTTPS, WebSocket, SSH, TLS)
- 🔒 Stripe protection for assembly codegen
- 📁 Multi-extension support (.fox, .elsa → .morph)
- 🛡️ Protected binary output format

### Contoh Program MorphFox

```morph
utama {
    var pesan = "Hello from Morph!"
    print_line(pesan)
    0
}

fungsi print_line(s: String) {
    sistem 1, 1, s.buffer, s.panjang
    sistem 1, 1, "\n", 1
}
```

## 🏗️ Building Self-Hosting Compiler

**Status**: Belum dimulai (Phase 2)

Rencana:
1. Tulis lexer dalam MorphFox (`src/lexer.fox`)
2. Tulis parser dalam MorphFox (`src/parser.fox`)
3. Tulis code generator dalam MorphFox (`src/codegen.fox`)
4. Compile menggunakan `bin/morph` (bootstrap)
5. Test: `morph-self` harus bisa compile program yang sama dengan `bin/morph`
6. Dog-fooding: `morph-self` compile `src/*.fox` (dirinya sendiri)

## 📊 Bootstrap Compiler Specifications

| Feature | Status | Notes |
|---------|--------|-------|
| **Language** | ✅ | MorphFox with Indonesian keywords |
| **Type System** | ✅ | i64, ptr, String |
| **Memory Safety** | ✅ | v1.2 with error codes 104-117 |
| **Platforms** | ✅ | Linux, Windows, WASM |
| **Bytecode Format** | ✅ | .morph (RPN-based) |
| **Standard Library** | ⚠️ | Minimal (needs expansion) |
| **Networking** | ✅ | HTTP/HTTPS, WebSocket, SSH, TLS (v1.4) |
| **Garbage Collection** | ❌ | Manual memory management only |

## 🔗 Links

- **Bootstrap Compiler Source**: [morphfox repo](https://github.com/VzoelFox/morphfox)
- **Bootstrap Tag**: [v1.2-bootstrap](https://github.com/VzoelFox/morphfox/releases/tag/v1.2-bootstrap)
- **Documentation**: [docs/](./docs/)

## 📝 License

See [LICENSE](./LICENSE) file.

## 🤝 Contributing

Phase 2 contributions welcome! See [docs/ROADMAP.md](./docs/ROADMAP.md) for self-hosting implementation plan.

---

**Note**: Bootstrap compiler (bin/morph) adalah frozen build dari [morphfox v1.2-bootstrap](https://github.com/VzoelFox/morphfox/tree/v1.2-bootstrap). Jangan modify binary ini - gunakan sebagai foundation untuk build self-hosting compiler.
