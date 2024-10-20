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
            .object => self.object.ptr().class,
            .class => self.class,
        };
    }
};

const MethodFrame = struct {
    locals: []u.Value,
    op_stack: std.ArrayList(u.Value),
    code: []const u8,
    pc: usize,
    this: ThisObject,

    // Works only for bytecode methods
    pub fn initBytecodeMethod(allocator: std.mem.Allocator, this: ThisObject, method_id: u32) !MethodFrame {
        const code = this.getClass().getMethodCodeById(method_id).?;

        const locals = try allocator.alloc(u.Value, code.max_locals);
        errdefer allocator.free(locals);
        const op_stack = try std.ArrayList(u.Value).initCapacity(allocator, code.max_stack);
        errdefer op_stack.deinit();

        std.log.debug("\tmethod with max_stack {d} and max_locals {d} and code {}", .{ code.max_stack, code.max_locals, std.json.fmt(code.code, .{}) });

        // TODO: Increment reference count for this object
        return MethodFrame{
            .locals = locals,
            .op_stack = op_stack,
            .code = code.code,
            .pc = 0,
            .this = this,
        };
    }

    // save on method frames size a bit, if pass allocator from above. anyway, only one allocator is used for that
    pub fn deinit(self: MethodFrame, allocator: std.mem.Allocator) void {
        // deinit in backward order, to make allocation/deallocation much easier, because of stack-like nature
        // TODO: LEAK: walk througn references and deinit them too, for GC to work
        self.op_stack.deinit();
        allocator.free(self.locals);
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
        self.call_stack.pop().deinit(self.vm_stack_alloc);
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
    const top = self.call_stack.pop();
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

    var frame_opt: ?*MethodFrame = try self.enterMethod(this, initial_method_id);

    while (frame_opt != null and frame_opt.?.pc < frame_opt.?.code.len) {
        const frame = frame_opt.?;
        std.log.debug("\tframe pc: {} code size: {}", .{ frame.pc, frame.code.len });

        const decoded = decoder.decodeInstruction(frame.code[frame.pc..]);
        std.log.debug("\texecuting instr:{}", .{std.json.fmt(decoded.i, .{})});

        switch (decoded.i) {
            .aload => |instr| {
                frame.op_stack.append(frame.locals[instr.index]) catch unreachable;
                frame.pc += decoded.sz;
            },
            .@"return" => {
                frame_opt = self.leaveMethod();
            },
            .bipush => |instr| {
                frame.op_stack.append(.{ .int = @intCast(instr.value) }) catch unreachable;
                frame.pc += decoded.sz;
            },
            .sipush => |instr| {
                frame.op_stack.append(.{ .int = instr.value }) catch unreachable;
                frame.pc += decoded.sz;
            },
            .putstatic => |instr| {
                const value = frame.op_stack.pop();
                frame.this.getClass().cachedResolveConstantPoolEntry(instr.index).static_field.* = value;
                frame.pc += decoded.sz;
            },
            .getstatic => |instr| {
                const value = frame.this.getClass().cachedResolveConstantPoolEntry(instr.index).static_field.*;
                frame.op_stack.append(value) catch unreachable;
                frame.pc += decoded.sz;
            },
            .istore => |instr| {
                frame.locals[instr.index] = frame.op_stack.pop();
                frame.pc += decoded.sz;
            },
            .iconst => |instr| {
                frame.op_stack.append(.{ .int = instr.value }) catch unreachable;
                frame.pc += decoded.sz;
            },
            .iload => |instr| {
                frame.op_stack.append(frame.locals[instr.index]) catch unreachable;
                frame.pc += decoded.sz;
            },
            .iadd => {
                const a = frame.op_stack.pop().int;
                const b = frame.op_stack.pop().int;
                frame.op_stack.append(.{ .int = a +% b }) catch unreachable;
                frame.pc += decoded.sz;
            },
            .i2l => { // int to long with sign extension
                const value = frame.op_stack.pop();
                frame.op_stack.append(value.cast(.int, .long)) catch unreachable;
                frame.pc += decoded.sz;
            },
            .invokestatic => |instr| {
                const method = frame.this.getClass().cachedResolveConstantPoolEntry(instr.index).method;
                frame_opt = try enterMethod(self, .{ .class = method.class }, method.method_id);
                frame.pc += decoded.sz;
            },
            .if_icmp_ge => |instr| {
                const b = frame.op_stack.pop().int;
                const a = frame.op_stack.pop().int;
                if (a >= b) {
                    frame.pc = @intCast(@as(i32, @intCast(frame.pc)) + instr.offset);
                } else {
                    frame.pc += decoded.sz;
                }
            },
            .iinc => |instr| {
                const val = frame.locals[instr.index].int;
                frame.locals[instr.index] = .{ .int = val +% instr.value };
                frame.pc += decoded.sz;
            },
            .goto => |instr| {
                frame.pc = @intCast(@as(isize, @intCast(frame.pc)) + instr.offset);
            },
            .ldc => |instr| {
                const cp_info = frame.this.getClass().cachedResolveConstantPoolEntry(instr.index);
                switch (cp_info) {
                    .value => |value| {
                        frame.op_stack.append(value) catch unreachable;
                    },
                    else => {
                        std.debug.panic("Unsupported constant pool entry for ldc: {}", .{cp_info});
                    },
                }
                frame.pc += decoded.sz;
            },
        }
    }

    std.log.debug("Interpreter finished method call {s}.{s}", .{ this.getClass().class_file.this_class, initial_method.name });
    return;
}
