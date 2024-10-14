/// Executes bytecode, using driver to resolve classes and methods.
const std = @import("std");
const RawClassFile = @import("../class-loading/root.zig").RawClassFile;
const Driver = @import("Driver.zig");
const decoder = @import("decoder.zig");

const Instr = decoder.Instr;
const Self = @This();

const Frame = struct {
    stack: []u64,
    stack_size: usize = 0,
    locals: []u64,
    pc: usize,
    code: []const u8,
    // constant_pool: []RuntimeConstantPoolEntry, // TODO: Implement
    constant_pool: []const RawClassFile.CPInfo, // for now
};

pub const STACK_LIMIT = 1024; // measured in function calls

allocator: std.mem.Allocator,
call_stack: [STACK_LIMIT]Frame,
next_call_stack_idx: usize = 0,

pub fn init(allocator: std.mem.Allocator) Self {
    return Self{
        .allocator = allocator,
        .call_stack = undefined,
    };
}

pub fn deinit(self: *Self) void {
    _ = self; // TODO: Free call stack
}

fn extract_method_code(method: RawClassFile.MethodInfo) ?RawClassFile.CodeAttribute {
    // TODO: lift code up to the class level

    // find code attribute in method.attributes
    for (method.attributes) |attr| {
        switch (attr.info) {
            .Code => |code| return code,
            else => continue,
        }
    }

    return null;
}

// TODO: Eliminate allocations. They spread errors over calling code
fn enterMethod(self: *Self, cf: *RawClassFile, code: RawClassFile.CodeAttribute) !void {
    if (self.next_call_stack_idx >= STACK_LIMIT) {
        // TODO: throw StackOverflowError
        std.debug.panic("Stack overflow", .{});
    }
    std.log.debug("\tmethod with max_stack {d} and max_locals {d}", .{ code.max_stack, code.max_locals });
    self.call_stack[self.next_call_stack_idx] = Frame{
        .stack = try self.allocator.alloc(u64, code.max_stack),
        .locals = try self.allocator.alloc(u64, code.max_locals),
        .pc = 0,
        .code = code.code,
        .constant_pool = cf.constant_pool,
    };
    self.next_call_stack_idx += 1;
}

fn leaveMethod(self: *Self) void {
    if (self.next_call_stack_idx == 0) {
        std.debug.panic("Stack underflow", .{});
    }
    self.next_call_stack_idx -= 1;
    self.allocator.free(self.call_stack[self.next_call_stack_idx].stack);
    self.allocator.free(self.call_stack[self.next_call_stack_idx].locals);
}

pub fn runMethod(self: *Self, driver: *Driver, resolved_method: anytype) !void {
    _ = driver; // TODO: Use for fetching new classes
    const cf = resolved_method.cf;
    const method = resolved_method.method;
    std.log.debug("Engine started method call {s}.{s}", .{ resolved_method.cf.*.this_class, resolved_method.method.name });

    const code = extract_method_code(method) orelse {
        return error.MethodCodeNotFound;
    };
    try self.enterMethod(cf, code);

    while (true) {
        const frame = &self.call_stack[self.next_call_stack_idx - 1];
        const decoded = decoder.decodeInstruction(code.code[frame.pc..]);
        std.log.debug("\texecuting {} on {}", .{ decoded.i, frame });
        switch (decoded.i) {
            .aload => |instr| {
                frame.stack[frame.stack_size] = frame.locals[instr.index];
                frame.stack_size += 1;
                frame.pc += decoded.sz;
            },
            .@"return" => {
                self.leaveMethod();
                if (self.next_call_stack_idx == 0) {
                    break;
                }
            },
            .bipush => |instr| {
                frame.stack[frame.stack_size] = @intCast(@as(i32, @intCast(instr.value)));
                frame.stack_size += 1;
                frame.pc += decoded.sz;
            },
        }
    }

    std.log.debug("Engine finished method call {s}.{s}", .{ resolved_method.cf.*.this_class, resolved_method.method.name });
    return;
}
