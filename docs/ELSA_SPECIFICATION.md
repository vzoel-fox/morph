# Elsa Language Specification

## Overview

**Elsa** (.elsa) adalah extension language untuk Morph yang menggabungkan:
- **Markdown-like syntax** untuk dokumentasi
- **Embedded Morph code** untuk logic dan computation  
- **Graphics capabilities** melalui Linux system calls
- **Interactive elements** untuk dynamic content

## Syntax Design

### Basic Structure
```elsa
---
title: "Interactive Morph Documentation"
graphics: true
interactive: true
---

# Morph Memory Safety System

This is regular markdown content with **bold** and *italic* text.

## Live Code Example

```morph:live
fungsi calculate_fibonacci(n: i64) -> i64
    jika (n <= 1) {
        kembali n
    }
    kembali calculate_fibonacci(n-1) + calculate_fibonacci(n-2)
tutup_fungsi

# Execute and show result
var result = calculate_fibonacci(10)
```

The result is: **{result}** (computed live)

## Graphics Demo

```morph:graphics
# Draw simple visualization
fungsi draw_memory_usage() -> void
    # Linux framebuffer access
    var fb = sistem_open("/dev/fb0", 2)  # O_RDWR
    
    # Draw colored bars representing memory usage
    var colors = [0xFF0000, 0x00FF00, 0x0000FF]  # Red, Green, Blue
    
    var i = 0
    selama (i < 3) {
        draw_rectangle(fb, i * 100, 50, 80, 200, colors[i])
        i = i + 1
    }
    
    sistem_close(fb)
tutup_fungsi

draw_memory_usage()
```

## Interactive Elements

```morph:interactive
var counter = 0

fungsi increment_counter() -> void
    counter = counter + 1
    update_display("counter_value", counter)
tutup_fungsi

# Create interactive button
create_button("increment", "Click me!", increment_counter)
display_value("counter_value", counter)
```

Current counter: **{counter}**

## Data Visualization

```morph:chart
var memory_data = [1024, 2048, 1536, 3072, 2560]
var labels = ["Heap", "Stack", "Code", "Data", "Free"]

create_bar_chart("memory_chart", memory_data, labels, {
    title: "Memory Usage Distribution",
    colors: ["#FF6B35", "#4FC1FF", "#32CD32", "#FFD700", "#FF6B6B"]
})
```

## System Integration

```morph:system
# Real-time system monitoring
fungsi get_system_info() -> void
    var cpu_usage = read_proc_stat()
    var memory_info = read_proc_meminfo()
    var disk_usage = get_disk_usage("/")
    
    update_chart("system_monitor", {
        cpu: cpu_usage,
        memory: memory_info.used / memory_info.total * 100,
        disk: disk_usage.used / disk_usage.total * 100
    })
tutup_fungsi

# Update every 1000ms
set_interval(get_system_info, 1000)
```
```

## File Extensions

### .elsa Files
- **Primary**: Interactive documentation with embedded Morph
- **Rendering**: HTML + Canvas/WebGL output
- **Execution**: Live Morph code execution

### .elsa.md
- **Fallback**: Static markdown version
- **GitHub**: Displays as regular markdown
- **Compatibility**: Works without Elsa processor

## Implementation Architecture

### Elsa Processor
```
.elsa file → Elsa Parser → HTML + JS + WASM → Interactive Document
```

### Components
1. **Markdown Parser**: Standard markdown processing
2. **Morph Code Extractor**: Extract and compile embedded code
3. **Graphics Renderer**: Linux framebuffer/X11 integration
4. **Interactive Engine**: Event handling and state management
5. **Live Execution**: Real-time Morph code execution
