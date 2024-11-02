/// Instructions are the basic building blocks of a program. They are the
const std = @import("std");
const u = @import("../common.zig");

fn ICmpBin(comptime Comparator: type) type {
    return struct {
        pub fn cmp(a: i32, b: i32) bool {
            return Comparator.cmp(a, b);
        }

        offset: i16,
    };
}

fn ICmpUn(comptime Comparator: type) type {
    return struct {
        pub fn cmp(a: i32) bool {
            return Comparator.cmp(a);
        }

        offset: i16,
    };
}

fn ICmpNull(comptime Comparator: type) type {
    return struct {
        pub fn cmp(a: u.AnyRef) bool {
            return Comparator.cmp(a);
        }

        offset: i16,
    };
}

pub const Instr = union(enum) {
    aload: struct { index: u8 },
    bipush: struct { value: u8 },
    @"return": struct {},
    ireturn: struct {},
    areturn: struct {},
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
    ishl: struct {
        pub const ty = "int";
        pub fn op(a: i32, b: i32) i32 {
            return a << @intCast(b & 0x1f);
        }
    },
    ishr: struct {
        pub const ty = "int";
        pub fn op(a: i32, b: i32) i32 {
            return a >> @intCast(b & 0x1f);
        }
    },
    i2l: struct {},
    invokestatic: struct { index: u16 },
    invokespecial: struct { index: u16 },
    invokevirtual: struct { index: u16 },
    if_icmp_ge: ICmpBin(struct {
        fn cmp(a: i32, b: i32) bool {
            return a >= b;
        }
    }),
    if_icmp_eq: ICmpBin(struct {
        fn cmp(a: i32, b: i32) bool {
            return a == b;
        }
    }),
    if_icmp_ne: ICmpBin(struct {
        fn cmp(a: i32, b: i32) bool {
            return a != b;
        }
    }),
    if_icmp_lt: ICmpBin(struct {
        fn cmp(a: i32, b: i32) bool {
            return a < b;
        }
    }),
    if_icmp_le: ICmpBin(struct {
        fn cmp(a: i32, b: i32) bool {
            return a <= b;
        }
    }),
    if_icmp_gt: ICmpBin(struct {
        fn cmp(a: i32, b: i32) bool {
            return a > b;
        }
    }),
    if_eq: ICmpUn(struct {
        fn cmp(a: i32) bool {
            return a == 0;
        }
    }),
    if_ne: ICmpUn(struct {
        fn cmp(a: i32) bool {
            return a != 0;
        }
    }),
    if_lt: ICmpUn(struct {
        fn cmp(a: i32) bool {
            return a < 0;
        }
    }),
    if_ge: ICmpUn(struct {
        fn cmp(a: i32) bool {
            return a >= 0;
        }
    }),
    if_gt: ICmpUn(struct {
        fn cmp(a: i32) bool {
            return a > 0;
        }
    }),
    if_le: ICmpUn(struct {
        fn cmp(a: i32) bool {
            return a <= 0;
        }
    }),
    if_null: ICmpNull(struct {
        fn cmp(a: u.AnyRef) bool {
            return a.isNull();
        }
    }),
    if_nonnull: ICmpNull(struct {
        fn cmp(a: u.AnyRef) bool {
            return !a.isNull();
        }
    }),
    iinc: struct { index: u8, value: i8 },
    goto: struct { offset: i16 },
    sipush: struct { value: i16 },
    ldc: struct { index: u8 },
    astore: struct { index: u8 },
    castore: struct {
        const ty = "char";
    },
    iastore: struct {
        const ty = "int";
    },
    iaload: struct {},
    new: struct { index: u16 },
    newarray: struct { atype: u8 },
    anewarray: struct { index: u16 },
    dup: struct {},
    aconst_null: struct {},
    arraylength: struct {},
    getfield: struct { index: u16 },
    putfield: struct { index: u16 },
};

pub fn decodeInstruction(data: []const u8) struct { i: Instr, sz: u8 } {
    const first_byte = data[0];
    return switch (first_byte) {
        0x10 => .{ .i = Instr{ .bipush = .{ .value = data[1] } }, .sz = 2 },
        0x19 => .{ .i = Instr{ .aload = .{ .index = data[1] } }, .sz = 2 },
        0x2a => .{ .i = Instr{ .aload = .{ .index = 0 } }, .sz = 1 },
        0x2b => .{ .i = Instr{ .aload = .{ .index = 1 } }, .sz = 1 },
        0x2c => .{ .i = Instr{ .aload = .{ .index = 2 } }, .sz = 1 },
        0x2d => .{ .i = Instr{ .aload = .{ .index = 3 } }, .sz = 1 },
        0xb1 => .{ .i = Instr{ .@"return" = .{} }, .sz = 1 },
        0xac => .{ .i = Instr{ .ireturn = .{} }, .sz = 1 },
        0xb0 => .{ .i = Instr{ .areturn = .{} }, .sz = 1 },
        0xb3 => .{ .i = Instr{ .putstatic = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xb2 => .{ .i = Instr{ .getstatic = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x36 => .{ .i = Instr{ .istore = .{ .index = data[1] } }, .sz = 2 },
        0x3b => .{ .i = Instr{ .istore = .{ .index = 0 } }, .sz = 1 },
        0x3c => .{ .i = Instr{ .istore = .{ .index = 1 } }, .sz = 1 },
        0x3d => .{ .i = Instr{ .istore = .{ .index = 2 } }, .sz = 1 },
        0x3e => .{ .i = Instr{ .istore = .{ .index = 3 } }, .sz = 1 },
        0x02 => .{ .i = Instr{ .iconst = .{ .value = 0xff } }, .sz = 1 },
        0x03 => .{ .i = Instr{ .iconst = .{ .value = 0 } }, .sz = 1 },
        0x04 => .{ .i = Instr{ .iconst = .{ .value = 1 } }, .sz = 1 },
        0x05 => .{ .i = Instr{ .iconst = .{ .value = 2 } }, .sz = 1 },
        0x06 => .{ .i = Instr{ .iconst = .{ .value = 3 } }, .sz = 1 },
        0x07 => .{ .i = Instr{ .iconst = .{ .value = 4 } }, .sz = 1 },
        0x08 => .{ .i = Instr{ .iconst = .{ .value = 5 } }, .sz = 1 },
        0x15 => .{ .i = Instr{ .iload = .{ .index = data[1] } }, .sz = 2 },
        0x1a => .{ .i = Instr{ .iload = .{ .index = 0 } }, .sz = 1 },
        0x1b => .{ .i = Instr{ .iload = .{ .index = 1 } }, .sz = 1 },
        0x1c => .{ .i = Instr{ .iload = .{ .index = 2 } }, .sz = 1 },
        0x1d => .{ .i = Instr{ .iload = .{ .index = 3 } }, .sz = 1 },
        0x60 => .{ .i = Instr{ .iadd = .{} }, .sz = 1 },
        0x63 => .{ .i = Instr{ .dadd = .{} }, .sz = 1 },
        0x64 => .{ .i = Instr{ .isub = .{} }, .sz = 1 },
        0x67 => .{ .i = Instr{ .dsub = .{} }, .sz = 1 },
        0x68 => .{ .i = Instr{ .imul = .{} }, .sz = 1 },
        0x6b => .{ .i = Instr{ .dmul = .{} }, .sz = 1 },
        0x6c => .{ .i = Instr{ .idiv = .{} }, .sz = 1 },
        0x6f => .{ .i = Instr{ .ddiv = .{} }, .sz = 1 },
        0x78 => .{ .i = Instr{ .ishl = .{} }, .sz = 1 },
        0x7a => .{ .i = Instr{ .ishr = .{} }, .sz = 1 },
        0x85 => .{ .i = Instr{ .i2l = .{} }, .sz = 1 },
        0xb6 => .{ .i = Instr{ .invokevirtual = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xb7 => .{ .i = Instr{ .invokespecial = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xb8 => .{ .i = Instr{ .invokestatic = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x9f => .{ .i = Instr{ .if_icmp_eq = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xa0 => .{ .i = Instr{ .if_icmp_ne = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xa1 => .{ .i = Instr{ .if_icmp_lt = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xa2 => .{ .i = Instr{ .if_icmp_ge = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xa3 => .{ .i = Instr{ .if_icmp_gt = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xa4 => .{ .i = Instr{ .if_icmp_le = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x99 => .{ .i = Instr{ .if_eq = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x9a => .{ .i = Instr{ .if_ne = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x9b => .{ .i = Instr{ .if_lt = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x9c => .{ .i = Instr{ .if_ge = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x9d => .{ .i = Instr{ .if_gt = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x9e => .{ .i = Instr{ .if_le = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xc6 => .{ .i = Instr{ .if_null = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xc7 => .{ .i = Instr{ .if_nonnull = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x84 => .{ .i = Instr{ .iinc = .{ .index = data[1], .value = @intCast(data[2]) } }, .sz = 3 },
        0xa7 => .{ .i = Instr{ .goto = .{ .offset = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x11 => .{ .i = Instr{ .sipush = .{ .value = @byteSwap(@as(i16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0x12 => .{ .i = Instr{ .ldc = .{ .index = data[1] } }, .sz = 2 },
        0x3a => .{ .i = Instr{ .astore = .{ .index = data[1] } }, .sz = 2 },
        0x4b => .{ .i = Instr{ .astore = .{ .index = 0 } }, .sz = 1 },
        0x4c => .{ .i = Instr{ .astore = .{ .index = 1 } }, .sz = 1 },
        0x4d => .{ .i = Instr{ .astore = .{ .index = 2 } }, .sz = 1 },
        0x4e => .{ .i = Instr{ .astore = .{ .index = 3 } }, .sz = 1 },
        0x55 => .{ .i = Instr{ .castore = .{} }, .sz = 1 },
        0x4f => .{ .i = Instr{ .iastore = .{} }, .sz = 1 },
        0x2e => .{ .i = Instr{ .iaload = .{} }, .sz = 1 },
        0xbb => .{ .i = Instr{ .new = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xbc => .{ .i = Instr{ .newarray = .{ .atype = data[1] } }, .sz = 2 },
        0x59 => .{ .i = Instr{ .dup = .{} }, .sz = 1 },
        0x01 => .{ .i = Instr{ .aconst_null = .{} }, .sz = 1 },
        0xbe => .{ .i = Instr{ .arraylength = .{} }, .sz = 1 },
        0xb4 => .{ .i = Instr{ .getfield = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xb5 => .{ .i = Instr{ .putfield = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        0xbd => .{ .i = Instr{ .anewarray = .{ .index = @byteSwap(@as(u16, @bitCast(@as([2]u8, data[1..3].*)))) } }, .sz = 3 },
        else => std.debug.panic("Unknown instruction 0x{X}", .{first_byte}),
    };
}
