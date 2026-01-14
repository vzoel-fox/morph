#!/bin/bash
# Build release package for distribution
# Creates: morph-v1.4-linux-x64.tar.gz

set -e

VERSION="v1.4"
OS="linux"
ARCH="x64"
RELEASE_NAME="morph-$VERSION-$OS-$ARCH"
RELEASE_DIR="release/$RELEASE_NAME"

echo "📦 Building MorphFox Release Package"
echo "====================================="
echo "Version: $VERSION"
echo ""

# Clean previous
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

# Copy binary
echo "📋 Copying binary..."
cp bin/morph "$RELEASE_DIR/"

# Copy corelib (essential)
echo "📋 Copying corelib..."
cp -r corelib "$RELEASE_DIR/"

# Copy brainlib (optional but useful)
echo "📋 Copying brainlib..."
cp -r brainlib "$RELEASE_DIR/"

# Copy examples
echo "📋 Copying examples..."
cp -r examples "$RELEASE_DIR/"

# Copy docs
echo "📋 Copying documentation..."
mkdir -p "$RELEASE_DIR/docs"
cp README.md "$RELEASE_DIR/"
cp LICENSE "$RELEASE_DIR/"
cp INSTALL.md "$RELEASE_DIR/"
cp docs/ROADMAP.md "$RELEASE_DIR/docs/" 2>/dev/null || true

# Create tarball
echo "🗜️  Creating tarball..."
cd release
tar -czf "$RELEASE_NAME.tar.gz" "$RELEASE_NAME"
cd ..

# Calculate checksum
echo "🔐 Calculating checksum..."
sha256sum "release/$RELEASE_NAME.tar.gz" > "release/$RELEASE_NAME.sha256"

# Show result
echo ""
echo "✅ Release package created:"
echo "   release/$RELEASE_NAME.tar.gz"
echo "   release/$RELEASE_NAME.sha256"
echo ""
ls -lh "release/$RELEASE_NAME.tar.gz"
echo ""
cat "release/$RELEASE_NAME.sha256"
