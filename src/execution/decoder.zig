/// Instructions are the basic building blocks of a program. They are the
const std = @import("std");

fn ICmp(Comparator: type) type {
    return struct {
        fn cmp(a: i32, b: i32) bool {
            return Comparator.cmp(a, b);
        }

        offset: i16,
    };
}

pub const Instr = union(enum) {
    aload: struct { index: u8 },
    bipush: struct { value: u8 },
    @"return": struct {},
    ireturn: struct {},
    putstatic: struct { index: u16 },
    getstatic: struct { index: u16 },
    istore: struct { index: u8 },
    iconst: struct { value: u8 },
    iload: struct { index: u8 },
    iadd: struct {},
    imul: struct {},
    idiv: struct {},
    i2l: struct {},
    invokestatic: struct { index: u16 },
    if_icmp_ge: ICmp(struct {
        fn cmp(a: i32, b: i32) bool {
            return a >= b;
        }
    }),
    iinc: struct { index: u8, value: i8 },
    goto: struct { offset: i16 },
    sipush: struct { value: i16 },
    ldc: struct { index: u8 },
    astore: struct { index: u8 },
    new: struct { index: u16 },
    dup: struct {},
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
        0xac => return .{ .i = Instr{ .ireturn = .{} }, .sz = 1 },
        0xb3 => return .{ .i = Instr{ .putstatic = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xb2 => return .{ .i = Instr{ .getstatic = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
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
        0x68 => return .{ .i = Instr{ .imul = .{} }, .sz = 1 },
        0x6c => return .{ .i = Instr{ .idiv = .{} }, .sz = 1 },
        0x85 => return .{ .i = Instr{ .i2l = .{} }, .sz = 1 },
        0xb8 => return .{ .i = Instr{ .invokestatic = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xa2 => return .{ .i = Instr{ .if_icmp_ge = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x84 => return .{ .i = Instr{ .iinc = .{ .index = data[1], .value = @intCast(data[2]) } }, .sz = 3 },
        0xa7 => return .{ .i = Instr{ .goto = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x11 => return .{ .i = Instr{ .sipush = .{ .value = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x12 => return .{ .i = Instr{ .ldc = .{ .index = data[1] } }, .sz = 2 },
        0x3a => return .{ .i = Instr{ .astore = .{ .index = data[1] } }, .sz = 2 },
        0x4b => return .{ .i = Instr{ .astore = .{ .index = 0 } }, .sz = 1 },
        0x4c => return .{ .i = Instr{ .astore = .{ .index = 1 } }, .sz = 1 },
        0x4d => return .{ .i = Instr{ .astore = .{ .index = 2 } }, .sz = 1 },
        0x4e => return .{ .i = Instr{ .astore = .{ .index = 3 } }, .sz = 1 },
        0xbb => return .{ .i = Instr{ .new = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x59 => return .{ .i = Instr{ .dup = .{} }, .sz = 1 },
        else => std.debug.panic("Unknown instruction 0x{X}", .{first_byte}),
    }
}
