# Tutorial 2: Memory & Data Structures

Now let's explore Morph's memory management and data structures!

## 🎯 What You'll Learn

- Memory allocation with clean API
- Data structures (Vector, HashMap)
- Structs and custom types
- Best practices

## 🧠 Memory Management

Morph provides a clean memory API:

### Basic Allocation

```morph
ambil "corelib/api.fox"

utama {
    ; Allocate 1KB buffer
    var buffer = alloc(1024)
    
    jika buffer != 0
        println("✓ Memory allocated")
        
        ; Use memory...
        
        ; Free when done
        free(buffer)
        println("✓ Memory freed")
    tutup_jika
    
    kembali 0
}
```

### Reallocation

```morph
ambil "corelib/api.fox"

utama {
    ; Start with small buffer
    var buf = alloc(64)
    
    ; Need more space? Reallocate
    buf = realloc(buf, 64, 256)
    
    println("✓ Buffer resized")
    
    free(buf)
    kembali 0
}
```

## 📊 Data Structures

### Vector (Dynamic Array)

```morph
ambil "corelib/lib/vector.fox"
ambil "corelib/api.fox"

utama {
    ; Create vector
    var numbers = vector_new()
    
    ; Add elements
    vector_push(numbers, 10)
    vector_push(numbers, 20)
    vector_push(numbers, 30)
    
    ; Get length
    var len = vector_length(numbers)
    print("Length: ")
    print_int(len)
    println("")
    
    ; Access elements
    var first = vector_get(numbers, 0)
    print("First: ")
    print_int(first)
    println("")
    
    kembali 0
}
```

### HashMap (Key-Value Store)

```morph
ambil "corelib/lib/hashmap.fox"
ambil "corelib/api.fox"

utama {
    ; Create hashmap
    var config = hashmap_new()
    
    ; Set values
    hashmap_set(config, "name", "MorphFox")
    hashmap_set(config, "version", "1.4")
    
    ; Get values
    var name = hashmap_get(config, "name")
    print("Name: ")
    println(name)
    
    kembali 0
}
```

## 🏗️ Custom Structs

### Using Type Runtime

```morph
ambil "corelib/lib/type_runtime.fox"
ambil "corelib/api.fox"

utama {
    ; Define Point struct
    var Point = type_create("Point")
    type_add_field(Point, "x", TYPEID_I64)
    type_add_field(Point, "y", TYPEID_I64)
    
    ; Create instance
    var p = type_alloc_instance(Point)
    
    ; Set fields
    type_set_field(p, Point, "x", 10)
    type_set_field(p, Point, "y", 20)
    
    ; Get fields
    var x = type_get_field(p, Point, "x")
    var y = type_get_field(p, Point, "y")
    
    print("Point: (")
    print_int(x)
    print(", ")
    print_int(y)
    println(")")
    
    kembali 0
}
```

### Manual Struct Pattern

```morph
ambil "corelib/api.fox"

; Point: { x: i64, y: i64 } = 16 bytes
const POINT_X = 0
const POINT_Y = 8
const POINT_SIZE = 16

fungsi point_new(x: i64, y: i64) -> ptr
    var p = alloc(POINT_SIZE)
    __mf_poke_i64(p + POINT_X, x)
    __mf_poke_i64(p + POINT_Y, y)
    kembali p
tutup_fungsi

fungsi point_get_x(p: ptr) -> i64
    kembali __mf_load_i64(p + POINT_X)
tutup_fungsi

fungsi point_get_y(p: ptr) -> i64
    kembali __mf_load_i64(p + POINT_Y)
tutup_fungsi

utama {
    var p1 = point_new(3, 4)
    var p2 = point_new(6, 8)
    
    print("P1: (")
    print_int(point_get_x(p1))
    print(", ")
    print_int(point_get_y(p1))
    println(")")
    
    free(p1)
    free(p2)
    kembali 0
}
```

## 📁 File I/O

```morph
ambil "corelib/api.fox"

utama {
    ; Read file
    var content = read_file("data.txt")
    jika content != 0
        println("File content:")
        println(content)
        free(content)
    tutup_jika
    
    ; Write file
    var data = "Hello from MorphFox!"
    write_file("output.txt", data, 20)
    println("✓ File written")
    
    kembali 0
}
```

## 🎮 Practice Exercises

1. **Stack**: Implement push/pop using Vector
2. **Config Loader**: Read .fall config file
3. **Contact Book**: Store name/phone in HashMap
4. **Linked List**: Implement with manual structs

## 📖 Key Concepts

- **`alloc(size)`**: Allocate memory
- **`free(ptr)`**: Free memory
- **`realloc(ptr, old, new)`**: Resize allocation
- **`vector_new/push/get`**: Dynamic arrays
- **`hashmap_new/set/get`**: Key-value storage
- **`type_create/add_field`**: Runtime type info

## ✅ Complete Example: Contact Book

```morph
ambil "corelib/lib/hashmap.fox"
ambil "corelib/api.fox"

var contacts = 0

fungsi init_contacts() -> void
    contacts = hashmap_new()
tutup_fungsi

fungsi add_contact(name: ptr, phone: ptr) -> void
    hashmap_set(contacts, name, phone)
    print("Added: ")
    println(name)
tutup_fungsi

fungsi find_contact(name: ptr) -> ptr
    kembali hashmap_get(contacts, name)
tutup_fungsi

utama {
    println("📞 Contact Book")
    
    init_contacts()
    
    add_contact("Alice", "123-456")
    add_contact("Bob", "789-012")
    
    var phone = find_contact("Alice")
    jika phone != 0
        print("Alice's phone: ")
        println(phone)
    tutup_jika
    
    kembali 0
}
```

## 🚀 Next Steps

Continue to [Tutorial 3: Type System](tutorial3.md)
