/**
 * Enhanced MorphFox WASM Loader with Self-Host Compiler Integration
 * Functional approach without 'this' - uses closures for state management
 */

function createEnhancedMorphLoader() {
    // --- Private State (Closures) ---
    let memory = null;
    let instance = null;
    const elements = new Map();
    let nextId = 2; // ID 1 reserved for document.body
    let lastElementId = null;

    // --- Utility Functions ---
    function readString(ptr, maxLen = null) {
        if (!memory) return "";
        const mem = new Uint8Array(memory.buffer);
        let end = Number(ptr);
        
        if (maxLen !== null) {
            end = Math.min(end + maxLen, mem.length);
            return new TextDecoder().decode(mem.subarray(Number(ptr), end));
        }
        
        while (end < mem.length && mem[end] !== 0) end++;
        return new TextDecoder().decode(mem.subarray(Number(ptr), end));
    }

    // --- System Call Implementations ---
    function sysWrite(fd, ptr, len) {
        const str = readString(ptr, Number(len));
        console.log(`[Morph Output] ${str}`);
        return BigInt(len);
    }

    function sysExit(code) {
        console.log(`[Morph] Process exited with code: ${code}`);
        return 0n;
    }

    function sysMmap(len) {
        const ptr = instance.exports.mem_alloc(BigInt(len));
        if (ptr === 0n) {
            console.error(`[MMAP] Allocation failed for size ${len}`);
            return -1n;
        }
        
        // Zero out allocated memory
        const mem = new Uint8Array(memory.buffer);
        const ptrNum = Number(ptr);
        for (let i = 0; i < len; i++) {
            mem[ptrNum + i] = 0;
        }
        
        console.log(`[MMAP] Allocated ${len} bytes at address ${ptr}`);
        return ptr;
    }

    // --- DOM Operations ---
    function domCreateDirect(tagName) {
        const element = document.createElement(tagName);
        const id = nextId++;
        elements.set(id, element);
        console.log(`[DOM] Created ${tagName} element with ID ${id}`);
        return id;
    }

    function domCreate(tagPtr) {
        const tagName = readString(tagPtr);
        return BigInt(domCreateDirect(tagName));
    }

    function domAppendDirect(parentId, childId) {
        const parent = parentId === 1 ? document.body : elements.get(parentId);
        const child = elements.get(childId);
        
        if (parent && child) {
            parent.appendChild(child);
            console.log(`[DOM] Appended element ${childId} to ${parentId === 1 ? 'body' : parentId}`);
        } else {
            console.error(`[DOM] Append failed: parent=${parentId}, child=${childId}`);
        }
    }

    function domAppend(parentId, childId) {
        domAppendDirect(Number(parentId), Number(childId));
        return 0n;
    }

    function domSetTextDirect(elementId, text) {
        const element = elements.get(elementId);
        if (element) {
            element.textContent = text;
            console.log(`[DOM] Set text "${text}" on element ${elementId}`);
        } else {
            console.error(`[DOM] SetText failed: element ${elementId} not found`);
        }
    }

    function domSetText(elementId, textPtr) {
        const text = readString(textPtr);
        domSetTextDirect(Number(elementId), text);
        return 0n;
    }

    function domSetAttrDirect(elementId, key, value) {
        const element = elements.get(elementId);
        if (element) {
            element.setAttribute(key, value);
            console.log(`[DOM] Set attribute ${key}="${value}" on element ${elementId}`);
        } else {
            console.error(`[DOM] SetAttr failed: element ${elementId} not found`);
        }
    }

    function domSetAttr(elementId, keyPtr, valuePtr) {
        const key = readString(keyPtr);
        const value = readString(valuePtr);
        domSetAttrDirect(Number(elementId), key, value);
        return 0n;
    }

    // --- Import Object Creation ---
    function createImports() {
        return {
            env: {
                // System calls
                __sys_write: sysWrite,
                __sys_exit: sysExit,
                __sys_mmap: (addr, len, prot, flags, fd, offset) => sysMmap(len),
                
                // DOM operations
                __mf_dom_create: domCreate,
                __mf_dom_append: domAppend,
                __mf_dom_set_text: domSetText,
                __mf_dom_set_attr: domSetAttr,
                
                // Memory management
                mem_alloc: (size) => instance.exports.mem_alloc(size),
                mem_free: (ptr, size) => instance.exports.mem_free(ptr, size)
            }
        };
    }

    // --- MorphFox Syntax Execution ---
    function executeMorphLine(line) {
        console.log('[MorphLoader] Executing:', line);
        
        // Parse MorphFox DOM function calls
        if (line.startsWith('__mf_dom_create(')) {
            const match = line.match(/__mf_dom_create\("([^"]+)"\)/);
            if (match) {
                const tagName = match[1];
                const elementId = domCreateDirect(tagName);
                console.log(`Created element ${tagName} with ID ${elementId}`);
                lastElementId = elementId;
            }
        }
        
        else if (line.startsWith('__mf_dom_set_text(')) {
            const match = line.match(/__mf_dom_set_text\("([^"]+)"\)/);
            if (match) {
                const text = match[1];
                if (lastElementId) {
                    domSetTextDirect(lastElementId, text);
                    console.log(`Set text "${text}" on element ${lastElementId}`);
                }
            }
        }
        
        else if (line.startsWith('__mf_dom_append(')) {
            const match = line.match(/__mf_dom_append\((\d+)\)/);
            if (match) {
                const parentId = parseInt(match[1]);
                if (lastElementId) {
                    domAppendDirect(parentId, lastElementId);
                    console.log(`Appended element ${lastElementId} to parent ${parentId}`);
                }
            }
        }
        
        // Parse HTML compilation
        else if (line.startsWith('html_compile(')) {
            const match = line.match(/html_compile\("([^"]+)"\)/);
            if (match) {
                const htmlSource = match[1].replace(/\\n/g, '\n');
                compileHtmlToDom(htmlSource);
            }
        }
        
        // Parse CSS styling
        else if (line.startsWith('css_apply(')) {
            const match = line.match(/css_apply\((\d+),\s*"([^"]+)"\)/);
            if (match) {
                const elementId = parseInt(match[1]);
                const cssText = match[2];
                applyCssStyles(elementId, cssText);
            }
        }
    }

    function compileMorphSource(source) {
        console.log('[MorphLoader] Compiling MorphFox source...');
        console.log('Source:', source);
        
        const lines = source.trim().split('\n').map(line => line.trim()).filter(line => line);
        
        for (const line of lines) {
            executeMorphLine(line);
        }
        
        console.log('[MorphLoader] Compilation and execution complete');
    }

    // --- HTML/CSS Processing ---
    function compileHtmlToDom(htmlSource) {
        console.log('[MorphLoader] Compiling HTML:', htmlSource);
        
        const parser = new DOMParser();
        const doc = parser.parseFromString(htmlSource, 'text/html');
        const body = doc.body;
        
        convertHtmlNodeToDom(body, 1); // Append to document.body (ID 1)
    }

    function convertHtmlNodeToDom(htmlNode, parentId) {
        for (const child of htmlNode.children) {
            const elementId = domCreateDirect(child.tagName.toLowerCase());
            
            // Set text content
            if (child.textContent.trim()) {
                domSetTextDirect(elementId, child.textContent.trim());
            }
            
            // Set attributes
            for (const attr of child.attributes) {
                domSetAttrDirect(elementId, attr.name, attr.value);
            }
            
            // Append to parent
            domAppendDirect(parentId, elementId);
            
            // Process children recursively
            if (child.children.length > 0) {
                convertHtmlNodeToDom(child, elementId);
            }
        }
    }

    function applyCssStyles(elementId, cssText) {
        const element = elements.get(elementId);
        if (element) {
            element.style.cssText = cssText;
            console.log(`Applied CSS "${cssText}" to element ${elementId}`);
        }
    }

    // --- Public API ---
    async function load(wasmPath, morphSource) {
        console.log('[MorphLoader] Loading WASM module...');
        
        // Load WASM module
        const wasmModule = await WebAssembly.instantiateStreaming(
            fetch(wasmPath),
            createImports()
        );
        
        instance = wasmModule.instance;
        memory = instance.exports.memory;
        
        console.log('[MorphLoader] WASM module loaded successfully');
        
        // Compile and execute MorphFox source
        return compileMorphSource(morphSource);
    }

    // Return public interface
    return {
        load,
        compileMorphSource,
        domCreateDirect,
        domAppendDirect,
        domSetTextDirect,
        domSetAttrDirect,
        applyCssStyles
    };
}

// Enhanced compiler factory (functional)
function createMorphCompiler(memory) {
    function compile(source) {
        console.log('[MorphWasmCompiler] Compiling source...');
        
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

    return { compile };
}

// Export factories
window.createEnhancedMorphLoader = createEnhancedMorphLoader;
window.createMorphCompiler = createMorphCompiler;
