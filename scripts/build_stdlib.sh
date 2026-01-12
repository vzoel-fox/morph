#!/bin/bash
# Build script for MorphFox stdlib builtins

set -e

echo "Building MorphFox stdlib builtins..."

# Create build directory
mkdir -p build

# Assemble all builtin implementations
echo "Assembling builtins..."
as --64 -o build/memory_io_builtins.o bootstrap/asm/memory_io_builtins.s
as --64 -o build/morphroutine_runtime.o bootstrap/asm/morphroutine_runtime.s
as --64 -o build/alloc.o bootstrap/asm/alloc.s
as --64 -o build/arena.o bootstrap/asm/arena.s
as --64 -o build/pool.o bootstrap/asm/pool.s
as --64 -o build/builtins.o bootstrap/asm/builtins.s

# Link all objects into a single library
echo "Creating stdlib library..."
ar rcs build/libmorphfox_stdlib.a \
    build/memory_io_builtins.o \
    build/morphroutine_runtime.o \
    build/alloc.o \
    build/arena.o \
    build/pool.o \
    build/builtins.o

echo "Stdlib library created: build/libmorphfox_stdlib.a"

# Test compilation (if morph compiler exists)
if [ -f "bin/morph" ]; then
    echo "Testing stdlib compilation..."
    ./bin/morph tests/test_stdlib.fox
    echo "Stdlib test compiled successfully!"
else
    echo "Warning: bin/morph not found, skipping test compilation"
fi

echo "Build completed successfully!"
