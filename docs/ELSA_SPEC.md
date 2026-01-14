---
title: "Elsa Specification"
version: "1.0"
author: "VzoelFox"
---

# Elsa - Enhanced Language Syntax Alternative

Elsa adalah format dokumentasi interaktif untuk Morph, mirip dengan MDX tapi dengan kemampuan eksekusi kode native.

## Format Dasar

```
---
title: "Document Title"
version: "1.0"
---

# Heading

Regular markdown content...

```morph:live
; Executable code
var x = 42
print_int(x)
```
```

## Block Types

### 1. Text Block (Markdown)
Standard markdown syntax untuk teks, heading, list, dll.

### 2. Code Block (Static)
```morph
; Static code - hanya ditampilkan, tidak dieksekusi
fungsi example() -> i64
    kembali 42
tutup_fungsi
```

### 3. Live Code Block
```morph:live
; Dieksekusi saat dokumen di-render
var result = 10 + 20
print_int(result)  ; Output: 30
```

### 4. Interactive Block
```morph:interactive
; User bisa edit dan run
create_editor("editor1", "var x = 0")
create_button("run", "Run", lambda() { execute("editor1") })
```

### 5. Graphics Block
```morph:graphics
; Render grafik/visualisasi
create_canvas("canvas1", 800, 600)
draw_rect("canvas1", 10, 10, 100, 100, "#FF0000")
```

### 6. Chart Block
```morph:chart
; Generate chart dari data
var data = [10, 20, 30, 40, 50]
create_bar_chart("chart1", data, { title: "Sales" })
```

## Frontmatter

YAML-like metadata di awal file:

```
---
title: "Page Title"
author: "Name"
version: "1.0"
graphics: true
interactive: true
theme: "dark"
---
```

## Inline Expressions

Embed hasil eksekusi dalam teks:

```
The answer is {calculate_answer()}.
Current time: {get_timestamp()}.
```

## Widgets

### Editor
```morph:interactive
create_editor(id, initial_code, options)
```

### Button
```morph:interactive
create_button(id, label, onclick_handler)
```

### Display Area
```morph:interactive
display_area(id, initial_text)
update_display(id, new_text)
```

### Counter
```morph:interactive
display_counter(id, value, label)
update_counter(id, new_value)
```

### Dropdown
```morph:interactive
create_dropdown(id, options, onchange_handler)
```

## File Extension

- `.elsa` - Elsa document
- `.fox` - Morph source code
- `.morph` - Compiled bytecode
- `.fall` - Configuration file

## Processing

```bash
# Render to terminal
elsa render document.elsa

# Render to HTML
elsa html document.elsa -o output.html

# Extract code blocks
elsa extract document.elsa -o code/

# Validate document
elsa validate document.elsa
```

## Example Document

```elsa
---
title: "Hello Elsa"
interactive: true
---

# Welcome to Elsa

This is an interactive document.

## Live Demo

```morph:live
println_str("Hello from Elsa!")
var x = 10 + 20
print("Result: ", 8)
print_num(x)
```

## Try It Yourself

```morph:interactive
create_editor("demo", "var n = 5\nprint_num(n * n)")
create_button("run", "Run Code", lambda() {
    var code = get_editor_content("demo")
    var result = execute_code(code)
    update_display("output", result)
})
display_area("output", "Click Run to see output")
```
```
