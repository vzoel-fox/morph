#!/bin/bash
# ==============================================================================
# BUILD MORPHFOX DISTRIBUTION
# ==============================================================================
# Compile internal kernel dan hapus source code
# User hanya dapat: api.fox + morph binary
# ==============================================================================

set -e

echo "🔒 Building MorphFox Locked Distribution"
echo "========================================"

# 1. Compile kernel into binary
echo "📦 Compiling internal kernel..."
./bin/morph corelib/internal/kernel.fox -o lib/morph_kernel.morph

# 2. Compile full runtime
echo "📦 Compiling runtime..."
./bin/morph src/main.fox -o morph-dist

# 3. Create distribution directory
echo "📁 Creating distribution..."
mkdir -p dist/corelib

# 4. Copy ONLY public API
cp corelib/api.fox dist/corelib/
cp corelib/lib/std.fox dist/corelib/ 2>/dev/null || true

# 5. Copy binary
cp morph-dist dist/morph
chmod +x dist/morph

# 6. Copy compiled kernel (not source!)
cp lib/morph_kernel.morph dist/lib/

# 7. DO NOT copy internal/
echo "🔐 Internal source NOT included in distribution"

# 8. Create manifest
cat > dist/MANIFEST << 'EOF'
MorphFox Distribution
=====================
Files:
  morph              - Compiler binary
  corelib/api.fox    - Public API (user-facing)
  lib/morph_kernel.morph - Compiled runtime (locked)

Internal implementation is NOT included.
Syscall details are hidden in compiled binary.
EOF

echo ""
echo "✅ Distribution created in dist/"
echo ""
echo "Contents:"
ls -la dist/
echo ""
echo "🔒 Internal source code is NOT included"
echo "   User sees: api.fox (clean interface)"
echo "   User gets: morph binary (compiled kernel inside)"
