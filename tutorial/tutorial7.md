# Tutorial 7: Elsa Interactive Documentation

Learn to create interactive documentation with Elsa.

## 🎯 What You'll Learn

- Elsa format basics
- Interactive code blocks
- Graphics and charts
- Building documentation

## 📄 What is Elsa?

Elsa (Enhanced Language Syntax Alternative) is MorphFox's interactive documentation format - like MDX but for MorphFox.

Features:
- Markdown for text
- Executable code blocks
- Interactive widgets
- Graphics and charts

## 📝 Basic Structure

Create `intro.elsa`:

```elsa
---
title: "My Documentation"
version: "1.0"
author: "Your Name"
---

# Welcome

This is regular markdown text.

## Code Example

```morph
fungsi hello() -> void
    println("Hello from Elsa!")
tutup_fungsi

hello()
```
```

## 🔥 Live Code Blocks

Code that executes when rendered:

```elsa
## Live Demo

```morph:live
var x = 10
var y = 20
var sum = x + y

print("Sum: ")
print_int(sum)
println("")
```
```

The `:live` modifier makes code execute automatically.

## 🎮 Interactive Blocks

User-editable code:

```elsa
## Try It Yourself

```morph:interactive
; Edit this code!
var name = "World"
print("Hello, ")
println(name)
```
```

Interactive blocks create an editor where users can modify and run code.

## 📊 Charts

Data visualization:

```elsa
## Sales Data

```morph:chart
var data = [100, 150, 200, 180, 250]
var labels = ["Jan", "Feb", "Mar", "Apr", "May"]

create_bar_chart("sales", data, {
    title: "Monthly Sales",
    labels: labels
})
```
```

## 🎨 Graphics

Custom visualizations:

```elsa
## Memory Layout

```morph:graphics
create_canvas("memory", 600, 400)

; Draw memory regions
draw_rect("memory", 10, 10, 200, 50, "#4CAF50")
draw_text("memory", 20, 35, "Heap", "#FFF")

draw_rect("memory", 10, 70, 150, 50, "#2196F3")
draw_text("memory", 20, 95, "Stack", "#FFF")

draw_rect("memory", 10, 130, 100, 50, "#FF9800")
draw_text("memory", 20, 155, "Code", "#FFF")
```
```

## 📋 Frontmatter

Document metadata:

```yaml
---
title: "Document Title"
version: "1.0"
author: "Name"
date: "2026-01-13"
interactive: true
graphics: true
theme: "dark"
---
```

## 🔧 Processing Elsa

### Command Line

```bash
# Render to terminal
elsa render document.elsa

# Generate HTML
elsa html document.elsa -o output.html

# Validate
elsa validate document.elsa

# Extract code
elsa extract document.elsa -o code/
```

### In Code

```morph
ambil "tools/elsa.fox"

utama {
    ; Load and parse
    var doc = elsa_load("intro.elsa")
    
    ; Render
    elsa_render(doc)
    
    kembali 0
}
```

## 📚 Block Types Summary

| Block | Syntax | Description |
|-------|--------|-------------|
| Static | ` ```morph ` | Display only |
| Live | ` ```morph:live ` | Auto-execute |
| Interactive | ` ```morph:interactive ` | User-editable |
| Graphics | ` ```morph:graphics ` | Canvas drawing |
| Chart | ` ```morph:chart ` | Data visualization |

## 🎮 Practice Exercises

1. **API Docs**: Document a library with live examples
2. **Tutorial**: Create interactive tutorial
3. **Dashboard**: Build data dashboard with charts
4. **Playground**: Code playground with multiple examples

## ✅ Complete Example

Create `api_docs.elsa`:

```elsa
---
title: "Vector API Documentation"
version: "1.0"
interactive: true
---

# Vector API

Dynamic array implementation for MorphFox.

## Creating a Vector

```morph:live
ambil "corelib/lib/vector.fox"

var numbers = vector_new()
println("✓ Vector created")
```

## Adding Elements

```morph:interactive
ambil "corelib/lib/vector.fox"

var items = vector_new()

; Add some items
vector_push(items, 10)
vector_push(items, 20)
vector_push(items, 30)

; Print length
print("Length: ")
print_int(vector_length(items))
println("")

; Try adding more!
```

## Performance

```morph:chart
; Benchmark results
var sizes = [100, 1000, 10000, 100000]
var times = [1, 8, 75, 820]

create_line_chart("perf", times, {
    title: "Push Performance (ms)",
    labels: sizes
})
```

## Memory Layout

```morph:graphics
create_canvas("vec_mem", 500, 200)

; Vector header
draw_rect("vec_mem", 10, 10, 120, 60, "#2196F3")
draw_text("vec_mem", 20, 30, "Header", "#FFF")
draw_text("vec_mem", 20, 50, "len: 3", "#FFF")

; Data array
draw_rect("vec_mem", 150, 10, 60, 60, "#4CAF50")
draw_text("vec_mem", 165, 40, "10", "#FFF")

draw_rect("vec_mem", 220, 10, 60, 60, "#4CAF50")
draw_text("vec_mem", 235, 40, "20", "#FFF")

draw_rect("vec_mem", 290, 10, 60, 60, "#4CAF50")
draw_text("vec_mem", 305, 40, "30", "#FFF")

; Arrow
draw_line("vec_mem", 130, 40, 150, 40, "#FFF")
```
```

## 🚀 Next Steps

You've completed the MorphFox tutorial series! 🎉

- Explore `examples/` for more code
- Read `docs/` for detailed specs
- Build your own projects!

Happy coding with MorphFox! 🦊
