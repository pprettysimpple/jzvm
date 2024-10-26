/// Instructions are the basic building blocks of a program. They are the
const std = @import("std");
const u = @import("../common.zig");

fn ICmp(comptime Comparator: type) type {
    return struct {
        pub fn cmp(a: i32, b: i32) bool {
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
    dadd: struct {
        pub const ty = "double";
        pub fn op(a: f64, b: f64) f64 {
            return a + b;
        }
    },
    dsub: struct {
        pub const ty = "double";
        pub fn op(a: f64, b: f64) f64 {
            return a - b;
        }
    },
    dmul: struct {
        pub const ty = "double";
        pub fn op(a: f64, b: f64) f64 {
            return a * b;
        }
    },
    ddiv: struct {
        pub const ty = "double";
        pub fn op(a: f64, b: f64) f64 {
            return a / b;
        }
    },
    iadd: struct {
        pub const ty = "int";
        pub fn op(a: i32, b: i32) i32 {
            return a +% b;
        }
    },
    isub: struct {
        pub const ty = "int";
        pub fn op(a: i32, b: i32) i32 {
            return a -% b;
        }
    },
    imul: struct {
        pub const ty = "int";
        pub fn op(a: i32, b: i32) i32 {
            return a *% b;
        }
    },
    idiv: struct {
        pub const ty = "int";
        pub fn op(a: i32, b: i32) i32 {
            if (b == 0) {
                std.debug.panic("TODO: Exception for division by zero", .{});
            }
            if (b == -1) {
                return b;
            }
            return @divTrunc(a, b);
        }
    },
    i2l: struct {},
    invokestatic: struct { index: u16 },
    invokespecial: struct { index: u16 },
    if_icmp_ge: ICmp(struct {
        fn cmp(a: i32, b: i32) bool {
            return a >= b;
        }
    }),
    if_icmp_eq: ICmp(struct {
        fn cmp(a: i32, b: i32) bool {
            return a == b;
        }
    }),
    if_icmp_ne: ICmp(struct {
        fn cmp(a: i32, b: i32) bool {
            return a != b;
        }
    }),
    if_icmp_lt: ICmp(struct {
        fn cmp(a: i32, b: i32) bool {
            return a < b;
        }
    }),
    if_icmp_le: ICmp(struct {
        fn cmp(a: i32, b: i32) bool {
            return a <= b;
        }
    }),
    if_icmp_gt: ICmp(struct {
        fn cmp(a: i32, b: i32) bool {
            return a > b;
        }
    }),
    iinc: struct { index: u8, value: i8 },
    goto: struct { offset: i16 },
    sipush: struct { value: i16 },
    ldc: struct { index: u8 },
    astore: struct { index: u8 },
    iastore: struct {},
    iaload: struct {},
    new: struct { index: u16 },
    newarray: struct { atype: u8 },
    dup: struct {},
    aconst_null: struct {},
    arraylength: struct {},
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
        0x63 => return .{ .i = Instr{ .dadd = .{} }, .sz = 1 },
        0x64 => return .{ .i = Instr{ .isub = .{} }, .sz = 1 },
        0x67 => return .{ .i = Instr{ .dsub = .{} }, .sz = 1 },
        0x68 => return .{ .i = Instr{ .imul = .{} }, .sz = 1 },
        0x6b => return .{ .i = Instr{ .dmul = .{} }, .sz = 1 },
        0x6c => return .{ .i = Instr{ .idiv = .{} }, .sz = 1 },
        0x6f => return .{ .i = Instr{ .ddiv = .{} }, .sz = 1 },
        0x85 => return .{ .i = Instr{ .i2l = .{} }, .sz = 1 },
        0xb8 => return .{ .i = Instr{ .invokestatic = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xb7 => return .{ .i = Instr{ .invokespecial = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x9f => return .{ .i = Instr{ .if_icmp_eq = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xa0 => return .{ .i = Instr{ .if_icmp_ne = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xa1 => return .{ .i = Instr{ .if_icmp_lt = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xa2 => return .{ .i = Instr{ .if_icmp_ge = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xa3 => return .{ .i = Instr{ .if_icmp_gt = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xa4 => return .{ .i = Instr{ .if_icmp_le = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x84 => return .{ .i = Instr{ .iinc = .{ .index = data[1], .value = @intCast(data[2]) } }, .sz = 3 },
        0xa7 => return .{ .i = Instr{ .goto = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x11 => return .{ .i = Instr{ .sipush = .{ .value = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x12 => return .{ .i = Instr{ .ldc = .{ .index = data[1] } }, .sz = 2 },
        0x3a => return .{ .i = Instr{ .astore = .{ .index = data[1] } }, .sz = 2 },
        0x4b => return .{ .i = Instr{ .astore = .{ .index = 0 } }, .sz = 1 },
        0x4c => return .{ .i = Instr{ .astore = .{ .index = 1 } }, .sz = 1 },
        0x4d => return .{ .i = Instr{ .astore = .{ .index = 2 } }, .sz = 1 },
        0x4e => return .{ .i = Instr{ .astore = .{ .index = 3 } }, .sz = 1 },
        0x4f => return .{ .i = Instr{ .iastore = .{} }, .sz = 1 },
        0x2e => return .{ .i = Instr{ .iaload = .{} }, .sz = 1 },
        0xbb => return .{ .i = Instr{ .new = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xbc => return .{ .i = Instr{ .newarray = .{ .atype = data[1] } }, .sz = 2 },
        0x59 => return .{ .i = Instr{ .dup = .{} }, .sz = 1 },
        0x01 => return .{ .i = Instr{ .aconst_null = .{} }, .sz = 1 },
        0xbe => return .{ .i = Instr{ .arraylength = .{} }, .sz = 1 },
        else => std.debug.panic("Unknown instruction 0x{X}", .{first_byte}),
    }
}
