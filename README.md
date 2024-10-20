# JVM Implementation in Zig

This is a pet project that implements a JVM (Java Virtual Machine) in Zig. It is not guaranteed to work and is under active development. Use at your own risk.


## Project Overview

### Class Loader

The class loader provides "raw" class files with minimal resolution of constant pool fields. It acts as a simple parser that converts Java .class files into a machine-readable structure. The loader does not perform extensive linking or initialization; it simply makes the class file available for use by the runtime.

### Decoder

The decoder is responsible for decoding individual JVM bytecode instructions. It converts raw bytes into a structured format that is easier to work with for the interpreter. This abstraction simplifies the process of handling JVM instructions during execution.

### Interpreter

The interpreter is the core of the JVM. It describes how each JVM instruction is executed and manages the call stack. Currently, the interpreter is single-threaded, though it is meant to be thread-local in the future once threading support is implemented.

### Driver

The driver represents the entire state of the JVM. It manages both the class loader and the interpreter. The interpreter communicates with the driver to resolve classes and manage execution flow.

### String Handling

The string.zig file is a placeholder for what will eventually become the string pool. For now, it contains a single function responsible for creating java.lang.String objects from UTF-8 byte slices (and idk if I'm doing this in correct way).

### Runtime Entities (`rt`)

The rt (runtime) folder contains entities that exist at runtime:

- Class: A runtime representation of a Java class. It owns the raw class file data.
- Object: A runtime object, currently holding fields only. In the future, it will support monitors and other JVM object-related features.
- Array: A runtime representation of Java arrays, distinct from the Class entity.
- Heap: A global (or rather thread-local) memory allocator and reference-counting system for managing objects and arrays.

### Common Structures

The common.zig file defines important types used across the JVM, such as Ty, Value, and TyValue:

- Ty: An enum representing the type of any JVM value.
- Value: An untagged union used for the operand stack and other places where JVM values are stored.
- TyValue: A pair of type (Ty) and value (Value), used in places where both the type and value of an operand need to be known explicitly.

### Reference Counting

The JVM uses a combination of BitStack (for operand stacks) and DynamicBitSet (for local variables) to track whether values are reference-counted. If a value is reference-counted, the reference count is decremented when it is removed from the stack or local variables. Same happens inside of Object and Array.

## Future Plans

This goes in order:
- Function calls
- Exceptions support (better do it quicker, while I can)
- More opcodes
- Native method calls (and JNI)
- Threads

## Build and Run

> Requirements: For now, only the hardcoded absolute paths will be scanned for this class name. Add your one to main.zig.

To build the project, ensure you have Zig (version 0.13.0) installed, then run:

```bash
zig build
```
To execute a Java class using the JVM:

```bash
zig build -Doptimize=ReleaseSafe run -- name/of/the/Class
```

## Contribution

This is a personal project and is not guaranteed to be stable or complete. Contributions are welcome, but please be aware of its experimental nature.