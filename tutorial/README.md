# Morph Tutorial Series

Welcome to Morph! This tutorial series will guide you through learning the Morph programming language from basics to advanced features.

## 🦊 What is Morph?

Morph is a modern systems programming language featuring:
- **Clean API** for memory, I/O, and networking
- **RPN-based runtime** for blazing fast execution
- **Custom memory management** with arenas and pools
- **MorphRoutines** for lightweight concurrency
- **Advanced type system** with generics and unions
- **Elsa** interactive documentation format

## 📚 Tutorial Structure

### Tutorial 1: Getting Started
**File:** `tutorial1.md`
- Variables and basic types
- Arithmetic operations
- Simple functions
- Control flow (if/else, loops)
- Using standard library

### Tutorial 2: Memory & Data Structures
**File:** `tutorial2.md`
- Memory allocation with clean API
- Vector and HashMap
- Custom structs
- File I/O

### Tutorial 3: Type System
**File:** `tutorial3.md`
- Advanced types (structs, arrays, unions)
- Generics and type aliases
- Type checking and validation
- Error handling

### Tutorial 4: Concurrency
**File:** `tutorial4.md`
- MorphRoutines in depth
- Concurrent programming patterns
- Real-time systems
- Performance at scale

### Tutorial 5: Real-World Applications
**File:** `tutorial5.md`
- Building complete applications
- Integration with system APIs
- Networking and I/O
- Production deployment

### Tutorial 6: Tools & Configuration
**File:** `tutorial6.md`
- Star: Config runner
- Fall: Configuration format
- Building applications
- Deployment

### Tutorial 7: Elsa Documentation
**File:** `tutorial7.md`
- Elsa format basics
- Interactive code blocks
- Graphics and charts
- Building documentation

## 🚀 Quick Start

1. **Install Morph:**
   ```bash
   curl -sSL https://raw.githubusercontent.com/vzoel-fox/morph/main/install.sh | bash
   ```

2. **Run your first program:**
   ```bash
   morph examples/hello.fox
   ```

3. **Follow the tutorials:**
   Start with `tutorial1.md` and work your way through each lesson.

## 🎯 Learning Path

**Beginner** → Tutorial 1-2 (Variables, functions, memory)
**Intermediate** → Tutorial 3-4 (Types, concurrency)
**Advanced** → Tutorial 5-7 (Applications, tools, docs)

## 💡 Key Concepts

- **Clean API**: `alloc()`, `free()`, `println()` - no raw syscalls
- **Data Structures**: Vector, HashMap built-in
- **MorphRoutines**: Cooperative lightweight threads
- **Type Safety**: Advanced static type checking
- **Fall Config**: Simple key-value configuration
- **Elsa Docs**: Interactive documentation

## 📁 File Extensions

| Extension | Description |
|-----------|-------------|
| `.fox` | Morph source code |
| `.morph` | Compiled bytecode |
| `.fall` | Configuration file |
| `.elsa` | Interactive documentation |

## 🔗 Resources

- **Documentation**: `../docs/`
- **Examples**: `../examples/`
- **Tests**: `../tests/`
- **Tools**: `../tools/`

## 🤝 Community

- **GitHub**: https://github.com/vzoel-fox/morph
- **Issues**: Report bugs and request features
- **Discussions**: Ask questions and share projects

---

**Ready to start?** Begin with [Tutorial 1: Getting Started](tutorial1.md)

Happy coding with Morph! 🦊🚀
