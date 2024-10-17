/// Runtime representation of a class.
/// runtime class is resolved using RawClassFile and driver
const std = @import("std");
const RawClassFile = @import("../../class-loading/root.zig").RawClassFile;
const Driver = @import("../Driver.zig");
const common = @import("../../common.zig");
const Self = @This();

allocator: std.mem.Allocator,
driver: *Driver,
class_file: RawClassFile,
initialized: bool,
static_fields: std.ArrayList(u64),
constant_pool_mapping: []?ResolvedCPEntry,
method_to_code: []?RawClassFile.CodeAttribute,

const ResolvedCPEntry = union {
    boolean: common.JavaType.Boolean,
    byte: common.JavaType.Byte,
    char: common.JavaType.Char,
    short: common.JavaType.Short,
    int: common.JavaType.Int,
    long: common.JavaType.Long,
    float: common.JavaType.Float,
    double: common.JavaType.Double,
    string: []const u8,
    field: *u64,
    method: struct {
        class: *Self, // TODO: How to track this cross-references?
        method_id: u32,
    },
};

// Takes ownership of this the RawClassFile
pub fn init(allocator: std.mem.Allocator, driver: *Driver, class_file: RawClassFile) !Self {
    var static_fields_size: u32 = 0;
    for (class_file.fields) |field| {
        if (field.access_flags.static) {
            static_fields_size += 1;
        }
    }
    const static_fields = try std.ArrayList(u64).initCapacity(allocator, static_fields_size);
    errdefer static_fields.deinit();

    const constant_pool_mapping = try allocator.alloc(?ResolvedCPEntry, class_file.constant_pool.len);
    @memset(constant_pool_mapping, null);
    errdefer allocator.free(constant_pool_mapping);

    const method_to_code = try allocator.alloc(?RawClassFile.CodeAttribute, class_file.methods.len);
    @memset(method_to_code, null);

    return Self{
        .allocator = allocator,
        .driver = driver,
        .class_file = class_file,
        .initialized = false,
        .static_fields = static_fields,
        .constant_pool_mapping = constant_pool_mapping,
        .method_to_code = method_to_code,
    };
}

pub fn deinit(self: *Self) void {
    self.static_fields.deinit();
    self.allocator.free(self.constant_pool_mapping);
    self.allocator.free(self.method_to_code);
    self.class_file.deinit();
}

pub fn try_clinit(self: *Self) void {
    if (self.initialized) {
        return;
    }

    self.initialized = true;
    // FIXME: Error set can not be inferred here, suppress compile errors for now
    const resolved_clinit = self.driver.resolveClassMethod(self.class_file.this_class, "<clinit>", "()V") catch return; // if there is no clinit, it's ok
    self.driver.engine.runMethod(self.driver, resolved_clinit.class, resolved_clinit.method_id) catch unreachable; // but if invocation fails, it's a bug
}

pub fn resolve_constant_pool_entry(self: *Self, constant_pool_id: u32) ResolvedCPEntry {
    self.try_clinit();
    self.constant_pool_mapping[constant_pool_id] = blk: {
        const cp_info = self.class_file.constant_pool[constant_pool_id];
        switch (cp_info) {
            .FieldRef => |fr| {
                if (std.mem.eql(u8, fr.class_name, self.class_file.this_class)) {
                    // TODO: Check fr.name_and_type_index maybe?
                    break :blk .{ .field = self.static_fields.addOne() catch unreachable };
                }

                // it is an other class and we must aquire it's *Class ptr and static field id
                const other_class = self.driver.resolveClass(fr.class_name) catch unreachable; // TODO: Recover with exception
                // find this field ref in other classe's constant pool
                for (other_class.class_file.constant_pool, 0..other_class.class_file.constant_pool.len) |other_cp_info, idx| {
                    switch (other_cp_info) {
                        .FieldRef => |other_fr| {
                            if (std.mem.eql(u8, fr.class_name, other_fr.class_name) and std.mem.eql(u8, fr.name, other_fr.name)) {
                                break :blk other_class.cached_resolve_constant_pool_entry(@intCast(idx));
                            }
                        },
                        else => {},
                    }
                }

                std.debug.panic("FieldRef not found in other class: {s}.{s}", .{ fr.class_name, fr.name });
            },
            .MethodRef => |mr| {
                // cycle through our methods and try to find the desired one
                for (self.class_file.methods, 0..self.class_file.methods.len) |method, idx| {
                    if (std.mem.eql(u8, method.name, mr.name) and std.mem.eql(u8, method.descriptor, mr.descriptor)) {
                        break :blk .{ .method = .{ .class = self, .method_id = @intCast(idx) } };
                    }
                }

                const other_class = self.driver.resolveClass(mr.class_name) catch unreachable; // TODO: Recover with exception

                // cycle through other_class constant pool and find this method ref
                for (other_class.class_file.constant_pool, 0..other_class.class_file.constant_pool.len) |other_cp_info, idx| {
                    switch (other_cp_info) {
                        .MethodRef => |other_mr| {
                            if (std.mem.eql(
                                u8,
                                mr.class_name,
                                other_mr.class_name,
                            ) and std.mem.eql(
                                u8,
                                mr.name,
                                other_mr.name,
                            ) and std.mem.eql(
                                u8,
                                mr.descriptor,
                                other_mr.descriptor,
                            )) {
                                break :blk other_class.cached_resolve_constant_pool_entry(@intCast(idx));
                            }
                        },
                        else => {},
                    }
                }

                std.debug.panic("MethodRef not found in other class: {s}.{s} {s}", .{ mr.class_name, mr.name, mr.descriptor });
            },
            else => std.debug.panic("Resolving this constant pool entry is not implemented yet: {}", .{cp_info}),
        }
    };
    return self.constant_pool_mapping[constant_pool_id].?;
}

pub fn cached_resolve_constant_pool_entry(self: *Self, constant_pool_id: u32) ResolvedCPEntry {
    return self.constant_pool_mapping[constant_pool_id] orelse self.resolve_constant_pool_entry(constant_pool_id);
}

pub fn get_method_info(self: *Self, method_id: u32) RawClassFile.MethodInfo {
    return self.class_file.methods[method_id];
}

pub fn get_method_code(self: *Self, method_id: u32) !RawClassFile.CodeAttribute {
    return self.method_to_code[method_id] orelse {
        const method = self.class_file.methods[method_id];
        for (method.attributes) |attr| {
            switch (attr.info) {
                .Code => |code| {
                    self.method_to_code[method_id] = code;
                    return code;
                },
                else => {},
            }
        }
        return error.MissingCodeAttribute;
    };
}
