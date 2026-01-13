#!/bin/bash
# MorphFox Installer Script
# Usage: curl -sSL https://raw.githubusercontent.com/vzoel-fox/morph/main/install.sh | bash

set -e

MORPH_VERSION="v1.4"
INSTALL_DIR="/usr/local/bin"
TEMP_DIR="/tmp/morph-install"

echo "🦊 MorphFox Installer"
echo "===================="
echo "Version: $MORPH_VERSION"
echo "Install Directory: $INSTALL_DIR"
echo ""

# Detect OS and Architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
    x86_64) ARCH="x64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
esac

echo "🔍 Detected: $OS-$ARCH"

# Create temp directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download MorphFox binary
DOWNLOAD_URL="https://github.com/vzoel-fox/morph/releases/download/$MORPH_VERSION/morph-$OS-$ARCH"
echo "📥 Downloading MorphFox..."
curl -sSL "$DOWNLOAD_URL" -o morph

# Make executable
chmod +x morph

# Install to system
echo "📦 Installing to $INSTALL_DIR..."
if [ -w "$INSTALL_DIR" ]; then
    mv morph "$INSTALL_DIR/morph"
else
    sudo mv morph "$INSTALL_DIR/morph"
fi

# Verify installation
if command -v morph >/dev/null 2>&1; then
    echo "✅ MorphFox installed successfully!"
    echo ""
    echo "🚀 Quick Start:"
    echo "  morph --version"
    echo "  morph examples/hello.fox"
    echo ""
    echo "📚 Learn more:"
    echo "  https://github.com/vzoel-fox/morph/tree/main/tutorial"
else
    echo "❌ Installation failed"
    exit 1
fi

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo "🎉 Happy coding with MorphFox!"
