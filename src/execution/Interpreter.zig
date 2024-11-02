/// Executes bytecode, using driver to resolve classes and methods.
const std = @import("std");
const cl = @import("../class-loading/root.zig");
const RawClassFile = cl.RawClassFile;
const ClassLoader = cl.ClassLoader;
const Class = @import("rt/Class.zig");
const Object = @import("rt/Object.zig");
const Heap = @import("rt/Heap.zig");
const string = @import("string.zig");
const Array = @import("rt/Array.zig");
const decoder = @import("decoder.zig");
const u = @import("../common.zig");
const Instr = decoder.Instr;

const Self = @This();

pub threadlocal var current: *Self = undefined;

vm_alloc: std.mem.Allocator,
vm_stack_alloc: std.mem.Allocator, // for alloc and free inside vm, that correspond to good bracket sequence
heap_alloc: std.mem.Allocator,
class_loader: *ClassLoader,
call_stack: std.BoundedArray(MethodFrame, METHODS_STACK_LIMIT), // TODO: Replace with list for unlimited stack

pub const METHODS_STACK_LIMIT = 1024; // measured in function calls

const MethodFrame = struct {
    locals: []u.Value,
    locals_is_ref: std.DynamicBitSet, // for ref-counting GC
    op_stack: std.ArrayList(u.Value),
    op_stack_is_ref: std.BitStack, // for ref-counting GC
    code: []const u8,
    pc: usize,
    current_class: *Class,
    this: Heap.Ref(Object), // dynamic type of this object
    method_info: RawClassFile.MethodInfo, // for debugging

    // Works only for bytecode methods
    pub fn initBytecodeMethod(allocator: std.mem.Allocator, this: Heap.Ref(Object), resolved_method: Class.ResolvedMethod) !MethodFrame {
        const code = resolved_method.code.?;
        const locals = try allocator.alloc(u.Value, code.max_locals);
        @memset(locals, .{ .undefined = .{} });
        errdefer allocator.free(locals);

        var locals_is_ref = try std.DynamicBitSet.initEmpty(allocator, code.max_locals);
        errdefer locals_is_ref.deinit();

        const op_stack = try std.ArrayList(u.Value).initCapacity(allocator, code.max_stack);
        errdefer op_stack.deinit();

        var op_stack_is_ref = std.BitStack.init(allocator);
        try op_stack_is_ref.ensureTotalCapacity(code.max_stack);
        errdefer op_stack_is_ref.deinit();

        std.log.debug("\tmethod with max_stack {d} and max_locals {d} and code {}", .{ code.max_stack, code.max_locals, std.json.fmt(code.code, .{}) });

        return MethodFrame{
            .locals = locals,
            .locals_is_ref = locals_is_ref,
            .op_stack = op_stack,
            .op_stack_is_ref = op_stack_is_ref,
            .code = code.code,
            .pc = 0,
            .current_class = resolved_method.class,
            .this = this.clone(),
            .method_info = resolved_method.class.class_file.methods[resolved_method.method_id],
        };
    }

    pub fn dumpOpStack(self: *MethodFrame) void {
        std.log.debug("\tOpStack:", .{});
        self.dumpOpStackImpl();
    }

    fn dumpOpStackImpl(self: *MethodFrame) void {
        // for (self.op_stack.items) |item| {
        //     std.log.debug("\t\t{any}", .{item});
        // }

        // dump only top 1 element
        if (self.op_stack.items.len == 0) {
            return;
        }
        if (self.op_stack_is_ref.peek() == 1) {
            switch (self.op_stack.getLast().reference) {
                .array => |arr| if (arr.isNull()) {
                    std.log.debug("\t\tarr: null", .{});
                } else {
                    std.log.debug("\t\tarr: {any}", .{arr.ptr().?.items});
                },
                .object => |object| if (object.blk) |blk| {
                    std.log.debug("\t\tobject: {s}", .{blk.value.class.class_file.this_class});
                } else {
                    std.log.debug("\t\tobject: null", .{});
                },
            }
        } else {
            std.log.debug("\t\t{any}", .{self.op_stack.getLast()});
        }
        const top = self.op_stack.pop();
        const is_ref = self.op_stack_is_ref.pop();
        self.dumpOpStackImpl();
        self.op_stack.append(top) catch unreachable;
        self.op_stack_is_ref.push(is_ref) catch unreachable;
    }

    pub fn dumpLocals(self: *MethodFrame) void {
        std.log.debug("\tLocals:", .{});
        for (self.locals, 0..self.locals.len) |local, i| {
            if (self.locals_is_ref.isSet(i)) {
                switch (local.reference) {
                    .array => |arr| if (arr.isNull()) {
                        std.log.debug("\t\tarr: null", .{});
                    } else {
                        std.log.debug("\t\tarr: {any}", .{arr.ptr().?.items});
                    },
                    .object => |class| if (class.blk) |blk| {
                        std.log.debug("\t\tobject: {s}", .{blk.value.class.class_file.this_class});
                    } else {
                        std.log.debug("\t\tobject: null", .{});
                    },
                }
            } else {
                std.log.debug("\t\t{any}", .{local});
            }
        }
    }

    // save on method frames size a bit, if pass allocator from above. anyway, only one allocator is used for that
    pub fn deinit(self: *MethodFrame, allocator: std.mem.Allocator) void {
        // deinit in backward order, to make allocation/deallocation much easier, because of stack-like nature
        // TODO: LEAK: walk througn references and deinit them too, for GC to work

        // GC
        var it = self.locals_is_ref.iterator(.{ .direction = .forward, .kind = .set });
        while (it.next()) |index| {
            self.locals[index].reference.deinit();
        }

        // GC
        std.debug.assert(self.op_stack.items.len == self.op_stack_is_ref.bit_len);
        while (self.op_stack_is_ref.bit_len != 0) {
            const current_value = self.op_stack.pop();
            const is_ref = self.op_stack_is_ref.pop();
            if (is_ref == 1) {
                current_value.reference.deinit();
            }
        }

        self.op_stack_is_ref.deinit();
        self.op_stack.deinit();
        self.locals_is_ref.deinit();
        allocator.free(self.locals);
        self.this.deinit();
    }

    fn verify(self: *MethodFrame) void {
        std.debug.assert(self.locals.len == self.locals_is_ref.capacity());
        std.debug.assert(self.op_stack.items.len == self.op_stack_is_ref.bit_len);
    }

    pub fn pushValue(self: *MethodFrame, value: u.Value, comptime opts: enum { ref, nonref }) void {
        self.op_stack.append(value) catch unreachable;
        self.op_stack_is_ref.push(if (opts == .ref) 1 else 0) catch unreachable;
    }

    pub fn popValue(self: *MethodFrame) u.Value {
        const value = self.op_stack.pop();
        _ = self.op_stack_is_ref.pop();
        return value;
    }

    pub fn moveToLocal(self: *MethodFrame, idx: u32, value: u.Value, comptime opts: enum { ref, nonref }) void {
        if (self.locals_is_ref.isSet(idx)) {
            self.locals[idx].reference.deinit();
        }
        self.locals[idx] = value;
        if (opts == .ref) {
            self.locals_is_ref.set(idx);
        } else {
            self.locals_is_ref.unset(idx);
        }
    }
};

pub fn init(vm_alloc: std.mem.Allocator, heap_alloc: std.mem.Allocator, class_loader: *ClassLoader) Self {
    return Self{
        .vm_alloc = vm_alloc,
        .vm_stack_alloc = vm_alloc, // TODO: Replace with bucketed-FixedSizeAllocator for stacks
        .heap_alloc = heap_alloc,
        .class_loader = class_loader,
        .call_stack = std.BoundedArray(MethodFrame, METHODS_STACK_LIMIT).init(0) catch unreachable,
    };
}

// just saves current interpreter options into thread-local storage
pub fn attachToThread(self: *Self) void {
    current = self;
    Heap.allocator = self.heap_alloc;
}

pub fn deinit(self: *Self) void {
    while (self.call_stack.len != 0) {
        var frame = self.call_stack.pop();
        frame.deinit(self.vm_stack_alloc);
    }
}

// TODO: Eliminate allocations. They spread errors over calling code
fn enterMethod(self: *Self, this: Heap.Ref(Object), resolved_method: Class.ResolvedMethod) !*MethodFrame {
    std.log.debug("Entering method {s}.{s} this:{any}", .{ resolved_method.class.class_file.this_class, resolved_method.info.name, this });
    if (resolved_method.info.access_flags.native) {
        @import("../NativeStorage.zig").findMethod(resolved_method.class.class_file.this_class, resolved_method.info.name, resolved_method.info.descriptor);

        if (std.mem.eql(u8, resolved_method.info.name, "registerNatives")) {
            return &self.call_stack.buffer[self.call_stack.len - 1];
        }
        std.debug.panic("Native method call not supported yet: {s} {s}", .{ resolved_method.class.class_file.this_class, std.json.fmt(resolved_method.info, .{}) });
    }
    if (resolved_method.info.access_flags.abstract) {
        std.debug.panic("Abstract method called: {s}.{s}", .{ resolved_method.class.class_file.this_class, resolved_method.info.name });
    }

    const frameptr = self.call_stack.addOne() catch unreachable;
    frameptr.* = try MethodFrame.initBytecodeMethod(self.vm_stack_alloc, this, resolved_method);
    return frameptr;
}

fn leaveMethod(self: *Self) ?*MethodFrame { // returns the next frame
    var top = self.call_stack.pop();
    std.log.debug("Popping method frame {s}.{s}", .{ top.current_class.class_file.this_class, top.method_info.name });
    top.deinit(self.vm_stack_alloc);
    if (self.call_stack.len == 0) {
        std.log.info("Interpreter finished execution", .{});
        return null;
    }
    return &self.call_stack.buffer[self.call_stack.len - 1];
}

// binary comparison
fn interpretICmpBin(frame: *MethodFrame, instr: anytype, sz: u32) void {
    const InstrType = @TypeOf(instr);
    const b = frame.popValue().int;
    const a = frame.popValue().int;
    if (InstrType.cmp(a, b)) {
        frame.pc = @intCast(@as(i32, @intCast(frame.pc)) + instr.offset);
    } else {
        frame.pc += sz;
    }
}

// unary comparison
fn interpretICmpUn(frame: *MethodFrame, instr: anytype, sz: u32) void {
    const InstrType = @TypeOf(instr);
    const val = frame.popValue().int;
    if (InstrType.cmp(val)) {
        frame.pc += sz;
    } else {
        frame.pc = @intCast(@as(i32, @intCast(frame.pc)) + instr.offset);
    }
}

fn interpretICmpNull(frame: *MethodFrame, instr: anytype, sz: u32) void {
    const InstrType = @TypeOf(instr);
    const val = frame.popValue().reference;
    if (InstrType.cmp(val)) {
        frame.pc += sz;
    } else {
        frame.pc = @intCast(@as(i32, @intCast(frame.pc)) + instr.offset);
    }
    val.deinit(); // ref popped
}

// for non-reference types only
fn interpretBiOp(frame: *MethodFrame, instr: anytype, sz: u32) void {
    const InstrType = @TypeOf(instr);
    const b = @field(frame.popValue(), InstrType.ty); //frame.popValue();
    const a = @field(frame.popValue(), InstrType.ty); //frame.popValue();
    const value: u.Value = @unionInit(u.Value, InstrType.ty, InstrType.op(a, b));
    frame.pushValue(value, .nonref);
    frame.pc += sz;
}

fn interpretArrayStore(frame: *MethodFrame, instr: anytype, sz: u32) void {
    _ = instr;
    const value = frame.popValue();
    const index = frame.popValue().int;
    const array_ref = frame.popValue().reference.array;
    array_ref.ptr().?.items[@intCast(index)] = value;
    array_ref.deinit(); // ref popped
    frame.pc += sz;
}

fn interpretPutField(frame: *MethodFrame, instr: anytype, sz: u32) void {
    const value = frame.popValue();
    const obj = frame.popValue().reference.object;
    const field_id = frame.current_class.resolveConstantPoolEntry(instr.index).field.usual;
    // dump fields
    for (obj.ptr().?.fields) |field| {
        std.log.debug("\t\tfield: {any}", .{field});
    }
    const field_ptr = &obj.ptr().?.fields[field_id];
    if (field_ptr.ty == u.Ty.reference) {
        field_ptr.v.reference.deinit();
    }
    field_ptr.v = value;
    frame.pc += sz;
}

fn interpretGetField(frame: *MethodFrame, instr: anytype, sz: u32) void {
    const obj = frame.popValue().reference.object;
    const field_id = frame.current_class.resolveConstantPoolEntry(instr.index).field.usual;
    const field_ptr = &obj.ptr().?.fields[field_id];
    if (field_ptr.ty == u.Ty.reference) {
        frame.pushValue(.{ .reference = field_ptr.v.reference.clone() }, .ref);
    } else {
        frame.pushValue(field_ptr.v, .nonref);
    }
    frame.pc += sz;
}

pub fn runMethod(self: *Self, this: Heap.Ref(Object), resolved_method: Class.ResolvedMethod) !void {
    const initial_method = &resolved_method.class.class_file.methods[resolved_method.method_id];
    std.log.info("Push native stack method frame {s}.{s}", .{ resolved_method.class.class_file.this_class, initial_method.name });
    defer std.log.debug("Pop native stack method frame {s}.{s}", .{ resolved_method.class.class_file.this_class, initial_method.name });

    var frame: *MethodFrame = try self.enterMethod(this, resolved_method);
    var depth: u32 = 1;

    while (depth > 0) {
        frame.verify();
        // std.log.debug("frame_ptr: 0x{X} frame pc: {} code size: {}", .{ @intFromPtr(frame), frame.pc, frame.code.len });

        const decoded = decoder.decodeInstruction(frame.code[frame.pc..]);
        std.log.debug("🔥 instr: {} pc: {} depth: {}", .{ std.json.fmt(decoded.i, .{}), frame.pc, depth });
        frame.dumpLocals();
        frame.dumpOpStack();
        switch (decoded.i) {
            .aload => |instr| {
                frame.pushValue(.{ .reference = frame.locals[instr.index].reference.clone() }, .ref);
                frame.pc += decoded.sz;
            },
            .@"return" => {
                frame = self.leaveMethod() orelse return; // last frame popped => main finished
                depth -= 1;
            },
            .ireturn => {
                const value = frame.op_stack.pop();
                _ = frame.op_stack_is_ref.pop(); // passed to caller, so no need to deinit
                frame = self.leaveMethod() orelse return; // last frame popped => main finished
                depth -= 1;
                // here we have new frame
                frame.pushValue(value, .nonref);
            },
            .areturn => {
                const value = frame.op_stack.pop();
                _ = frame.op_stack_is_ref.pop(); // passed to caller, so no need to deinit
                frame = self.leaveMethod() orelse return; // last frame popped => main finished
                depth -= 1;
                // here we have new frame
                frame.pushValue(value, .ref);
            },
            .bipush => |instr| {
                frame.pushValue(.{ .int = @intCast(instr.value) }, .nonref);
                frame.pc += decoded.sz;
            },
            .sipush => |instr| {
                frame.pushValue(.{ .int = instr.value }, .nonref);
                frame.pc += decoded.sz;
            },
            .putstatic => |instr| {
                const value = frame.popValue();
                const field = frame.current_class.resolveConstantPoolEntry(instr.index).field.static;
                field.*.v = value;
                frame.pc += decoded.sz;
            },
            .getstatic => |instr| {
                const value = frame.current_class.resolveConstantPoolEntry(instr.index).field.static.*;
                if (value.ty == u.Ty.reference) {
                    frame.pushValue(value.v, .ref);
                } else {
                    frame.pushValue(value.v, .nonref);
                }
                frame.pc += decoded.sz;
            },
            .istore => |instr| {
                frame.moveToLocal(instr.index, frame.popValue(), .nonref);
                frame.pc += decoded.sz;
            },
            .iconst => |instr| {
                frame.pushValue(.{ .int = instr.value }, .nonref);
                frame.pc += decoded.sz;
            },
            .iload => |instr| {
                frame.pushValue(frame.locals[instr.index], .nonref);
                frame.pc += decoded.sz;
            },
            .iadd => |instr| interpretBiOp(frame, instr, decoded.sz),
            .isub => |instr| interpretBiOp(frame, instr, decoded.sz),
            .imul => |instr| interpretBiOp(frame, instr, decoded.sz),
            .idiv => |instr| interpretBiOp(frame, instr, decoded.sz),
            .dadd => |instr| interpretBiOp(frame, instr, decoded.sz),
            .dsub => |instr| interpretBiOp(frame, instr, decoded.sz),
            .dmul => |instr| interpretBiOp(frame, instr, decoded.sz),
            .ddiv => |instr| interpretBiOp(frame, instr, decoded.sz),
            .ishl => |instr| interpretBiOp(frame, instr, decoded.sz),
            .ishr => |instr| interpretBiOp(frame, instr, decoded.sz),
            .i2l => { // int to long with sign extension
                frame.pushValue(frame.popValue().cast(.int, .long), .nonref);
                frame.pc += decoded.sz;
            },
            .invokestatic => |instr| {
                frame.pc += decoded.sz;
                const prev_frame = frame;
                const method = frame.current_class.resolveConstantPoolEntry(instr.index).method;
                std.log.info("\xF0\x9F\x8C\x8F Call static method {s}.{s}", .{ method.class.class_file.this_class, method.class.class_file.methods[method.method_id].name });
                frame = try enterMethod(self, prev_frame.this, method);
                depth += if (prev_frame != frame) 1 else 0; // if we are in the same frame, then no need to increment depth
                // move arguments from stack to locals
                var total_slots: u32 = 0; // TODO: precalc
                for (method.args) |arg| {
                    total_slots += arg.slotsCount();
                }
                var locals_offset: u32 = 0;
                for (method.args) |arg| {
                    const this_local_offset = total_slots - locals_offset - arg.slotsCount();
                    frame.locals[this_local_offset] = prev_frame.op_stack.pop();
                    _ = prev_frame.op_stack_is_ref.pop(); // not touching it at all
                    if (arg == u.Ty.reference) {
                        frame.locals_is_ref.set(this_local_offset);
                    } else {
                        frame.locals_is_ref.unset(this_local_offset);
                    }
                    std.log.debug("\t\targ: {any}", .{frame.locals[this_local_offset]});
                    locals_offset += arg.slotsCount();
                }
            },
            // TODO: Unify with invokestatic. there is some duplication
            .invokespecial => |instr| {
                frame.pc += decoded.sz;
                const prev_frame = frame;
                const method = frame.current_class.resolveConstantPoolEntry(instr.index).method;
                std.log.info("\xF0\x9F\x8C\x95 Invoking special method {s}.{s} {s}", .{ method.class.class_file.this_class, method.class.class_file.methods[method.method_id].name, method.class.class_file.methods[method.method_id].descriptor });
                const new_this = prev_frame.op_stack.items[prev_frame.op_stack.items.len - 1 - method.args.len].reference.object.clone();
                frame = try enterMethod(self, new_this, method);
                depth += if (prev_frame != frame) 1 else 0; // if we are in the same frame, then no need to increment depth
                // move arguments from stack to locals
                var total_slots: u32 = 0; // TODO: precalc
                for (method.args) |arg| {
                    total_slots += arg.slotsCount();
                }
                var locals_offset: u32 = 0;
                for (method.args) |arg| {
                    const this_local_offset = total_slots - locals_offset - arg.slotsCount() + 1; // 1 for this
                    frame.locals[this_local_offset] = prev_frame.op_stack.pop();
                    _ = prev_frame.op_stack_is_ref.pop(); // not touching it at all
                    if (arg == u.Ty.reference) {
                        frame.locals_is_ref.set(this_local_offset);
                    } else {
                        frame.locals_is_ref.unset(this_local_offset);
                    }
                    std.log.debug("\t\targ: {any} put to locals {d}", .{ frame.locals[this_local_offset], this_local_offset });
                    locals_offset += arg.slotsCount();
                }

                frame.locals_is_ref.set(0); // this is always reference
                frame.locals[0] = prev_frame.popValue();
            },
            .invokevirtual => |instr| {
                frame.pc += decoded.sz;
                const prev_frame = frame;
                const method = frame.current_class.resolveConstantPoolEntry(instr.index).method;
                std.log.info("Call virtual method {s}.{s}", .{ method.class.class_file.this_class, method.class.class_file.methods[method.method_id].name });
                const new_this = prev_frame.op_stack.items[prev_frame.op_stack.items.len - 1 - method.args.len].reference.object.clone();
                frame = try enterMethod(self, new_this, method);
                depth += if (prev_frame != frame) 1 else 0; // if we are in the same frame, then no need to increment depth
                // move arguments from stack to locals
                var total_slots: u32 = 0; // TODO: precalc
                for (method.args) |arg| {
                    total_slots += arg.slotsCount();
                }
                var locals_offset: u32 = 0;
                for (method.args) |arg| {
                    const this_local_offset = total_slots - locals_offset - arg.slotsCount() + 1;
                    frame.locals[this_local_offset] = prev_frame.op_stack.pop();
                    _ = prev_frame.op_stack_is_ref.pop(); // not touching it at all
                    if (arg == u.Ty.reference) {
                        frame.locals_is_ref.set(this_local_offset);
                    } else {
                        frame.locals_is_ref.unset(this_local_offset);
                    }
                    std.log.debug("\t\targ: {any}", .{frame.locals[this_local_offset]});
                    locals_offset += arg.slotsCount();
                }

                frame.locals_is_ref.set(0); // this is always reference
                frame.locals[0] = prev_frame.popValue();
            },
            .if_icmp_ge => |instr| interpretICmpBin(frame, instr, decoded.sz),
            .if_icmp_eq => |instr| interpretICmpBin(frame, instr, decoded.sz),
            .if_icmp_ne => |instr| interpretICmpBin(frame, instr, decoded.sz),
            .if_icmp_lt => |instr| interpretICmpBin(frame, instr, decoded.sz),
            .if_icmp_le => |instr| interpretICmpBin(frame, instr, decoded.sz),
            .if_icmp_gt => |instr| interpretICmpBin(frame, instr, decoded.sz),
            .if_eq => |instr| interpretICmpUn(frame, instr, decoded.sz),
            .if_ne => |instr| interpretICmpUn(frame, instr, decoded.sz),
            .if_lt => |instr| interpretICmpUn(frame, instr, decoded.sz),
            .if_le => |instr| interpretICmpUn(frame, instr, decoded.sz),
            .if_gt => |instr| interpretICmpUn(frame, instr, decoded.sz),
            .if_ge => |instr| interpretICmpUn(frame, instr, decoded.sz),
            .if_null => |instr| interpretICmpNull(frame, instr, decoded.sz),
            .if_nonnull => |instr| interpretICmpNull(frame, instr, decoded.sz),
            .iinc => |instr| {
                std.debug.assert(!frame.locals_is_ref.isSet(instr.index));
                const val = frame.locals[instr.index].int;
                frame.locals[instr.index] = .{ .int = val +% instr.value };
                frame.pc += decoded.sz;
            },
            .goto => |instr| {
                frame.pc = @intCast(@as(isize, @intCast(frame.pc)) + instr.offset);
            },
            .ldc => |instr| {
                frame.pc += decoded.sz;
                const cp_info = frame.current_class.resolveConstantPoolEntry(instr.index);
                switch (cp_info) {
                    .value => |value| {
                        if (value.ty == u.Ty.reference) {
                            frame.pushValue(value.v, .ref);
                        } else {
                            frame.pushValue(value.v, .nonref);
                        }
                    },
                    .class => |class| {
                        const ref = Object.newJavaLangClassObject(class, self.heap_alloc) catch unreachable; // TODO: Recover with exception
                        frame.pushValue(.{ .reference = .{ .object = ref } }, .ref);
                    },
                    else => {
                        std.debug.panic("Unsupported constant pool entry for ldc: {}", .{cp_info});
                    },
                }
            },
            .astore => |instr| {
                frame.moveToLocal(instr.index, frame.popValue(), .ref);
                frame.pc += decoded.sz;
            },
            .castore => |instr| interpretArrayStore(frame, instr, decoded.sz),
            .iastore => |instr| interpretArrayStore(frame, instr, decoded.sz),
            .new => |instr| {
                frame.pc += decoded.sz;
                const class = frame.current_class.resolveConstantPoolEntry(instr.index).class;
                const object = Object.init(class, self.vm_alloc) catch unreachable; // TODO: Recover with exception
                const object_ref = Heap.Ref(Object).init(object) catch unreachable; // TODO: Recover with exception
                frame.pushValue(.{ .reference = .{ .object = object_ref } }, .ref);
            },
            .newarray => |instr| {
                frame.pc += decoded.sz;
                const count = frame.popValue().int;
                const atype = instr.atype;
                const array = Array.init(Heap.allocator, switch (atype) {
                    4 => u.Ty.boolean,
                    5 => u.Ty.char,
                    6 => u.Ty.float,
                    7 => u.Ty.double,
                    8 => u.Ty.byte,
                    9 => u.Ty.short,
                    10 => u.Ty.int,
                    11 => u.Ty.long,
                    else => std.debug.panic("Unsupported atype: {}", .{atype}),
                }, @intCast(count)) catch unreachable; // TODO: alloc error

                const ref = Heap.Ref(Array).init(array) catch unreachable; // TODO: alloc error
                frame.pushValue(.{ .reference = .{ .array = ref } }, .ref);
            },
            .anewarray => |instr| {
                frame.pc += decoded.sz;
                const count = frame.popValue().int;
                // TODO: Bake class ptr into array
                _ = instr;
                // const class = frame.current_class.resolveConstantPoolEntry(instr.index).class;
                const array = Array.init(Heap.allocator, u.Ty.reference, @intCast(count)) catch unreachable; // TODO: alloc error
                const ref = Heap.Ref(Array).init(array) catch unreachable; // TODO: alloc error
                frame.pushValue(.{ .reference = .{ .array = ref } }, .ref);
            },
            .dup => {
                const value = frame.op_stack.getLast();
                const is_ref = frame.op_stack_is_ref.peek();
                if (is_ref == 1) {
                    frame.op_stack.append(.{ .reference = value.reference.clone() }) catch unreachable;
                } else {
                    frame.op_stack.append(value) catch unreachable;
                }
                frame.op_stack_is_ref.push(is_ref) catch unreachable;
                frame.pc += decoded.sz;
            },
            .aconst_null => {
                frame.op_stack.append(.{ .reference = .{ .object = Heap.Ref(Object).initNull() } }) catch unreachable;
                frame.op_stack_is_ref.push(1) catch unreachable;
                frame.pc += decoded.sz;
            },
            .arraylength => {
                const array_ref = frame.popValue().reference.array;
                frame.pushValue(.{ .int = @intCast(array_ref.ptr().?.items.len) }, .nonref);
                array_ref.deinit(); // ref popped
                frame.pc += decoded.sz;
            },
            .iaload => {
                const index = frame.popValue().int;
                const array_ref = frame.popValue().reference.array;
                frame.pushValue(array_ref.ptr().?.items[@intCast(index)], .nonref);
                array_ref.deinit(); // ref popped
                frame.pc += decoded.sz;
            },
            .getfield => |instr| interpretGetField(frame, instr, decoded.sz),
            .putfield => |instr| interpretPutField(frame, instr, decoded.sz),
        }
    }

    return;
}
