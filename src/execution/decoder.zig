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
    putstatic: struct {
        const Opcode = 0xb3;
        index: u16,
    },
    istore: struct {
        const Opcode = 0x36;
        index: u8,
    },
    iconst: struct {
        const Opcode = 0x03;
        value: u8,
    },
    iload: struct {
        const Opcode = 0x15;
        index: u8,
    },
    iadd: struct {
        const Opcode = 0x60;
    },
    i2l: struct {
        const Opcode = 0x85;
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
        0xb3 => return .{ .i = Instr{ .putstatic = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x36 => return .{ .i = Instr{ .istore = .{ .index = data[1] } }, .sz = 2 },
        0x3b => return .{ .i = Instr{ .istore = .{ .index = 0 } }, .sz = 1 },
        0x3c => return .{ .i = Instr{ .istore = .{ .index = 1 } }, .sz = 1 },
        0x3d => return .{ .i = Instr{ .istore = .{ .index = 2 } }, .sz = 1 },
        0x3e => return .{ .i = Instr{ .istore = .{ .index = 3 } }, .sz = 1 },
        0x02 => return .{ .i = Instr{ .iconst = .{ .value = 0xff } }, .sz = 1 },
        0x03 => return .{ .i = Instr{ .iconst = .{ .value = 0 } }, .sz = 1 },
        0x04 => return .{ .i = Instr{ .iconst = .{ .value = 1 } }, .sz = 1 },
        0x05 => return .{ .i = Instr{ .iconst = .{ .value = 2 } }, .sz = 1 },
        0x06 => return .{ .i = Instr{ .iconst = .{ .value = 3 } }, .sz = 1 },
        0x07 => return .{ .i = Instr{ .iconst = .{ .value = 4 } }, .sz = 1 },
        0x08 => return .{ .i = Instr{ .iconst = .{ .value = 5 } }, .sz = 1 },
        0x15 => return .{ .i = Instr{ .iload = .{ .index = data[1] } }, .sz = 2 },
        0x1a => return .{ .i = Instr{ .iload = .{ .index = 0 } }, .sz = 1 },
        0x1b => return .{ .i = Instr{ .iload = .{ .index = 1 } }, .sz = 1 },
        0x1c => return .{ .i = Instr{ .iload = .{ .index = 2 } }, .sz = 1 },
        0x1d => return .{ .i = Instr{ .iload = .{ .index = 3 } }, .sz = 1 },
        0x60 => return .{ .i = Instr{ .iadd = .{} }, .sz = 1 },
        0x85 => return .{ .i = Instr{ .i2l = .{} }, .sz = 1 },
        else => std.debug.panic("Unknown instruction 0x{X}", .{first_byte}),
    }
}
