#!/bin/bash
# Morph Complete Installer
# Usage: curl -sSL https://raw.githubusercontent.com/vzoel-fox/morph/main/install.sh | bash

set -e

MORPH_VERSION="v1.4"
INSTALL_DIR="/usr/local/bin"
LIB_DIR="/usr/local/lib/morph"
TEMP_DIR="/tmp/morph-install"

echo "🦊 Morph Installer"
echo "===================="
echo "Version: $MORPH_VERSION"
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

# Create directories
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download release tarball (includes corelib + brainlib)
DOWNLOAD_URL="https://github.com/vzoel-fox/morph/releases/download/$MORPH_VERSION/morph-$MORPH_VERSION-$OS-$ARCH.tar.gz"
echo "📥 Downloading Morph..."

if ! curl -sSL "$DOWNLOAD_URL" -o morph.tar.gz 2>/dev/null; then
    # Fallback: clone repo
    echo "📥 Downloading from repository..."
    git clone --depth 1 --branch main https://github.com/vzoel-fox/morph.git morph-repo
    cd morph-repo
    
    BINARY="bin/morph"
    CORELIB="corelib"
    BRAINLIB="brainlib"
else
    tar -xzf morph.tar.gz
    cd morph-*
    
    BINARY="morph"
    CORELIB="corelib"
    BRAINLIB="brainlib"
fi

# Install binary
echo "📦 Installing binary to $INSTALL_DIR..."
if [ -w "$INSTALL_DIR" ]; then
    cp "$BINARY" "$INSTALL_DIR/morph"
    chmod +x "$INSTALL_DIR/morph"
else
    sudo cp "$BINARY" "$INSTALL_DIR/morph"
    sudo chmod +x "$INSTALL_DIR/morph"
fi

# Install libraries
echo "📚 Installing libraries to $LIB_DIR..."
if [ -w "$(dirname $LIB_DIR)" ]; then
    mkdir -p "$LIB_DIR"
    cp -r "$CORELIB" "$LIB_DIR/"
    [ -d "$BRAINLIB" ] && cp -r "$BRAINLIB" "$LIB_DIR/"
else
    sudo mkdir -p "$LIB_DIR"
    sudo cp -r "$CORELIB" "$LIB_DIR/"
    [ -d "$BRAINLIB" ] && sudo cp -r "$BRAINLIB" "$LIB_DIR/"
fi

# Create wrapper script with lib path
echo "🔧 Creating wrapper..."
WRAPPER='#!/bin/bash
export MORPH_LIB="/usr/local/lib/morph"
exec /usr/local/bin/morph "$@"'

if [ -w "$INSTALL_DIR" ]; then
    echo "$WRAPPER" > "$INSTALL_DIR/morph"
    chmod +x "$INSTALL_DIR/morph"
else
    echo "$WRAPPER" | sudo tee "$INSTALL_DIR/morph" > /dev/null
    sudo chmod +x "$INSTALL_DIR/morph"
fi

# Verify
echo ""
if command -v morph >/dev/null 2>&1; then
    echo "✅ Morph installed successfully!"
    echo ""
    echo "🚀 Usage:"
    echo "  morph script.fox        # Run a script"
    echo "  morph -c 'print(42)'    # Run inline code"
    echo ""
    echo "📁 Installed to:"
    echo "  Binary:    $INSTALL_DIR/morph"
    echo "  Libraries: $LIB_DIR/"
    echo ""
    echo "💡 Tip: Add shebang to run scripts directly:"
    echo "  #!/usr/bin/env morph"
else
    echo "❌ Installation failed"
    exit 1
fi

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo "🎉 Happy coding!"
