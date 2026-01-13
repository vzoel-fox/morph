# MorphFox v1.4 Release

## Bootstrap Compiler - FINAL VERSION

This is the **final frozen version** of the MorphFox bootstrap compiler. All future development continues in the self-hosting compiler.

### Binaries

- **Linux x86-64**: `morph-linux-x86_64` (95,928 bytes)
- **WebAssembly**: `morph-wasm.wat` (18,246 bytes)

### New Features in v1.4

#### Advanced Networking Support
- **HTTP/HTTPS Client** - Full HTTP/1.1 with TLS support
- **WebSocket Client** - RFC 6455 compliant implementation
- **SSH Client** - SSH-2 protocol with authentication
- **TLS/SSL Client** - TLS 1.2 handshake and encryption

#### Technical Specifications
- **Binary Growth**: +30.4% (from 73,560 to 95,928 bytes)
- **New Modules**: 4 networking modules (~22KB total)
- **Platform**: Linux x86-64 (primary), WASM (secondary)
- **Dependencies**: None (pure syscall implementation)

### Usage

```bash
# Download binary
wget https://github.com/vzoel-fox/morph/releases/download/v1.4/morph-linux-x86_64
chmod +x morph-linux-x86_64

# Run MorphFox programs
./morph-linux-x86_64 program.fox
```

### Networking API

The bootstrap compiler now includes low-level networking primitives:

```assembly
# HTTP GET request
call __mf_http_get

# WebSocket connection
call __mf_ws_connect
call __mf_ws_send_text

# SSH connection
call __mf_ssh_connect
call __mf_ssh_exec

# TLS connection
call __mf_tls_connect
call __mf_tls_send
```

### Self-Hosting Integration

These networking primitives are available for the self-hosting compiler through wrapper functions in MorphFox language.

### Checksums

```
SHA256 (morph-linux-x86_64): [to be calculated]
SHA256 (morph-wasm.wat): [to be calculated]
```

---

**Status**: FROZEN - No further updates to bootstrap compiler
**Next**: Self-hosting compiler development continues
**Repository**: https://github.com/vzoel-fox/morph
