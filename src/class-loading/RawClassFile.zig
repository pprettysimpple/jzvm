/// The class file format is defined in the Java Virtual Machine Specification.
/// This structure represents a class file in memory.
const std = @import("std");
const common = @import("../common.zig");
const Self = @This();

pub const CPInfo = union(enum) {
    Undefined: struct {},
    Utf8: []const u8,
    Integer: common.JavaType.Int,
    Float: common.JavaType.Float,
    Long: common.JavaType.Long,
    Double: common.JavaType.Double,
    ClassInfo: struct {
        name_index: u16,
    },
    String: struct {
        string_index: u16,
    },
    FieldRef: struct {
        class_index: u16,
        name_and_type_index: u16,
    },
    MethodRef: struct {
        class_index: u16,
        name_and_type_index: u16,
    },
    InterfaceMethodRef: struct {
        class_index: u16,
        name_and_type_index: u16,
    },
    NameAndType: struct {
        name_index: u16,
        descriptor_index: u16,
    },
    MethodHandle: struct {
        reference_kind: u8,
        reference_index: u16,
    },
    MethodType: struct {
        descriptor_index: u16,
    },
    InvokeDynamic: struct {
        bootstrap_method_attr_index: u16,
        name_and_type_index: u16,
    },
};

const FieldInfo = struct {
    access_flags: common.FieldAccessFlags,
    name: []const u8,
    descriptor: []const u8,
    attributes: []const Attribute,
};

pub const MethodInfo = struct {
    access_flags: u16,
    name: []const u8,
    descriptor: []const u8,
    attributes: []const Attribute,
};

const ExceptionTableEntry = struct {
    start_pc: u16,
    end_pc: u16,
    handler_pc: u16,
    catch_type: u16,
};

pub const CodeAttribute = struct {
    max_stack: u16,
    max_locals: u16,
    code: []const u8,
    exception_table: []const ExceptionTableEntry,
    attributes: []const Attribute,
};

pub const Attribute = struct {
    name: []const u8,
    info: union(enum) {
        Unsupported: struct {},
        ConstantValue: struct { value: CPInfo },
        Code: CodeAttribute,
    },

    fn read(reader: std.io.AnyReader, allocator: std.mem.Allocator, constant_pool: []const CPInfo) !Attribute {
        const attribute_name_index = try reader.readInt(u16, common.endian);
        const attribute_length = try reader.readInt(u32, common.endian);
        const name = constant_pool[attribute_name_index].Utf8;
        if (std.mem.eql(u8, name, "ConstantValue")) {
            const constant_value_index = try reader.readInt(u16, common.endian);
            return Attribute{
                .name = name,
                .info = .{ .ConstantValue = .{ .value = constant_pool[constant_value_index] } },
            };
        } else if (std.mem.eql(u8, name, "LineNumberTable")) {
            // unsupported
            try reader.skipBytes(attribute_length, .{});
            std.log.warn("unsupported attribute: {s}", .{name});
            return Attribute{
                .name = name,
                .info = .{ .Unsupported = .{} },
            };
        } else if (std.mem.eql(u8, name, "Code")) {
            const max_stack = try reader.readInt(u16, common.endian);
            const max_locals = try reader.readInt(u16, common.endian);
            const code_length = try reader.readInt(u32, common.endian);
            const code = try allocator.alloc(u8, code_length);
            if (try reader.readAll(code) != code_length) {
                return error.CorruptedData;
            }
            const exception_table_length = try reader.readInt(u16, common.endian);
            const exception_table = try allocator.alloc(ExceptionTableEntry, exception_table_length);
            for (exception_table) |*entry| {
                const start_pc = try reader.readInt(u16, common.endian);
                const end_pc = try reader.readInt(u16, common.endian);
                const handler_pc = try reader.readInt(u16, common.endian);
                const catch_type = try reader.readInt(u16, common.endian);
                entry.* = ExceptionTableEntry{
                    .start_pc = start_pc,
                    .end_pc = end_pc,
                    .handler_pc = handler_pc,
                    .catch_type = catch_type,
                };
            }
            const attributes_count = try reader.readInt(u16, common.endian);
            const attributes = try allocator.alloc(Attribute, attributes_count);
            for (attributes) |*attribute| {
                attribute.* = try Attribute.read(reader, allocator, constant_pool);
            }

            return Attribute{
                .name = name,
                .info = .{ .Code = .{
                    .max_stack = max_stack,
                    .max_locals = max_locals,
                    .code = code,
                    .exception_table = exception_table,
                    .attributes = attributes,
                } },
            };
        } else if (std.mem.eql(u8, name, "Signature") or std.mem.eql(u8, name, "StackMapTable") or std.mem.eql(u8, name, "Exceptions")) {
            // unsupported
            try reader.skipBytes(attribute_length, .{});
            std.log.warn("unsupported attribute: {s}", .{name});
            return Attribute{
                .name = name,
                .info = .{ .Unsupported = .{} },
            };
        } else {
            std.debug.panic("unknown attribute name: {s}", .{name});
        }
    }
};

/// allocator is used to allocate memory for the internal structs CPInfo, FieldInfo, MethodInfo, and AttributeInfo.
/// it is not deallocated until the RawFile is deallocated.
arena: std.heap.ArenaAllocator,
magic: u32,
minor_version: u16,
major_version: u16,
access_flags: common.ClassAccessFlags,
this_class: []const u8,
super_class: []const u8,
constant_pool: []const CPInfo,
interfaces: []const u16,
fields: []const FieldInfo,
methods: []const MethodInfo,
// attributes: []const AttributeInfo,

const Reader = struct {
    data: []const u8,

    fn read(self: *Reader, comptime T: type) !T {
        if (self.data.len < @sizeOf(T)) {
            return error.CorruptedData;
        }
        const bytes: [@sizeOf(T)]u8 = self.data[0..@sizeOf(T)].*;
        self.data = self.data[@sizeOf(T)..];
        return @byteSwap(@as(T, @bitCast(bytes)));
    }

    fn readMany(self: *Reader, n: usize) ![]const u8 {
        if (self.data.len < n) {
            return error.CorruptedData;
        }
        const res = self.data[0..n];
        self.data = self.data[n..];
        return res;
    }
};

/// Reads a class file from a reader and returns Self.
pub fn read(reader: std.io.AnyReader, user_allocator: std.mem.Allocator) !Self {
    // allocate in arena
    var arena = std.heap.ArenaAllocator.init(user_allocator);
    errdefer arena.deinit(); // in case of error, deallocate the whole arena
    const allocator = arena.allocator();

    const magic = try reader.readInt(u32, common.endian);
    if (magic != 0xCAFEBABE) {
        std.log.err("invalid magic number: 0x{X}", .{magic});
        return error.InvalidMagicNumber;
    }
    const minor_version = try reader.readInt(u16, common.endian);
    const major_version = try reader.readInt(u16, common.endian);

    std.log.info("version: {d}.{d}", .{ major_version, minor_version });

    // first, we extract only sizes of all structures, then alloc, then read again
    const constant_pool_count = try reader.readInt(u16, common.endian);
    std.log.info("constant_pool_count: {d}", .{constant_pool_count});
    const constant_pool = try allocator.alloc(CPInfo, constant_pool_count);
    constant_pool[0] = CPInfo{ .Undefined = .{} };
    for (constant_pool[1..], 1..constant_pool_count) |*cp_info, i| {
        const tag = try reader.readInt(u8, common.endian);
        cp_info.* = switch (tag) {
            1 => blk: {
                const len = try reader.readInt(u16, common.endian);
                const bytes = try allocator.alloc(u8, len);
                if (try reader.read(bytes) != len) {
                    return error.CorruptedData;
                }
                break :blk CPInfo{ .Utf8 = bytes };
            },
            10 => blk: {
                const class_index = try reader.readInt(u16, common.endian);
                const name_and_type_index = try reader.readInt(u16, common.endian);
                break :blk CPInfo{ .MethodRef = .{ .class_index = class_index, .name_and_type_index = name_and_type_index } };
            },
            7 => blk: {
                const name_index = try reader.readInt(u16, common.endian);
                break :blk CPInfo{ .ClassInfo = .{ .name_index = name_index } };
            },
            12 => blk: {
                const name_index = try reader.readInt(u16, common.endian);
                const descriptor_index = try reader.readInt(u16, common.endian);
                break :blk CPInfo{ .NameAndType = .{ .name_index = name_index, .descriptor_index = descriptor_index } };
            },
            9 => blk: {
                const class_index = try reader.readInt(u16, common.endian);
                const name_and_type_index = try reader.readInt(u16, common.endian);
                break :blk CPInfo{ .FieldRef = .{ .class_index = class_index, .name_and_type_index = name_and_type_index } };
            },
            8 => blk: {
                const string_index = try reader.readInt(u16, common.endian);
                break :blk CPInfo{ .String = .{ .string_index = string_index } };
            },
            3 => blk: {
                const value = try reader.readInt(i32, common.endian);
                break :blk CPInfo{ .Integer = value };
            },
            else => {
                std.debug.panic("tried to handle constant pool tag {d}", .{tag});
            },
        };
        std.log.debug("[{d}] -- {}", .{ i, std.json.fmt(cp_info.*, .{}) });
    }

    const access_flags: common.ClassAccessFlags = @bitCast(try reader.readInt(u16, common.endian));

    const this_class_index = try reader.readInt(u16, common.endian);
    const this_class = constant_pool[constant_pool[this_class_index].ClassInfo.name_index].Utf8;

    const super_class_index = try reader.readInt(u16, common.endian);
    const super_class = blk: {
        if (super_class_index == 0)
            break :blk &[0]u8{};
        break :blk constant_pool[constant_pool[super_class_index].ClassInfo.name_index].Utf8;
    };

    const interfaces_count = try reader.readInt(u16, common.endian);
    const interfaces = try allocator.alloc(u16, interfaces_count);
    std.log.info("interfaces_count: {d}", .{interfaces_count});
    for (interfaces) |*interface| {
        interface.* = try reader.readInt(u16, common.endian);
        std.log.debug("\tinterface: {d}", .{interface.*});
    }
    const fields_count = try reader.readInt(u16, common.endian);
    std.log.info("fields_count: {d}", .{fields_count});
    const fields = try allocator.alloc(FieldInfo, fields_count);
    for (fields) |*field| {
        const field_access_flags: common.FieldAccessFlags = @bitCast(try reader.readInt(u16, common.endian));
        const name_index = try reader.readInt(u16, common.endian);
        const descriptor_index = try reader.readInt(u16, common.endian);
        const attributes_count = try reader.readInt(u16, common.endian);
        const attributes = try allocator.alloc(Attribute, attributes_count);
        for (attributes) |*attribute| {
            attribute.* = try Attribute.read(reader, allocator, constant_pool);
        }

        field.* = FieldInfo{
            .access_flags = field_access_flags,
            .name = constant_pool[name_index].Utf8,
            .descriptor = constant_pool[descriptor_index].Utf8,
            .attributes = attributes,
        };
        std.log.debug("{}", .{std.json.fmt(field.*, .{})});
    }
    const methods_count = try reader.readInt(u16, common.endian);
    std.log.info("methods_count: {d}", .{methods_count});
    const methods = try allocator.alloc(MethodInfo, methods_count);
    for (methods) |*method| {
        const method_access_flags = try reader.readInt(u16, common.endian);
        const name_index = try reader.readInt(u16, common.endian);
        const descriptor_index = try reader.readInt(u16, common.endian);
        const attributes_count = try reader.readInt(u16, common.endian);
        const attributes = try allocator.alloc(Attribute, attributes_count);
        for (attributes) |*attribute| {
            attribute.* = try Attribute.read(reader, allocator, constant_pool);
        }

        method.* = MethodInfo{
            .access_flags = method_access_flags,
            .name = constant_pool[name_index].Utf8,
            .descriptor = constant_pool[descriptor_index].Utf8,
            .attributes = attributes,
        };
        std.log.debug("{}", .{std.json.fmt(method.*, .{})});
    }
    // TODO: read class-attributes
    // const attributes_count = try reader.read(u16, common.endian);
    // _ = try reader.readMany(attributes_count * 2);

    return Self{
        .arena = arena,
        .magic = magic,
        .minor_version = minor_version,
        .major_version = major_version,
        .access_flags = access_flags,
        .this_class = this_class,
        .super_class = super_class,
        .constant_pool = constant_pool,
        .interfaces = interfaces,
        .fields = fields,
        .methods = methods,
    };
}

pub fn deinit(self: Self) void {
    self.arena.deinit();
}
