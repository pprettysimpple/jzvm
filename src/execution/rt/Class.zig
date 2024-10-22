/// Runtime representation of a class -- Class object
/// resolves constant pool entries on-demand
const Self = @This();
const std = @import("std");
const RawClassFile = @import("../../class-loading/root.zig").RawClassFile;
const Driver = @import("../Driver.zig");
const Object = @import("Object.zig");
const string = @import("../string.zig");
const u = @import("../../common.zig");

allocator: std.mem.Allocator,
driver: *Driver,
class_file: RawClassFile,
initialized: bool,
static_fields: std.ArrayList(u.TyValue),
constant_pool_mapping: []?ResolvedCPEntry,
method_to_code: []?RawClassFile.CodeAttribute,

const ResolvedCPEntry = union(enum) {
    value: u.TyValue,
    static_field: *u.TyValue,
    class: *Self,
    method: struct {
        class: *Self, // TODO: How to go from Class to Object with that Class?
        method_id: u32,
        return_ty: ?u.Ty,
        args: []u.Ty,
    },

    pub fn deinit(self: ResolvedCPEntry, allocator: std.mem.Allocator) void {
        switch (self) {
            .value => {
                if (self.value.ty == u.Ty.reference) {
                    self.value.v.reference.deinit();
                }
            },
            .static_field => {},
            .class => {},
            .method => {
                allocator.free(self.method.args);
            },
        }
    }
};

// Takes ownership of this the RawClassFile
pub fn init(allocator: std.mem.Allocator, driver: *Driver, class_file: RawClassFile) !Self {
    var static_fields_size: u32 = 0;
    for (class_file.fields) |field| {
        if (field.access_flags.static) {
            static_fields_size += 1;
        }
    }
    var static_fields = try std.ArrayList(u.TyValue).initCapacity(allocator, static_fields_size);
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
    for (self.static_fields.items) |field| {
        if (field.ty == u.Ty.reference) {
            field.v.reference.deinit();
        }
    }
    for (self.constant_pool_mapping) |entry| if (entry) |e| {
        e.deinit(self.allocator);
    };
    self.static_fields.deinit();
    self.allocator.free(self.constant_pool_mapping);
    self.allocator.free(self.method_to_code);
    self.class_file.deinit();
}

pub fn tryClinit(self: *Self) void {
    if (self.initialized) {
        return;
    }

    self.initialized = true;
    // FIXME: Error set can not be inferred here, suppress compile errors for now
    const resolved_clinit = self.driver.resolveClassMethod(self.class_file.this_class, "<clinit>", "()V") catch return; // if there is no clinit, it's ok
    self.driver.interpreter.runMethod(self.driver, .{ .class = resolved_clinit.class }, resolved_clinit.method_id) catch unreachable; // but if invocation fails, it's a bug
}

pub fn resolveConstantPoolEntry(self: *Self, constant_pool_id: u32) ResolvedCPEntry {
    self.tryClinit();
    self.constant_pool_mapping[constant_pool_id] = blk: {
        const cp_info = self.class_file.constant_pool[constant_pool_id];
        switch (cp_info) {
            .FieldRef => |fr| {
                std.log.debug("Resolving field_ref for {s}", .{self.class_file.this_class});
                if (std.mem.eql(u8, fr.class_name, self.class_file.this_class)) {
                    // TODO: Check fr.name_and_type_index maybe?
                    const ty = u.Ty.fromDescriptor(fr.descriptor[0]);
                    const ptr = self.static_fields.addOne() catch unreachable;
                    ptr.* = .{ .v = ty.defaultValue(), .ty = ty };
                    break :blk .{ .static_field = ptr };
                }

                // it is an other class and we must aquire it's *Class ptr and static field id
                const other_class = self.driver.resolveClass(fr.class_name) catch unreachable; // TODO: Recover with exception
                // find this field ref in other classe's constant pool
                for (other_class.class_file.constant_pool, 0..other_class.class_file.constant_pool.len) |other_cp_info, idx| {
                    switch (other_cp_info) {
                        .FieldRef => |other_fr| {
                            if (std.mem.eql(u8, fr.class_name, other_fr.class_name) and std.mem.eql(u8, fr.name, other_fr.name)) {
                                break :blk other_class.cachedResolveConstantPoolEntry(@intCast(idx));
                            }
                        },
                        else => {},
                    }
                }

                std.debug.panic("FieldRef not found in other class: {s}.{s}", .{ fr.class_name, fr.name });
            },
            .MethodRef => |mr| {
                std.log.debug("Resolving method_ref for {s}", .{self.class_file.this_class});
                // cycle through our methods and try to find the desired one
                for (self.class_file.methods, 0..self.class_file.methods.len) |method, idx| {
                    if (std.mem.eql(u8, method.name, mr.name) and std.mem.eql(u8, method.descriptor, mr.descriptor)) {
                        // if (!method.access_flags.static) {
                        //     std.debug.panic("MethodRef to non-static method is not supported: {s}.{s}", .{ mr.class_name, mr.name });
                        // }
                        const parsed = u.parseMethodDescriptor(self.allocator, mr.descriptor) catch unreachable; // TODO: Recover with exception
                        break :blk .{ .method = .{
                            .class = self,
                            .method_id = @intCast(idx),
                            .return_ty = parsed.return_ty,
                            .args = parsed.args,
                        } };
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
                                break :blk other_class.cachedResolveConstantPoolEntry(@intCast(idx));
                            }
                        },
                        else => {},
                    }
                }

                std.debug.panic("MethodRef not found in other class: {s}.{s} {s}. Resolution from base class is not implemented", .{ mr.class_name, mr.name, mr.descriptor });
            },
            .Integer => |integer| {
                break :blk .{ .value = .{ .v = .{ .int = integer }, .ty = u.Ty.int } };
            },
            .String => |utf8| {
                const v = u.Value{ .reference = .{ .class = string.initFromUTF8(self.driver, utf8) catch unreachable } }; // TODO: Recover with exception
                break :blk .{ .value = .{ .v = v, .ty = u.Ty.reference } };
            },
            .ClassInfo => |class_info| {
                std.log.debug("Resolving class_info {s} for {s}", .{ class_info, self.class_file.this_class });
                if (std.mem.eql(u8, class_info, self.class_file.this_class)) {
                    std.log.debug("Resolving class_info for {s} is self", .{self.class_file.this_class});
                    break :blk .{ .class = self };
                }

                const other_class = self.driver.resolveClass(class_info) catch unreachable; // TODO: Recover with exception
                std.log.debug("Resolving class_info for {s} is other", .{class_info});
                break :blk .{ .class = other_class };
            },
            else => std.debug.panic("Resolving this constant pool entry is not implemented yet: {}", .{cp_info}),
        }
    };
    return self.constant_pool_mapping[constant_pool_id].?;
}

pub fn cachedResolveConstantPoolEntry(self: *Self, constant_pool_id: u32) ResolvedCPEntry {
    const entry = self.constant_pool_mapping[constant_pool_id] orelse self.resolveConstantPoolEntry(constant_pool_id);
    return switch (entry) {
        .value => |ty_val| {
            if (ty_val.ty == u.Ty.reference) {
                return .{ .value = .{ .v = .{ .reference = ty_val.v.reference.clone() }, .ty = ty_val.ty } };
            }
            return entry;
        },
        else => entry,
    };
}

pub fn resolveMethodInThisClass(self: *Self, method_name: []const u8, method_descriptor: []const u8) ?u32 {
    for (self.class_file.methods, 0..self.class_file.methods.len) |method, idx| {
        if (std.mem.eql(u8, method.name, method_name) and std.mem.eql(u8, method.descriptor, method_descriptor)) {
            return @intCast(idx);
        }
    }
    return null;
}

pub fn getMethodInfoById(self: *Self, method_id: u32) RawClassFile.MethodInfo {
    return self.class_file.methods[method_id];
}

pub fn getMethodCodeById(self: *Self, method_id: u32) ?RawClassFile.CodeAttribute {
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
        return null;
    };
}
