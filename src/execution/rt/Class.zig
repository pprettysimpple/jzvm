/// Runtime representation of a class.
/// runtime class is resolved using RawClassFile and driver
const std = @import("std");
const RawClassFile = @import("../../class-loading/root.zig").RawClassFile;
const Driver = @import("../Driver.zig");
const Self = @This();

allocator: std.mem.Allocator,
driver: *Driver,
class_file: RawClassFile,
initialized: bool,
static_fields: []u64,
static_fields_size: u32,
constant_pool_mapping: []?*u64, // TODO: Should it be only for u64
method_to_code: []?RawClassFile.CodeAttribute,

// Takes ownership of this the RawClassFile
pub fn init(allocator: std.mem.Allocator, driver: *Driver, class_file: RawClassFile) !Self {
    var static_fields_size: u32 = 0;
    for (class_file.fields) |field| {
        if (field.access_flags.static) {
            static_fields_size += 1;
        }
    }
    const static_fields = try allocator.alloc(u64, static_fields_size);
    errdefer allocator.free(static_fields);

    const constant_pool_mapping = try allocator.alloc(?*u64, class_file.constant_pool.len);
    errdefer allocator.free(constant_pool_mapping);

    const method_to_code = try allocator.alloc(?RawClassFile.CodeAttribute, class_file.methods.len);

    return Self{
        .allocator = allocator,
        .driver = driver,
        .class_file = class_file,
        .initialized = false,
        .static_fields = static_fields,
        .static_fields_size = 0,
        .constant_pool_mapping = constant_pool_mapping,
        .method_to_code = method_to_code,
    };
}

pub fn deinit(self: *Self) void {
    self.allocator.free(self.static_fields);
    self.allocator.free(self.constant_pool_mapping);
}

pub fn try_clinit(self: *Self) void {
    if (self.initialized) {
        return;
    }

    // FIXME: Error set can not be inferred here, suppress compile errors for now
    const resolved_clinit = self.driver.resolve(self.class_file.this_class, "<clinit>", "()V") catch unreachable;
    self.driver.engine.runMethod(self.driver, resolved_clinit.class, resolved_clinit.method_id) catch unreachable;
}

pub fn resolve_constant_pool_entry(self: *Self, constant_pool_id: u32) *u64 {
    return self.constant_pool_mapping[constant_pool_id] orelse {
        self.constant_pool_mapping[constant_pool_id] = blk: {
            const cp_info = self.class_file.constant_pool[constant_pool_id];
            switch (cp_info) {
                .FieldRef => |fr| {
                    if (std.mem.eql(u8, self.class_file.constant_pool[self.class_file.constant_pool[fr.class_index].ClassInfo.name_index].Utf8, self.class_file.this_class)) {
                        // TODO: Check fr.name_and_type_index maybe?
                        self.static_fields_size += 1;
                        break :blk &self.static_fields[self.static_fields_size - 1];
                    } else {
                        std.debug.panic("Resolving fields from other classes is not implemented yet", .{});
                    }
                },
                else => std.debug.panic("Resolving this constant pool entry is not implemented yet: {}", .{cp_info}),
            }
        };
        return self.constant_pool_mapping[constant_pool_id].?;
    };
}

pub fn put_static_field(self: *Self, constant_pool_id: u32, value: u64) void {
    self.try_clinit();
    self.resolve_constant_pool_entry(constant_pool_id).* = value;
}

pub fn get_code(self: *Self, method_id: u32) !RawClassFile.CodeAttribute {
    return self.method_to_code[method_id] orelse {
        const method = self.class_file.methods[method_id];
        for (method.attributes) |attr| {
            switch (attr.info) {
                .Code => |code| {
                    self.method_to_code[method_id] = code;
                    return code;
                },
                else => continue,
            }
        }
    };
}
