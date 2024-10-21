/// Executes bytecode, using driver to resolve classes and methods.
const std = @import("std");
const RawClassFile = @import("../class-loading/root.zig").RawClassFile;
const Driver = @import("Driver.zig");
const Class = @import("rt/Class.zig");
const Object = @import("rt/Object.zig");
const Heap = @import("rt/Heap.zig");
const string = @import("string.zig");
const decoder = @import("decoder.zig");
const u = @import("../common.zig");
const Instr = decoder.Instr;

const Self = @This();

vm_alloc: std.mem.Allocator,
vm_stack_alloc: std.mem.Allocator, // for alloc and free inside vm, that correspond to good bracket sequence
call_stack: std.BoundedArray(MethodFrame, METHODS_STACK_LIMIT), // TODO: Replace with list for unlimited stack

pub const METHODS_STACK_LIMIT = 1024; // measured in function calls

const ThisObject = union(enum) {
    object: Heap.Ref(Object), // for dynamic methods
    class: *Class, // for static methods

    pub fn getClass(self: ThisObject) *Class {
        return switch (self) {
            .object => self.object.ptr().?.class,
            .class => self.class,
        };
    }

    pub fn tryClone(self: ThisObject) ThisObject {
        return switch (self) {
            .object => .{ .object = self.object.clone() },
            .class => self,
        };
    }

    pub fn deinit(self: ThisObject) void {
        switch (self) {
            .object => self.object.deinit(),
            .class => {},
        }
    }
};

const MethodFrame = struct {
    locals: []u.Value,
    locals_is_ref: std.DynamicBitSet, // for ref-counting GC
    op_stack: std.ArrayList(u.Value),
    op_stack_is_ref: std.BitStack, // for ref-counting GC
    code: []const u8,
    pc: usize,
    this: ThisObject,

    // Works only for bytecode methods
    pub fn initBytecodeMethod(allocator: std.mem.Allocator, this: ThisObject, method_id: u32) !MethodFrame {
        const code = this.getClass().getMethodCodeById(method_id).?;

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
            .this = this.tryClone(),
        };
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
};

pub fn init(vm_alloc: std.mem.Allocator) Self {
    return Self{
        .vm_alloc = vm_alloc,
        .vm_stack_alloc = vm_alloc, // TODO: Replace with bucketed-FixedSizeAllocator for stacks
        .call_stack = std.BoundedArray(MethodFrame, METHODS_STACK_LIMIT).init(0) catch unreachable,
    };
}

pub fn deinit(self: *Self) void {
    while (self.call_stack.len != 0) {
        var frame = self.call_stack.pop();
        frame.deinit(self.vm_stack_alloc);
    }
}

// TODO: Eliminate allocations. They spread errors over calling code
fn enterMethod(self: *Self, this: ThisObject, method_id: u32) !*MethodFrame {
    const method_info = this.getClass().getMethodInfoById(method_id);
    if (method_info.access_flags.native) {
        // @import("../NativeStorage.zig").findMethod(this.class.class_file.this_class, method_info.name, method_info.descriptor);
        std.debug.panic("Native method call not supported yet: {s} {s}", .{ this.class.class_file.this_class, std.json.fmt(method_info, .{}) });
    }
    if (method_info.access_flags.abstract) {
        std.debug.panic("Abstract method called: {s}.{s}", .{ this.class.class_file.this_class, method_info.name });
    }

    const frameptr = self.call_stack.addOne() catch unreachable;
    frameptr.* = try MethodFrame.initBytecodeMethod(self.vm_stack_alloc, this, method_id);
    return frameptr;
}

fn leaveMethod(self: *Self) ?*MethodFrame { // returns the next frame
    var top = self.call_stack.pop();
    top.deinit(self.vm_stack_alloc);
    if (self.call_stack.len == 0) {
        return null;
    }
    return &self.call_stack.buffer[self.call_stack.len - 1];
}

pub fn runMethod(self: *Self, driver: *Driver, this: ThisObject, initial_method_id: u32) !void {
    _ = driver; // TODO: Use for fetching new classes
    const initial_method = &this.getClass().class_file.methods[initial_method_id];
    std.log.info("Interpreter started method call {s}.{s}", .{ &this.getClass().class_file.this_class, initial_method.name });
    defer std.log.debug("Interpreter finished method call {s}.{s}", .{ this.getClass().class_file.this_class, initial_method.name });

    var frame: *MethodFrame = try self.enterMethod(this, initial_method_id);
    var depth: u32 = 1;

    while (depth > 0) {
        frame.verify();
        std.log.debug("\tframe_ptr: 0x{X} frame pc: {} code size: {}", .{ @intFromPtr(frame), frame.pc, frame.code.len });

        const decoded = decoder.decodeInstruction(frame.code[frame.pc..]);
        std.log.debug("\texecuting instr:{}", .{std.json.fmt(decoded.i, .{})});

        std.log.debug("\tlocals: {any}", .{frame.locals});
        std.log.debug("\top_stack: {any}", .{frame.op_stack.items});
        switch (decoded.i) {
            .aload => |instr| {
                frame.op_stack.append(frame.locals[instr.index]) catch unreachable;
                frame.op_stack_is_ref.push(@bitCast(frame.locals_is_ref.isSet(instr.index))) catch unreachable;
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
                frame.op_stack.append(value) catch unreachable;
                frame.op_stack_is_ref.push(0) catch unreachable;
            },
            .bipush => |instr| {
                frame.op_stack.append(.{ .int = @intCast(instr.value) }) catch unreachable;
                frame.op_stack_is_ref.push(0) catch unreachable;
                frame.pc += decoded.sz;
            },
            .sipush => |instr| {
                frame.op_stack.append(.{ .int = instr.value }) catch unreachable;
                frame.op_stack_is_ref.push(0) catch unreachable;
                frame.pc += decoded.sz;
            },
            .putstatic => |instr| {
                const value = frame.op_stack.pop();
                _ = frame.op_stack_is_ref.pop(); // passed to static field, so no need to deinit
                frame.this.getClass().cachedResolveConstantPoolEntry(instr.index).static_field.*.v = value;
                frame.pc += decoded.sz;
            },
            .getstatic => |instr| {
                const value = frame.this.getClass().cachedResolveConstantPoolEntry(instr.index).static_field.*;
                frame.op_stack.append(value.v) catch unreachable;
                frame.op_stack_is_ref.push(@bitCast(value.ty == u.Ty.reference)) catch unreachable;
                frame.pc += decoded.sz;
            },
            .istore => |instr| {
                frame.locals[instr.index] = frame.op_stack.pop();
                _ = frame.op_stack_is_ref.pop();
                frame.locals_is_ref.unset(instr.index);
                frame.pc += decoded.sz;
            },
            .iconst => |instr| {
                frame.op_stack.append(.{ .int = instr.value }) catch unreachable;
                frame.op_stack_is_ref.push(0) catch unreachable;
                frame.pc += decoded.sz;
            },
            .iload => |instr| {
                frame.op_stack.append(frame.locals[instr.index]) catch unreachable;
                frame.op_stack_is_ref.push(0) catch unreachable;
                frame.pc += decoded.sz;
            },
            .iadd => {
                const a = frame.op_stack.pop().int;
                const b = frame.op_stack.pop().int;
                frame.op_stack.append(.{ .int = a +% b }) catch unreachable;
                _ = frame.op_stack_is_ref.pop(); // optimization: no need to pop/push same value
                frame.pc += decoded.sz;
            },
            .imul => {
                const a = frame.op_stack.pop().int;
                const b = frame.op_stack.pop().int;
                frame.op_stack.append(.{ .int = a *% b }) catch unreachable;
                _ = frame.op_stack_is_ref.pop();
                frame.pc += decoded.sz;
            },
            .idiv => {
                const b = frame.op_stack.pop().int;
                const a = frame.op_stack.pop().int;
                // TODO: Check for division by zero and set exception
                if (b == -1) {
                    // Instructions 6.5 idiv
                    frame.op_stack.append(.{ .int = b }) catch unreachable;
                } else {
                    // for zig's @divTrunc -1 is UB
                    frame.op_stack.append(.{ .int = @divTrunc(a, b) }) catch unreachable;
                }
                _ = frame.op_stack_is_ref.pop(); // optimization: no need to pop/push same value
                frame.pc += decoded.sz;
            },
            .i2l => { // int to long with sign extension
                const value = frame.op_stack.pop();
                frame.op_stack.append(value.cast(.int, .long)) catch unreachable;
                frame.pc += decoded.sz;
            },
            .invokestatic => |instr| {
                frame.pc += decoded.sz;
                const prev_frame = frame;
                const method = frame.this.getClass().cachedResolveConstantPoolEntry(instr.index).method;
                frame = try enterMethod(self, .{ .class = method.class }, method.method_id);
                depth += 1;
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
            .if_icmp_ge => |instr| {
                const b = frame.op_stack.pop().int;
                const a = frame.op_stack.pop().int;
                _ = frame.op_stack_is_ref.pop();
                _ = frame.op_stack_is_ref.pop();
                if (a >= b) {
                    frame.pc = @intCast(@as(i32, @intCast(frame.pc)) + instr.offset);
                } else {
                    frame.pc += decoded.sz;
                }
            },
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
                const cp_info = frame.this.getClass().cachedResolveConstantPoolEntry(instr.index);
                switch (cp_info) {
                    .value => |value| {
                        frame.op_stack.append(value.v) catch unreachable;
                        frame.op_stack_is_ref.push(@bitCast(value.ty == u.Ty.reference)) catch unreachable;
                    },
                    else => {
                        std.debug.panic("Unsupported constant pool entry for ldc: {}", .{cp_info});
                    },
                }
            },
            .astore => |instr| {
                frame.locals[instr.index] = frame.op_stack.pop();
                const is_ref = frame.op_stack_is_ref.pop();
                if (is_ref == 1) {
                    frame.locals_is_ref.set(instr.index);
                } else {
                    frame.locals_is_ref.unset(instr.index);
                }
                frame.pc += decoded.sz;
            },
            .new => |instr| {
                frame.pc += decoded.sz;
                const class = frame.this.getClass().cachedResolveConstantPoolEntry(instr.index).class;
                const object = Object.init(class, self.vm_alloc) catch unreachable; // TODO: Recover with exception
                const object_ref = Heap.Ref(Object).init(object) catch unreachable; // TODO: Recover with exception
                frame.op_stack.append(.{ .reference = .{ .class = object_ref } }) catch unreachable;
                frame.op_stack_is_ref.push(1) catch unreachable;
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
        }
    }

    return;
}
