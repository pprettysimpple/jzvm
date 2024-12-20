/// The class file format is defined in the Java Virtual Machine Specification.
/// This structure represents a class file in memory.
const std = @import("std");
const u = @import("../common.zig");
const Self = @This();

const RawCPInfo = union(enum) {
    Undefined: struct {},
    Utf8: []const u8,
    Integer: u.Ty.Int,
    Float: u.Ty.Float,
    Long: u.Ty.Long,
    Double: u.Ty.Double,
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

pub const FieldRef = struct {
    class_name: []const u8,
    name: []const u8,
    descriptor: []const u8,
};

// same as RawCPInfo, but without indexes, just slices
pub const CPInfo = union(enum) {
    Undefined: struct {},
    Utf8: []const u8,
    Integer: u.Ty.Int,
    Float: u.Ty.Float,
    Long: u.Ty.Long,
    Double: u.Ty.Double,
    ClassInfo: []const u8,
    String: []const u8,
    FieldRef: FieldRef,
    MethodRef: struct {
        class_name: []const u8,
        name: []const u8,
        descriptor: []const u8,
    },
    InterfaceMethodRef: struct {
        class_name: []const u8,
        name: []const u8,
        descriptor: []const u8,
    },
    NameAndType: struct {
        name: []const u8,
        descriptor: []const u8,
    },
    MethodHandle: struct {
        reference_kind: u8,
        reference: []const u8,
    },
    MethodType: struct {
        descriptor: []const u8,
    },
    InvokeDynamic: struct {
        // TODO: implement
    },
};

pub const FieldInfo = struct {
    access_flags: u.FieldAccessFlags,
    name: []const u8,
    descriptor: []const u8,
    attributes: []const Attribute,
    ty: u.Ty,
};

pub const MethodInfo = struct {
    access_flags: u.MethodAccessFlags,
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

pub const Annotation = struct {
    const ElementValue = struct {
        name: []const u8,
        value: struct {}, // TODO: implement
    };

    type_descriptor: []const u8,
    element_value_pairs: []const ElementValue,
};

pub const Attribute = struct {
    name: []const u8,
    info: union(enum) {
        Unsupported: struct {},
        ConstantValue: struct { value: CPInfo },
        Code: CodeAttribute,
        Annotations: []const Annotation,
    },

    fn read(reader: std.io.AnyReader, allocator: std.mem.Allocator, constant_pool: []const CPInfo) error{ OutOfMemory, BadClassFile }!Attribute {
        const attribute_name_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
        const attribute_length = reader.readInt(u32, u.endian) catch return error.BadClassFile;
        const name = constant_pool[attribute_name_index].Utf8;
        if (std.mem.eql(u8, name, "ConstantValue")) {
            const constant_value_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
            return Attribute{
                .name = name,
                .info = .{ .ConstantValue = .{ .value = constant_pool[constant_value_index] } },
            };
        } else if (std.mem.eql(u8, name, "Code")) {
            const max_stack = reader.readInt(u16, u.endian) catch return error.BadClassFile;
            const max_locals = reader.readInt(u16, u.endian) catch return error.BadClassFile;
            const code_length = reader.readInt(u32, u.endian) catch return error.BadClassFile;
            const code = try allocator.alloc(u8, code_length);
            if ((reader.readAll(code) catch return error.BadClassFile) != code_length) {
                return error.BadClassFile;
            }
            const exception_table_length = reader.readInt(u16, u.endian) catch return error.BadClassFile;
            const exception_table = try allocator.alloc(ExceptionTableEntry, exception_table_length);
            for (exception_table) |*entry| {
                const start_pc = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                const end_pc = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                const handler_pc = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                const catch_type = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                entry.* = ExceptionTableEntry{
                    .start_pc = start_pc,
                    .end_pc = end_pc,
                    .handler_pc = handler_pc,
                    .catch_type = catch_type,
                };
            }
            const attributes_count = reader.readInt(u16, u.endian) catch return error.BadClassFile;
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
        } else if (std.mem.eql(u8, name, "Signature") or std.mem.eql(u8, name, "StackMapTable") or std.mem.eql(u8, name, "Exceptions") or std.mem.eql(u8, name, "Deprecated") or std.mem.eql(u8, name, "LineNumberTable")) {
            // unsupported
            reader.skipBytes(attribute_length, .{}) catch return error.BadClassFile;
            // std.log.warn("unsupported attribute: {s}", .{name});
            return Attribute{
                .name = name,
                .info = .{ .Unsupported = .{} },
            };
        } else if (std.mem.eql(u8, name, "RuntimeVisibleAnnotations")) {
            const num_annotations = reader.readInt(u16, u.endian) catch return error.BadClassFile;
            const annotations = try allocator.alloc(Annotation, num_annotations);
            errdefer allocator.free(annotations);
            for (annotations) |*annotation| {
                const type_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                const type_descriptor = constant_pool[type_index].Utf8;
                const num_element_value_pairs = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                const element_value_pairs = try allocator.alloc(Annotation.ElementValue, num_element_value_pairs);
                for (element_value_pairs) |*pair| {
                    const element_name_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                    const element_name = constant_pool[element_name_index].Utf8;
                    pair.* = .{ .name = element_name, .value = .{} };
                }
                annotation.* = Annotation{
                    .type_descriptor = type_descriptor,
                    .element_value_pairs = element_value_pairs,
                };
            }

            return Attribute{
                .name = name,
                .info = .{ .Annotations = annotations },
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
access_flags: u.ClassAccessFlags,
this_class: []const u8,
super_class: ?[]const u8,
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
pub fn read(reader: std.io.AnyReader, user_allocator: std.mem.Allocator) error{ OutOfMemory, BadClassFile }!Self {
    // allocate in arena
    var arena = std.heap.ArenaAllocator.init(user_allocator);
    errdefer arena.deinit(); // in case of error, deallocate the whole arena
    const allocator = arena.allocator();

    const magic = reader.readInt(u32, u.endian) catch return error.BadClassFile;
    if (magic != 0xCAFEBABE) {
        std.log.err("invalid magic number: 0x{X}", .{magic});
        return error.BadClassFile;
    }
    const minor_version = reader.readInt(u16, u.endian) catch return error.BadClassFile;
    const major_version = reader.readInt(u16, u.endian) catch return error.BadClassFile;

    // std.log.debug("version: {d}.{d}", .{ major_version, minor_version });

    // first, we extract only sizes of all structures, then alloc, then read again
    const constant_pool_count = reader.readInt(u16, u.endian) catch return error.BadClassFile;
    // std.log.debug("constant_pool_count: {d}", .{constant_pool_count});
    // temporary storage
    const raw_constant_pool = try user_allocator.alloc(RawCPInfo, constant_pool_count);
    defer user_allocator.free(raw_constant_pool);
    @memset(raw_constant_pool, .Undefined);
    var i: u32 = 1;
    while (i < constant_pool_count) : (i += 1) {
        const cp_info = &raw_constant_pool[i];
        const tag = reader.readInt(u8, u.endian) catch return error.BadClassFile;
        cp_info.* = switch (tag) {
            0 => RawCPInfo{ .Undefined = .{} },
            1 => blk: {
                const len = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                const bytes = allocator.alloc(u8, len) catch return error.BadClassFile;
                if ((reader.read(bytes) catch return error.BadClassFile) != len) {
                    return error.BadClassFile;
                }
                break :blk RawCPInfo{ .Utf8 = bytes };
            },
            10 => blk: {
                const class_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                const name_and_type_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                break :blk RawCPInfo{ .MethodRef = .{ .class_index = class_index, .name_and_type_index = name_and_type_index } };
            },
            7 => blk: {
                const name_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                break :blk RawCPInfo{ .ClassInfo = .{ .name_index = name_index } };
            },
            12 => blk: {
                const name_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                const descriptor_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                break :blk RawCPInfo{ .NameAndType = .{ .name_index = name_index, .descriptor_index = descriptor_index } };
            },
            9 => blk: {
                const class_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                const name_and_type_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                break :blk RawCPInfo{ .FieldRef = .{ .class_index = class_index, .name_and_type_index = name_and_type_index } };
            },
            8 => blk: {
                const string_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                break :blk RawCPInfo{ .String = .{ .string_index = string_index } };
            },
            3 => blk: {
                const value = reader.readInt(i32, u.endian) catch return error.BadClassFile;
                break :blk RawCPInfo{ .Integer = value };
            },
            5 => blk: {
                const high_bytes: u64 = @byteSwap(reader.readInt(u32, u.endian) catch return error.BadClassFile);
                const low_bytes: u64 = @byteSwap(reader.readInt(u32, u.endian) catch return error.BadClassFile);
                const bits = (high_bytes << 32) | low_bytes;
                i += 1;
                raw_constant_pool[i] = .Undefined;
                break :blk RawCPInfo{ .Long = @bitCast(bits) };
            },
            6 => blk: {
                const high_bytes: u64 = @byteSwap(reader.readInt(u32, u.endian) catch return error.BadClassFile);
                const low_bytes: u64 = @byteSwap(reader.readInt(u32, u.endian) catch return error.BadClassFile);
                const bits = (high_bytes << 32) | low_bytes;
                i += 1;
                raw_constant_pool[i] = .Undefined;
                break :blk RawCPInfo{ .Double = @bitCast(bits) };
            },
            11 => blk: {
                const class_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                const name_and_type_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
                break :blk RawCPInfo{ .InterfaceMethodRef = .{ .class_index = class_index, .name_and_type_index = name_and_type_index } };
            },
            4 => blk: {
                const value: f32 = @bitCast(reader.readInt(i32, u.endian) catch return error.BadClassFile);
                break :blk RawCPInfo{ .Float = value };
            },
            else => {
                std.debug.panic("tried to handle constant pool tag {d}", .{tag});
            },
        };
        // std.log.debug("[{d}] -- {}", .{ i, std.json.fmt(cp_info.*, .{}) });
    }

    const constant_pool = try allocator.alloc(CPInfo, constant_pool_count);
    for (raw_constant_pool, constant_pool) |rcpi, *cp_info| {
        cp_info.* = switch (rcpi) {
            .Undefined => blk: {
                break :blk CPInfo{ .Undefined = .{} };
            },
            .Utf8 => |bytes| blk: {
                break :blk CPInfo{ .Utf8 = bytes };
            },
            .MethodRef => |mr| blk: {
                break :blk CPInfo{ .MethodRef = .{
                    .class_name = raw_constant_pool[raw_constant_pool[mr.class_index].ClassInfo.name_index].Utf8,
                    .name = raw_constant_pool[raw_constant_pool[mr.name_and_type_index].NameAndType.name_index].Utf8,
                    .descriptor = raw_constant_pool[raw_constant_pool[mr.name_and_type_index].NameAndType.descriptor_index].Utf8,
                } };
            },
            .ClassInfo => |ci| blk: {
                break :blk CPInfo{ .ClassInfo = raw_constant_pool[ci.name_index].Utf8 };
            },
            .NameAndType => |nat| blk: {
                break :blk CPInfo{ .NameAndType = .{
                    .name = raw_constant_pool[nat.name_index].Utf8,
                    .descriptor = raw_constant_pool[nat.descriptor_index].Utf8,
                } };
            },
            .FieldRef => |fr| blk: {
                break :blk CPInfo{ .FieldRef = .{
                    .class_name = raw_constant_pool[raw_constant_pool[fr.class_index].ClassInfo.name_index].Utf8,
                    .name = raw_constant_pool[raw_constant_pool[fr.name_and_type_index].NameAndType.name_index].Utf8,
                    .descriptor = raw_constant_pool[raw_constant_pool[fr.name_and_type_index].NameAndType.descriptor_index].Utf8,
                } };
            },
            .String => |string| blk: {
                break :blk CPInfo{ .String = raw_constant_pool[string.string_index].Utf8 };
            },
            .Integer => |integer| blk: {
                break :blk CPInfo{ .Integer = integer };
            },
            .InterfaceMethodRef => |imr| blk: {
                break :blk CPInfo{ .InterfaceMethodRef = .{
                    .class_name = raw_constant_pool[raw_constant_pool[imr.class_index].ClassInfo.name_index].Utf8,
                    .name = raw_constant_pool[raw_constant_pool[imr.name_and_type_index].NameAndType.name_index].Utf8,
                    .descriptor = raw_constant_pool[raw_constant_pool[imr.name_and_type_index].NameAndType.descriptor_index].Utf8,
                } };
            },
            .Float => |float| blk: {
                break :blk CPInfo{ .Float = float };
            },
            .Long => |long| blk: {
                break :blk CPInfo{ .Long = long };
            },
            .Double => |double| blk: {
                break :blk CPInfo{ .Double = double };
            },
            .MethodHandle => |mh| blk: {
                break :blk CPInfo{ .MethodHandle = .{
                    .reference_kind = mh.reference_kind,
                    .reference = raw_constant_pool[mh.reference_index].Utf8,
                } };
            },
            .MethodType => |mt| blk: {
                break :blk CPInfo{ .MethodType = .{
                    .descriptor = raw_constant_pool[mt.descriptor_index].Utf8,
                } };
            },
            .InvokeDynamic => blk: {
                break :blk CPInfo{ .InvokeDynamic = .{} }; // TODO: Implement
            },
        };
    }

    const access_flags: u.ClassAccessFlags = @bitCast(reader.readInt(u16, u.endian) catch return error.BadClassFile);

    const this_class_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
    const this_class = constant_pool[this_class_index].ClassInfo;

    const super_class_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
    var super_class: ?[]const u8 = null;
    if (super_class_index != 0) {
        super_class = constant_pool[super_class_index].ClassInfo;
    }

    const interfaces_count = reader.readInt(u16, u.endian) catch return error.BadClassFile;
    const interfaces = try allocator.alloc(u16, interfaces_count);
    // std.log.debug("interfaces_count: {d}", .{interfaces_count});
    for (interfaces) |*interface| {
        interface.* = reader.readInt(u16, u.endian) catch return error.BadClassFile;
        // std.log.debug("\tinterface: {d}", .{interface.*});
    }
    const fields_count = reader.readInt(u16, u.endian) catch return error.BadClassFile;
    // std.log.debug("fields_count: {d}", .{fields_count});
    const fields = try allocator.alloc(FieldInfo, fields_count);
    for (fields) |*field| {
        const field_access_flags: u.FieldAccessFlags = @bitCast(reader.readInt(u16, u.endian) catch return error.BadClassFile);
        const name_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
        const descriptor_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
        const attributes_count = reader.readInt(u16, u.endian) catch return error.BadClassFile;
        const attributes = try allocator.alloc(Attribute, attributes_count);
        for (attributes) |*attribute| {
            attribute.* = try Attribute.read(reader, allocator, constant_pool);
        }

        field.* = FieldInfo{
            .access_flags = field_access_flags,
            .name = constant_pool[name_index].Utf8,
            .descriptor = constant_pool[descriptor_index].Utf8,
            .attributes = attributes,
            .ty = u.Ty.fromDescriptor(constant_pool[descriptor_index].Utf8[0]),
        };
        // std.log.debug("{}", .{std.json.fmt(field.*, .{})});
    }
    const methods_count = reader.readInt(u16, u.endian) catch return error.BadClassFile;
    // std.log.debug("methods_count: {d}", .{methods_count});
    const methods = try allocator.alloc(MethodInfo, methods_count);
    for (methods) |*method| {
        const method_access_flags = reader.readInt(u16, u.endian) catch return error.BadClassFile;
        const name_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
        const descriptor_index = reader.readInt(u16, u.endian) catch return error.BadClassFile;
        const attributes_count = reader.readInt(u16, u.endian) catch return error.BadClassFile;
        const attributes = try allocator.alloc(Attribute, attributes_count);
        for (attributes) |*attribute| {
            attribute.* = try Attribute.read(reader, allocator, constant_pool);
        }

        method.* = MethodInfo{
            .access_flags = @bitCast(method_access_flags),
            .name = constant_pool[name_index].Utf8,
            .descriptor = constant_pool[descriptor_index].Utf8,
            .attributes = attributes,
        };
        // std.log.debug("{}", .{std.json.fmt(method.*, .{})});
    }
    // TODO: read class-attributes
    // const attributes_count = try reader.read(u16, u.endian);
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
