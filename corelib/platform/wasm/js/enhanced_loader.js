/**
 * Enhanced MorphFox WASM Loader with Self-Host Compiler Integration
 * Supports direct MorphFox syntax compilation to DOM operations
 */

class MorphWasmLoader {
    constructor() {
        this.memory = null;
        this.instance = null;
        this.elements = new Map();
        this.nextId = 2; // ID 1 reserved for document.body
        this.compiler = null;
    }

    async load(wasmPath, morphSource) {
        console.log('[MorphLoader] Loading WASM module...');
        
        // Load WASM module
        const wasmModule = await WebAssembly.instantiateStreaming(
            fetch(wasmPath),
            this.createImports()
        );
        
        this.instance = wasmModule.instance;
        this.memory = this.instance.exports.memory;
        this.compiler = new MorphWasmCompiler(this.memory);
        
        console.log('[MorphLoader] WASM module loaded successfully');
        
        // Compile and execute MorphFox source
        return this.compileMorphSource(morphSource);
    }

    createImports() {
        return {
            env: {
                // System calls
                __sys_write: (fd, ptr, len) => this.sysWrite(fd, ptr, len),
                __sys_exit: (code) => this.sysExit(code),
                __sys_mmap: (addr, len, prot, flags, fd, offset) => this.sysMmap(len),
                
                // DOM operations
                __mf_dom_create: (tagPtr) => this.domCreate(tagPtr),
                __mf_dom_append: (parentId, childId) => this.domAppend(parentId, childId),
                __mf_dom_set_text: (elementId, textPtr) => this.domSetText(elementId, textPtr),
                __mf_dom_set_attr: (elementId, keyPtr, valuePtr) => this.domSetAttr(elementId, keyPtr, valuePtr),
                
                // Memory management
                mem_alloc: (size) => this.instance.exports.mem_alloc(size),
                mem_free: (ptr, size) => this.instance.exports.mem_free(ptr, size)
            }
        };
    }

    compileMorphSource(source) {
        console.log('[MorphLoader] Compiling MorphFox source...');
        console.log('Source:', source);
        
        // Parse MorphFox syntax directly
        const lines = source.trim().split('\n').map(line => line.trim()).filter(line => line);
        
        for (const line of lines) {
            this.executeMorphLine(line);
        }
        
        console.log('[MorphLoader] Compilation and execution complete');
    }

    executeMorphLine(line) {
        console.log('[MorphLoader] Executing:', line);
        
        // Parse MorphFox DOM function calls
        if (line.startsWith('__mf_dom_create(')) {
            const match = line.match(/__mf_dom_create\("([^"]+)"\)/);
            if (match) {
                const tagName = match[1];
                const elementId = this.domCreateDirect(tagName);
                console.log(`Created element ${tagName} with ID ${elementId}`);
                // Store last created element for chaining
                this.lastElementId = elementId;
            }
        }
        
        else if (line.startsWith('__mf_dom_set_text(')) {
            const match = line.match(/__mf_dom_set_text\("([^"]+)"\)/);
            if (match) {
                const text = match[1];
                if (this.lastElementId) {
                    this.domSetTextDirect(this.lastElementId, text);
                    console.log(`Set text "${text}" on element ${this.lastElementId}`);
                }
            }
        }
        
        else if (line.startsWith('__mf_dom_append(')) {
            const match = line.match(/__mf_dom_append\((\d+)\)/);
            if (match) {
                const parentId = parseInt(match[1]);
                if (this.lastElementId) {
                    this.domAppendDirect(parentId, this.lastElementId);
                    console.log(`Appended element ${this.lastElementId} to parent ${parentId}`);
                }
            }
        }
        
        // Parse HTML compilation
        else if (line.startsWith('html_compile(')) {
            const match = line.match(/html_compile\("([^"]+)"\)/);
            if (match) {
                const htmlSource = match[1].replace(/\\n/g, '\n');
                this.compileHtmlToDom(htmlSource);
            }
        }
        
        // Parse CSS styling
        else if (line.startsWith('css_apply(')) {
            const match = line.match(/css_apply\((\d+),\s*"([^"]+)"\)/);
            if (match) {
                const elementId = parseInt(match[1]);
                const cssText = match[2];
                this.applyCssStyles(elementId, cssText);
            }
        }
    }

    compileHtmlToDom(htmlSource) {
        console.log('[MorphLoader] Compiling HTML:', htmlSource);
        
        // Simple HTML parser for demo
        const parser = new DOMParser();
        const doc = parser.parseFromString(htmlSource, 'text/html');
        const body = doc.body;
        
        this.convertHtmlNodeToDom(body, 1); // Append to document.body (ID 1)
    }

    convertHtmlNodeToDom(htmlNode, parentId) {
        for (const child of htmlNode.children) {
            const elementId = this.domCreateDirect(child.tagName.toLowerCase());
            
            // Set text content
            if (child.textContent.trim()) {
                this.domSetTextDirect(elementId, child.textContent.trim());
            }
            
            // Set attributes
            for (const attr of child.attributes) {
                this.domSetAttrDirect(elementId, attr.name, attr.value);
            }
            
            // Append to parent
            this.domAppendDirect(parentId, elementId);
            
            // Process children recursively
            if (child.children.length > 0) {
                this.convertHtmlNodeToDom(child, elementId);
            }
        }
    }

    applyCssStyles(elementId, cssText) {
        const element = this.elements.get(elementId);
        if (element) {
            element.style.cssText = cssText;
            console.log(`Applied CSS "${cssText}" to element ${elementId}`);
        }
    }

    // System call implementations
    sysWrite(fd, ptr, len) {
        const str = this.readString(ptr, Number(len));
        console.log(`[Morph Output] ${str}`);
        return BigInt(len);
    }

    sysExit(code) {
        console.log(`[Morph] Process exited with code: ${code}`);
        return 0n;
    }

    sysMmap(len) {
        // Allocate memory through WASM
        const ptr = this.instance.exports.mem_alloc(BigInt(len));
        if (ptr === 0n) {
            console.error(`[MMAP] Allocation failed for size ${len}`);
            return -1n;
        }
        
        // Zero out allocated memory
        const mem = new Uint8Array(this.memory.buffer);
        const ptrNum = Number(ptr);
        for (let i = 0; i < len; i++) {
            mem[ptrNum + i] = 0;
        }
        
        console.log(`[MMAP] Allocated ${len} bytes at address ${ptr}`);
        return ptr;
    }

    // DOM operation implementations
    domCreate(tagPtr) {
        const tagName = this.readString(tagPtr);
        return this.domCreateDirect(tagName);
    }

    domCreateDirect(tagName) {
        const element = document.createElement(tagName);
        const id = this.nextId++;
        this.elements.set(id, element);
        console.log(`[DOM] Created ${tagName} element with ID ${id}`);
        return BigInt(id);
    }

    domAppend(parentId, childId) {
        this.domAppendDirect(Number(parentId), Number(childId));
    }

    domAppendDirect(parentId, childId) {
        const parent = parentId === 1 ? document.body : this.elements.get(parentId);
        const child = this.elements.get(childId);
        
        if (parent && child) {
            parent.appendChild(child);
            console.log(`[DOM] Appended element ${childId} to ${parentId === 1 ? 'body' : parentId}`);
        } else {
            console.error(`[DOM] Append failed: parent=${parentId}, child=${childId}`);
        }
    }

    domSetText(elementId, textPtr) {
        const text = this.readString(textPtr);
        this.domSetTextDirect(Number(elementId), text);
    }

    domSetTextDirect(elementId, text) {
        const element = this.elements.get(elementId);
        if (element) {
            element.textContent = text;
            console.log(`[DOM] Set text "${text}" on element ${elementId}`);
        } else {
            console.error(`[DOM] SetText failed: element ${elementId} not found`);
        }
    }

    domSetAttr(elementId, keyPtr, valuePtr) {
        const key = this.readString(keyPtr);
        const value = this.readString(valuePtr);
        this.domSetAttrDirect(Number(elementId), key, value);
    }

    domSetAttrDirect(elementId, key, value) {
        const element = this.elements.get(elementId);
        if (element) {
            element.setAttribute(key, value);
            console.log(`[DOM] Set attribute ${key}="${value}" on element ${elementId}`);
        } else {
            console.error(`[DOM] SetAttr failed: element ${elementId} not found`);
        }
    }

    // Utility functions
    readString(ptr, maxLen = null) {
        if (!this.memory) return "";
        const mem = new Uint8Array(this.memory.buffer);
        let end = Number(ptr);
        
        if (maxLen !== null) {
            end = Math.min(end + maxLen, mem.length);
            return new TextDecoder().decode(mem.subarray(Number(ptr), end));
        }
        
        while (end < mem.length && mem[end] !== 0) end++;
        return new TextDecoder().decode(mem.subarray(Number(ptr), end));
    }
}

// Enhanced compiler for MorphFox syntax
class MorphWasmCompiler {
    constructor(memory) {
        this.memory = memory;
    }

    compile(source) {
        console.log('[MorphWasmCompiler] Compiling source...');
        
        // Enhanced compilation with HTML/CSS support
        const lines = source.split('\n').map(line => line.trim()).filter(line => line);
        const operations = [];
        
        for (const line of lines) {
            if (line.startsWith('html_compile(')) {
                operations.push({ type: 'html_compile', line });
            } else if (line.startsWith('css_apply(')) {
                operations.push({ type: 'css_apply', line });
            } else if (line.startsWith('__mf_dom_')) {
                operations.push({ type: 'dom_op', line });
            }
        }
        
        return operations;
    }
}

// Export for global use
window.MorphWasmLoader = MorphWasmLoader;
