/// Executes bytecode, using driver to resolve classes and methods.
const std = @import("std");
const RawClassFile = @import("../class-loading/root.zig").RawClassFile;
const Driver = @import("Driver.zig");
const Class = @import("rt/Class.zig");
const decoder = @import("decoder.zig");

const Instr = decoder.Instr;
const Self = @This();

allocator: std.mem.Allocator,
methods_call_stack: Stack(MethodFrame, METHODS_STACK_LIMIT),
exec_stack: Stack(u32, EXECUTION_STACK_LIMIT), // TODO: Maybe this stack should be local to the method

pub const METHODS_STACK_LIMIT = 1024; // measured in function calls
pub const EXECUTION_STACK_LIMIT = 1024; // measured in values

const MethodFrame = struct {
    locals: []u32,
    code: []const u8,
    pc: usize,
    this: *Class,
};

fn Stack(comptime T: type, comptime N: usize) type {
    return struct {
        data: [N]T = undefined,
        size: usize = 0,

        const StackSelf = @This();

        pub fn push(self: *StackSelf, value: T) void {
            std.debug.assert(self.size < N);
            self.data[self.size] = value;
            self.size += 1;
        }

        pub fn pop(self: *StackSelf) T {
            std.debug.assert(self.size != 0);
            self.size -= 1;
            return self.data[self.size];
        }

        pub fn empty(self: *StackSelf) bool {
            return self.size == 0;
        }

        pub fn top(self: *StackSelf) *T {
            std.debug.assert(self.size != 0);
            return &self.data[self.size - 1];
        }
    };
}

pub fn init(allocator: std.mem.Allocator) Self {
    return Self{
        .allocator = allocator,
        .methods_call_stack = Stack(MethodFrame, METHODS_STACK_LIMIT){},
        .exec_stack = Stack(u32, EXECUTION_STACK_LIMIT){},
    };
}

pub fn deinit(self: *Self) void {
    while (!self.methods_call_stack.empty()) {
        _ = self.leaveMethod();
    }

    while (!self.exec_stack.empty()) {
        _ = self.exec_stack.pop();
    }
}

// TODO: Eliminate allocations. They spread errors over calling code
fn enterMethod(self: *Self, class: *Class, method_id: u32) !*MethodFrame {
    const method_info = class.get_method_info(method_id);
    if (method_info.access_flags.native) {
        std.debug.panic("Native method call not supported yet: {s} {s}", .{ class.class_file.this_class, std.json.fmt(method_info, .{}) });
    }
    if (method_info.access_flags.abstract) {
        std.debug.panic("Abstract method called: {s}.{s}", .{ class.class_file.this_class, method_info.name });
    }

    const code = class.get_method_code(method_id) catch {
        std.debug.panic("Failed to get method code for class {s} method {}", .{ class.class_file.this_class, method_id });
    };
    self.methods_call_stack.push(MethodFrame{
        .locals = try self.allocator.alloc(u32, code.max_locals),
        .code = code.code,
        .pc = 0,
        .this = class,
    });
    const frameptr = self.methods_call_stack.top();
    std.log.debug("\tmethod with max_stack {d} and max_locals {d} and frameptr 0x{x} and code {}", .{ code.max_stack, code.max_locals, @intFromPtr(frameptr), std.json.fmt(code.code, .{}) });
    return frameptr;
}

fn leaveMethod(self: *Self) ?*MethodFrame { // returns the next frame
    const top = self.methods_call_stack.pop();
    self.allocator.free(top.locals);
    if (self.methods_call_stack.empty()) {
        return null;
    }
    return self.methods_call_stack.top();
}

pub fn runMethod(self: *Self, driver: *Driver, class: *Class, initial_method_id: u32) !void {
    _ = driver; // TODO: Use for fetching new classes
    const initial_method = class.class_file.methods[initial_method_id];
    std.log.info("Engine started method call {s}.{s}", .{ class.class_file.this_class, initial_method.name });

    var frame_opt: ?*MethodFrame = try self.enterMethod(class, initial_method_id);

    while (frame_opt != null and frame_opt.?.pc < frame_opt.?.code.len) {
        const frame = frame_opt.?;
        std.log.debug("\tframe pc: {} code size: {}", .{ frame.pc, frame.code.len });

        const decoded = decoder.decodeInstruction(frame.code[frame.pc..]);
        std.log.debug("\texecuting instr:{}", .{std.json.fmt(decoded.i, .{})});

        switch (decoded.i) {
            .aload => |instr| {
                self.exec_stack.push(frame.locals[instr.index]);
                frame.pc += decoded.sz;
            },
            .@"return" => {
                frame_opt = self.leaveMethod();
            },
            .bipush => |instr| {
                self.exec_stack.push(instr.value);
                frame.pc += decoded.sz;
            },
            .sipush => |instr| {
                self.exec_stack.push(@bitCast(@as(i32, instr.value)));
                frame.pc += decoded.sz;
            },
            .putstatic => |instr| {
                const stack = &self.exec_stack;
                frame.this.cached_resolve_constant_pool_entry(instr.index).field.* = stack.pop();
                frame.pc += decoded.sz;
            },
            .getstatic => |instr| {
                const value = frame.this.cached_resolve_constant_pool_entry(instr.index).field.*;
                self.exec_stack.push(value);
                frame.pc += decoded.sz;
            },
            .istore => |instr| {
                frame.locals[instr.index] = self.exec_stack.pop();
                frame.pc += decoded.sz;
            },
            .iconst => |instr| {
                self.exec_stack.push(instr.value);
                frame.pc += decoded.sz;
            },
            .iload => |instr| {
                self.exec_stack.push(frame.locals[instr.index]);
                frame.pc += decoded.sz;
            },
            .iadd => {
                const a: i32 = @intCast(self.exec_stack.pop());
                const b: i32 = @intCast(self.exec_stack.pop());
                self.exec_stack.push(@intCast(a +% b));
                frame.pc += decoded.sz;
            },
            .i2l => { // int to long with sign extension
                const int_val: i32 = @intCast(self.exec_stack.pop());
                const long_val: i64 = @intCast(int_val);
                // push as two 32-bit values
                const high: i32 = @truncate(long_val >> 32);
                const low: i32 = @truncate(long_val);
                self.exec_stack.push(@bitCast(high));
                self.exec_stack.push(@bitCast(low));
                frame.pc += decoded.sz;
            },
            .invokestatic => |instr| {
                const method = frame.this.cached_resolve_constant_pool_entry(instr.index).method;
                frame_opt = try enterMethod(self, method.class, method.method_id);
                frame.pc += decoded.sz;
            },
            .if_icmp_ge => |instr| {
                const b: i32 = @intCast(self.exec_stack.pop());
                const a: i32 = @intCast(self.exec_stack.pop());
                if (a >= b) {
                    frame.pc = @intCast(@as(i32, @intCast(frame.pc)) + instr.offset);
                } else {
                    frame.pc += decoded.sz;
                }
            },
            .iinc => |instr| {
                frame.locals[instr.index] = @bitCast(@as(i32, @bitCast(frame.locals[instr.index])) +% instr.value);
                frame.pc += decoded.sz;
            },
            .goto => |instr| {
                frame.pc = @intCast(@as(i32, @intCast(frame.pc)) + instr.offset);
            },
            .ldc => |instr| {
                const cp_info = frame.this.cached_resolve_constant_pool_entry(instr.index);
                switch (cp_info) {
                    .int => |value| {
                        self.exec_stack.push(@bitCast(value));
                    },
                    else => {
                        std.debug.panic("Unsupported constant pool entry for ldc: {}", .{cp_info});
                    },
                }
                frame.pc += decoded.sz;
            },
        }
    }

    std.log.debug("Engine finished method call {s}.{s}", .{ class.class_file.this_class, initial_method.name });
    return;
}
