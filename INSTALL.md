# MorphFox Package Manager (mpm)

A simple package manager for MorphFox libraries and tools.

## Installation

### Quick Install (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/vzoel-fox/morph/main/install.sh | bash
```

### Manual Installation

#### Linux/macOS
```bash
# Download latest release
wget https://github.com/vzoel-fox/morph/releases/latest/download/morph-linux-x64
chmod +x morph-linux-x64
sudo mv morph-linux-x64 /usr/local/bin/morph

# Verify installation
morph --version
```

#### Windows
```powershell
# Download from releases page
# https://github.com/vzoel-fox/morph/releases/latest
# Add to PATH environment variable
```

### Build from Source
```bash
git clone https://github.com/vzoel-fox/morph.git
cd morph
./scripts/build_selfhost.sh
sudo cp bin/morph /usr/local/bin/
```

## Usage

### Basic Commands
```bash
# Check version
morph --version

# Compile and run
morph hello.fox

# Compile only
morph -c hello.fox -o hello

# Run compiled binary
./hello
```

### Package Management
```bash
# Initialize new project
morph init my-project

# Install package
morph install http-server

# List installed packages
morph list

# Update packages
morph update

# Remove package
morph remove http-server
```

### Project Structure
```
my-project/
├── morph.toml          # Project configuration
├── src/
│   └── main.fox        # Main source file
├── lib/                # Dependencies
├── tests/              # Test files
└── build/              # Build output
```

### Configuration (morph.toml)
```toml
[package]
name = "my-project"
version = "1.0.0"
author = "Your Name"
description = "My MorphFox project"

[dependencies]
http-server = "1.2.0"
json-parser = "0.8.1"

[build]
target = "native"
optimization = "release"
```

## Examples

### Hello World
```bash
morph init hello-world
cd hello-world
echo 'utama { sistem 1, 1, "Hello, World!\n", 14; kembali 0 }' > src/main.fox
morph run
```

### Web Server
```bash
morph init web-server
cd web-server
morph install http-server
# Edit src/main.fox with server code
morph build --release
```

## Global Installation Verification

After installation, you should be able to run:
```bash
$ morph --version
MorphFox v1.4.0

$ morph --help
MorphFox Programming Language

Usage: morph [OPTIONS] <FILE>

Options:
  -c, --compile     Compile only (don't run)
  -o, --output      Output file name
  -O, --optimize    Optimization level (0-3)
  -v, --version     Show version
  -h, --help        Show help

Examples:
  morph hello.fox           # Compile and run
  morph -c hello.fox        # Compile only
  morph -o app hello.fox    # Compile to 'app'
```

## Uninstallation
```bash
sudo rm /usr/local/bin/morph
rm -rf ~/.morph  # Remove user data
```
