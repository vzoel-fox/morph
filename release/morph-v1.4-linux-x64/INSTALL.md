# MorphFox Installation Guide

## Quick Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/vzoel-fox/morph/main/install.sh | bash
```

This installs:
- `morphfox` command to `/usr/local/bin/`
- Standard library to `/usr/local/lib/morph/`

## Usage After Install

### Run Scripts
```bash
# From anywhere on your system
morphfox /path/to/script.fox

# Or in current directory
morphfox script.fox
```

### Shebang Support
Add this to the top of your `.fox` file:
```fox
#!/usr/bin/env morphfox
```

Then make it executable:
```bash
chmod +x script.fox
./script.fox
```

### Example
```fox
#!/usr/bin/env morphfox
; hello.fox - Run with: ./hello.fox

utama {
    print_line("Hello, World!")
    0
}

fungsi print_line(s: String) {
    sistem 1, 1, s.buffer, s.panjang
    sistem 1, 1, "\n", 1
}
```

## Manual Installation

### From Release
```bash
# Download release
wget https://github.com/vzoel-fox/morph/releases/download/v1.4/morph-v1.4-linux-x64.tar.gz

# Extract
tar -xzf morph-v1.4-linux-x64.tar.gz
cd morph-v1.4-linux-x64

# Install
sudo cp morph /usr/local/bin/
sudo cp -r corelib /usr/local/lib/morph/
sudo cp -r brainlib /usr/local/lib/morph/
```

### From Source
```bash
git clone https://github.com/vzoel-fox/morph.git
cd morph
sudo cp bin/morph /usr/local/bin/
sudo mkdir -p /usr/local/lib/morph
sudo cp -r corelib brainlib /usr/local/lib/morph/
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MORPH_LIB` | `/usr/local/lib/morph` | Path to standard library |

## Uninstall

```bash
sudo rm /usr/local/bin/morph
sudo rm /usr/local/bin/morphfox
sudo rm -rf /usr/local/lib/morph
```

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Linux x64 | ✅ Full | Primary platform |
| Linux ARM64 | ✅ Full | Raspberry Pi, etc |
| macOS x64 | ⚠️ Beta | Intel Macs |
| macOS ARM64 | ⚠️ Beta | Apple Silicon |
| Windows | 🚧 WIP | WSL recommended |
| WASM | ✅ Full | Browser/Node.js |

## Troubleshooting

### "command not found"
Ensure `/usr/local/bin` is in your PATH:
```bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### "cannot find corelib"
Set MORPH_LIB manually:
```bash
export MORPH_LIB="/usr/local/lib/morph"
```

### Permission denied
Use sudo for system-wide install, or install to user directory:
```bash
mkdir -p ~/.local/bin ~/.local/lib/morph
# Then use ~/.local paths instead
```
