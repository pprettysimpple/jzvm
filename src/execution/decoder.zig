/// Instructions are the basic building blocks of a program. They are the
const std = @import("std");
pub const Instr = union(enum) {
    aload: struct {
        const Opcode = 0x2a;
        index: u8,
    },
    bipush: struct {
        const Opcode = 0x10;
        value: u8,
    },
    @"return": struct {
        const Opcode = 0xb1;
    },
};

pub fn decodeInstruction(data: []const u8) struct { i: Instr, sz: u8 } {
    const first_byte = data[0];
    switch (first_byte) {
        0x10 => return .{ .i = Instr{ .bipush = .{ .value = data[1] } }, .sz = 2 },
        0x19 => return .{ .i = Instr{ .aload = .{ .index = data[1] } }, .sz = 2 },
        0x2a => return .{ .i = Instr{ .aload = .{ .index = 0 } }, .sz = 1 },
        0x2b => return .{ .i = Instr{ .aload = .{ .index = 1 } }, .sz = 1 },
        0x2c => return .{ .i = Instr{ .aload = .{ .index = 2 } }, .sz = 1 },
        0x2d => return .{ .i = Instr{ .aload = .{ .index = 3 } }, .sz = 1 },
        0xb1 => return .{ .i = Instr{ .@"return" = .{} }, .sz = 1 },
        else => std.debug.panic("Unknown instruction 0x{X}", .{first_byte}),
    }
}
