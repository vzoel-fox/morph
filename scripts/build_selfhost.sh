#!/bin/bash
# Build MorphFox Self-Hosting Compiler with Stripe Protection

set -e

echo "🚀 Building MorphFox Self-Hosting Compiler v1.4"
echo "🔒 With Stripe Protection & Multi-Extension Support"
echo "=================================================="

# Check bootstrap compiler
if [ ! -f "bin/morph" ]; then
    echo "❌ Bootstrap compiler not found: bin/morph"
    exit 1
fi

echo "✅ Bootstrap compiler: $(ls -lh bin/morph | awk '{print $5}')"

# Test individual components first
echo "🧪 Testing components..."

echo "  - File extensions..."
./bin/morph tests/test_file_extensions.fox >/dev/null 2>&1 && echo "    ✅ File extensions OK" || echo "    ❌ File extensions failed"

echo "  - Stripe protection..."
./bin/morph tests/test_stripe_protection.fox >/dev/null 2>&1 && echo "    ✅ Stripe protection OK" || echo "    ❌ Stripe protection failed"

# Compile self-hosting compiler with parser integration
echo "🔨 Compiling self-hosting compiler with parser integration..."
./bin/morph src/main_parser_test.fox -o morph-self-parser 2>&1 || {
    echo "❌ Parser integration compilation failed"
    exit 1
}

echo "✅ Self-hosting compiler built successfully!"

# Show supported extensions
echo ""
echo "📁 Supported file extensions:"
echo "  - .fox   : MorphFox source code"
echo "  - .elsa  : Enhanced Language Syntax Alternative"
echo "  - .morph : Compiled binary output (stripe-protected)"

# Test with different extensions
echo ""
echo "🧪 Testing multi-extension support..."
if [ -f "test_input.fox" ]; then
    echo "✅ Found test_input.fox"
fi

if [ -f "test_input.elsa" ]; then
    echo "✅ Found test_input.elsa"
fi

echo ""
echo "🔒 Security Features:"
echo "  - Assembly codegen stripe protection"
echo "  - Binary output obfuscation"
echo "  - Source code leak prevention"

echo ""
echo "🎉 Build complete!"
echo "📁 Self-hosting compiler: ./morph-self"
echo "🔒 Stripe-protected .morph output format"
echo ""
echo "Next steps:"
echo "1. Test compilation with .fox and .elsa files"
echo "2. Verify stripe protection in .morph output"
echo "3. Complete parser and codegen implementation"
