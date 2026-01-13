#!/bin/bash
# MorphFox Release Builder
# Creates release binaries for multiple platforms

set -e

VERSION="v1.4.0"
BUILD_DIR="release"
PLATFORMS=("linux-x64" "linux-arm64" "darwin-x64" "darwin-arm64" "windows-x64")

echo "🏗️  Building MorphFox Release $VERSION"
echo "====================================="

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Build self-hosting compiler first
echo "📦 Building self-hosting compiler..."
./scripts/build_selfhost.sh

# Create release binaries for each platform
for platform in "${PLATFORMS[@]}"; do
    echo "🔨 Building for $platform..."
    
    # Extract OS and arch
    IFS='-' read -r os arch <<< "$platform"
    
    # Copy binary with platform-specific name
    if [ "$os" = "windows" ]; then
        cp bin/morph "$BUILD_DIR/morph-$platform.exe"
    else
        cp bin/morph "$BUILD_DIR/morph-$platform"
    fi
    
    # Make executable
    chmod +x "$BUILD_DIR/morph-$platform"*
done

# Create checksums
echo "🔐 Generating checksums..."
cd "$BUILD_DIR"
sha256sum morph-* > checksums.txt
cd ..

# Create release archive
echo "📦 Creating release archive..."
tar -czf "$BUILD_DIR/morphfox-$VERSION.tar.gz" -C "$BUILD_DIR" .

echo "✅ Release build complete!"
echo "📁 Files in $BUILD_DIR/:"
ls -la "$BUILD_DIR/"

echo ""
echo "🚀 Ready for GitHub release:"
echo "1. Create new release: https://github.com/vzoel-fox/morph/releases/new"
echo "2. Tag: $VERSION"
echo "3. Upload files from $BUILD_DIR/"
echo "4. Update install.sh with new version"
