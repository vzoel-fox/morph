# MorphFox Tutorial Series

Welcome to MorphFox! This tutorial series will guide you through learning the MorphFox programming language from basics to advanced features.

## 🦊 What is MorphFox?

MorphFox is a modern systems programming language featuring:
- **RPN-based runtime** for blazing fast execution
- **Custom memory management** with arenas and pools
- **MorphRoutines** for lightweight concurrency
- **Advanced type system** with generics and unions
- **Real-time performance** with predictable behavior

## 📚 Tutorial Structure

### Tutorial 1: Getting Started
**File:** `tutorial1.md`
- Variables and basic types
- Arithmetic operations
- Simple functions
- Control flow (if/else, loops)

### Tutorial 2: Advanced Features
**File:** `tutorial2.md`
- Memory management (arenas, allocators)
- Data structures and structs
- MorphRoutines (lightweight threads)
- Performance optimization

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

## 🚀 Quick Start

1. **Install MorphFox compiler:**
   ```bash
   git clone https://github.com/vzoel-fox/morph.git
   cd morph
   ./scripts/build_selfhost.sh
   ```

2. **Run your first program:**
   ```bash
   ./bin/morph examples/hello.fox
   ```

3. **Follow the tutorials:**
   Start with `tutorial1.md` and work your way through each lesson.

## 🎯 Learning Path

**Beginner** → Tutorial 1-2 (Variables, functions, basic memory)
**Intermediate** → Tutorial 3-4 (Types, concurrency)
**Advanced** → Tutorial 5 (Real-world applications)

## 💡 Key Concepts

- **RPN Runtime**: Stack-based execution for performance
- **Arena Allocation**: Batch memory management
- **MorphRoutines**: Cooperative lightweight threads
- **Type Safety**: Advanced static type checking
- **Zero GC**: Manual memory control for predictability

## 🔗 Resources

- **Documentation**: `../docs/`
- **Examples**: `../examples/`
- **Tests**: `../tests/`
- **Source Code**: `../src/`

## 🤝 Community

- **GitHub**: https://github.com/vzoel-fox/morph
- **Issues**: Report bugs and request features
- **Discussions**: Ask questions and share projects

---

**Ready to start?** Begin with [Tutorial 1: Getting Started](tutorial1.md)

Happy coding with MorphFox! 🦊🚀
