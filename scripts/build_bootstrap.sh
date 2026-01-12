#!/bin/bash
# script/build_bootstrap.sh
# Build and Link the MorphFox Bootstrap Compiler (Stage 0)

set -e

# Directories relative to repo root
ASM_DIR="bootstrap/asm"
TOOLS_DIR="bootstrap/tools"
OUT_DIR="."

echo "[Build] Setting up output directory..."
# We output directly to root as requested (or just ./morph)
# but for object files we need a build dir
BUILD_DIR="build/bootstrap"
mkdir -p "$BUILD_DIR"

# List of Source Files (Core)
SOURCES=(
    "runtime.s"
    "alloc.s"
    "stack.s"
    "scheduler.s"
    "builtins.s"
    "executor.s"
    "control_flow.s"
    "context.s"
    "string.s"
    "type.s"
    "symbol.s"
    "arena.s"
    "pool.s"
    "snapshot.s"
    "lexer.s"
    "vector.s"
    "parser.s"
    "compiler.s"
    "net.s"
    "dns.s"
    "graphics.s"
    "font.s"
    "crypto_sha256.s"
    "crypto_chacha20.s"
    "daemon_cleaner.s"
)

OBJECTS=""

echo "[Build] Assembling Core Sources..."
for src in "${SOURCES[@]}"; do
    echo "  -> $src"
    as -g -o "$BUILD_DIR/${src%.s}.o" "$ASM_DIR/$src"
    OBJECTS="$OBJECTS $BUILD_DIR/${src%.s}.o"
done

echo "[Build] Assembling Morph CLI..."
as -g -o "$BUILD_DIR/morph.o" "$TOOLS_DIR/morph.s"

echo "[Build] Linking Morph CLI..."
ld -o "$OUT_DIR/morph" "$BUILD_DIR/morph.o" $OBJECTS

echo "--------------------------------------------------------"
echo "[Success] Bootstrap Compiler created at: $OUT_DIR/morph"
echo "--------------------------------------------------------"
