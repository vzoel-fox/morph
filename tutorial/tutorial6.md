# Tutorial 6: Tools & Configuration

Learn to use MorphFox tools for development workflow.

## 🎯 What You'll Learn

- Star: Config runner and process spawner
- Fall: Configuration file format
- Building and deploying applications

## ⭐ Star - Config Runner

Star manages configuration and process spawning.

### Basic Usage

```bash
# Load and display config
star env data.fall

# Run script with config
star run app.fox

# Spawn background process
star spawn data.fall
```

### Configuration File (.fall)

Create `app.fall`:

```fall
# Application configuration
app_name: MyApp
version: 1.0.0
port: 8080
database: production_db
debug: false
```

### Using Config in Code

```morph
ambil "corelib/lib/fall.fox"
ambil "corelib/api.fox"

utama {
    ; Load configuration
    var config = fall_load("app.fall")
    
    jika config == 0
        println("Error: Cannot load config")
        kembali 1
    tutup_jika
    
    ; Read values
    var app_name = fall_get(config, "app_name")
    var port = fall_get_int(config, "port", 3000)
    
    print("Starting ")
    println(app_name)
    print("Port: ")
    print_int(port)
    println("")
    
    kembali 0
}
```

## 📁 Fall Format

Fall is a simple key-value configuration format:

```fall
# Comments start with #
key: value
another_key: another value

# Numbers
port: 8080
timeout: 30

# Strings (no quotes needed)
name: My Application
path: /usr/local/bin
```

### Accessing Values

```morph
ambil "corelib/lib/fall.fox"

utama {
    var config = fall_load("config.fall")
    
    ; String value
    var name = fall_get(config, "name")
    
    ; Integer with default
    var port = fall_get_int(config, "port", 8080)
    
    ; Check if key exists
    jika fall_has(config, "debug")
        println("Debug mode available")
    tutup_jika
    
    kembali 0
}
```

## 🔧 Building Applications

### Project Structure

```
myapp/
├── app.fall          # Configuration
├── main.fox          # Entry point
├── lib/
│   ├── utils.fox
│   └── handlers.fox
└── data/
    └── sample.txt
```

### Main Entry Point

```morph
; main.fox
ambil "corelib/api.fox"
ambil "corelib/lib/fall.fox"
ambil "lib/utils.fox"

var config = 0

fungsi init() -> i64
    config = fall_load("app.fall")
    jika config == 0
        println("Failed to load config")
        kembali 0
    tutup_jika
    
    var name = fall_get(config, "app_name")
    print("Initializing ")
    println(name)
    kembali 1
tutup_fungsi

utama {
    jika init() == 0
        kembali 1
    tutup_jika
    
    println("Application started!")
    
    ; Main loop
    var running = 1
    selama running == 1
        ; Process events...
        yield()
    tutup_selama
    
    kembali 0
}
```

## 🚀 Deployment

### Build Script

```bash
#!/bin/bash
# build.sh

echo "Building MyApp..."

# Compile main
./bin/morph main.fox -o myapp

# Copy config
cp app.fall dist/

# Package
tar -czf myapp-v1.0.tar.gz dist/

echo "Build complete!"
```

### Running in Production

```bash
# With Star
star spawn app.fall

# Direct
./myapp
```

## 🎮 Practice Exercises

1. **Config Validator**: Check required keys exist
2. **Multi-Environment**: Load dev.fall or prod.fall based on flag
3. **Hot Reload**: Watch config file for changes
4. **CLI Tool**: Parse command line arguments

## 📖 Key Concepts

- **Star**: Process and config management
- **Fall**: Simple configuration format
- **`fall_load`**: Load .fall file
- **`fall_get`**: Get string value
- **`fall_get_int`**: Get integer with default

## ✅ Complete Example: Web Server Config

```morph
ambil "corelib/lib/fall.fox"
ambil "corelib/lib/net.fox"
ambil "corelib/api.fox"

var server_config = 0

fungsi load_server_config() -> i64
    server_config = fall_load("server.fall")
    kembali server_config != 0
tutup_fungsi

fungsi get_port() -> i64
    kembali fall_get_int(server_config, "port", 8080)
tutup_fungsi

fungsi get_host() -> ptr
    var host = fall_get(server_config, "host")
    jika host == 0
        kembali "0.0.0.0"
    tutup_jika
    kembali host
tutup_fungsi

utama {
    println("🌐 Web Server")
    
    jika load_server_config() == 0
        println("Using default config")
    tutup_jika
    
    var port = get_port()
    var host = get_host()
    
    print("Starting server on ")
    print(host)
    print(":")
    print_int(port)
    println("")
    
    ; Start server...
    
    kembali 0
}
```

**server.fall:**
```fall
host: 0.0.0.0
port: 3000
max_connections: 100
timeout: 30
```

## 🚀 Next Steps

Continue to [Tutorial 7: Elsa Documentation](tutorial7.md)
