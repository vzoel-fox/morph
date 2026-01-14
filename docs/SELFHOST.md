# Morph Self-Host Roadmap

## Overview

Self-hosting adalah proses menulis compiler Morph dalam bahasa Morph sendiri.

## Arsitektur Bootstrap

```
Stage 0: Assembly (bootstrap/asm/)
    └── lexer.s, parser.s, compiler.s, executor.s
    └── Menghasilkan bin/morph (native binary)

Stage 1: Morph (src/selfhost.fox)
    └── Lexer, Parser, Compiler dalam sintaks .fox
    └── Dikompilasi oleh Stage 0
    └── Menghasilkan morph_stage1

Stage 2: Self-Compile
    └── morph_stage1 mengkompilasi selfhost.fox
    └── Menghasilkan morph_stage2
    └── Jika stage1 == stage2, self-host berhasil!
```

## Komponen Self-Host

### 1. Lexer (lexer_*)
- `lexer_buat(input, len)` - Buat state lexer
- `lexer_next(lex)` - Ambil token berikutnya
- `lexer_char(lex)` - Peek karakter saat ini
- `lexer_maju(lex)` - Advance posisi

### 2. Token Types
| ID | Nama | Contoh |
|----|------|--------|
| 0 | EOF | - |
| 1 | INTEGER | 42 |
| 2 | IDENTIFIER | nama |
| 3 | OPERATOR | + - * / |
| 4 | KEYWORD | fungsi, jika |
| 5 | STRING | "hello" |
| 6 | DELIMITER | ( ) , |
| 7 | COLON | : |

### 3. Intent Node (48 bytes)
```
[0x00] type     - Tipe node
[0x08] next     - Sibling berikutnya
[0x10] child    - Child pertama
[0x18] hint     - Metadata
[0x20] data_a   - Payload A
[0x28] data_b   - Payload B
```

### 4. Compiler Output (RPN Bytecode)
| Opcode | Nama | Deskripsi |
|--------|------|-----------|
| 1 | OP_LIT | Push literal |
| 2 | OP_LOAD | Load variable |
| 3 | OP_STORE | Store variable |
| 10 | OP_ADD | Tambah |
| 11 | OP_SUB | Kurang |
| 12 | OP_MUL | Kali |
| 13 | OP_DIV | Bagi |
| 99 | OP_EXIT | Keluar |

## Sintaks Morph

```fox
ambil "path/file.fox"           ; Full import
ambil "path/file.fox" : Symbol  ; Granular import

fungsi nama(arg: tipe) -> tipe
  var x = 10
  const Y = 20
  
  jika (kondisi)
    ; ...
  lain
    ; ...
  tutup_jika
  
  selama (kondisi)
    ; ...
  tutup_selama
  
  kembali nilai
tutup_fungsi
```

## Progress

- [x] Lexer dasar
- [x] Token struct
- [x] Node struct
- [ ] Parser lengkap
- [ ] Compiler lengkap
- [ ] Executor integration
- [ ] Stage 1 build
- [ ] Stage 2 verification
