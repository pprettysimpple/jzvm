/// Runtime representation of a class -- Class object
/// resolves constant pool entries on-demand
const Self = @This();
const std = @import("std");
const cl = @import("../../class-loading/root.zig");
const RawClassFile = cl.RawClassFile;
const Interpreter = @import("../Interpreter.zig");
const ClassLoader = cl.ClassLoader;
const Object = @import("Object.zig");
const string = @import("../string.zig");
const Heap = @import("Heap.zig");
const u = @import("../../common.zig");

allocator: std.mem.Allocator,
class_loader: *ClassLoader,
class_file: RawClassFile,
initialized: bool,
static_fields: []u.TyValue, // only for this class
flat_fields: []RawClassFile.FieldInfo, // for this class and all super classes
constant_pool_mapping: []?ResolvedCPEntry,
resolved_methods: []ResolvedMethod,

pub const ResolvedMethod = struct {
    class: *Self,
    method_id: u32,
    return_ty: ?u.Ty, // null for void
    args: []u.Ty, // does not own
    code: ?RawClassFile.CodeAttribute,
    info: RawClassFile.MethodInfo,
};

const ResolvedCPEntry = union(enum) {
    value: u.TyValue,
    field: AnyField,
    class: *Self,
    method: ResolvedMethod,

    pub fn deinit(self: ResolvedCPEntry) void {
        switch (self) {
            .value => {
                if (self.value.ty == u.Ty.reference) {
                    self.value.v.reference.deinit();
                }
            },
            .field => {},
            .class => {},
            .method => {},
        }
    }
};

// Takes ownership of this the RawClassFile, initialized over existing storage to have inside references to this class
pub fn init(self_storage: *Self, allocator: std.mem.Allocator, class_loader: *ClassLoader, class_file: RawClassFile) error{ OutOfMemory, InvalidMethodDescriptor, InvalidFieldDescriptor }!void {
    var static_fields_size: u32 = 0;
    for (class_file.fields) |field| {
        if (field.access_flags.static) {
            static_fields_size += 1;
        }
    }
    var static_fields = try allocator.alloc(u.TyValue, static_fields_size);
    errdefer allocator.free(static_fields);
    var static_field_idx: u32 = 0;
    for (class_file.fields) |field| {
        if (!field.access_flags.static) {
            continue;
        }
        const ty = u.Ty.fromDescriptor(field.descriptor[0]);
        const value = ty.defaultValue();
        static_fields[static_field_idx] = .{ .ty = ty, .v = value };
        static_field_idx += 1;
    }

    const constant_pool_mapping = try allocator.alloc(?ResolvedCPEntry, class_file.constant_pool.len);
    errdefer allocator.free(constant_pool_mapping);
    @memset(constant_pool_mapping, null);

    const methods = try allocator.alloc(ResolvedMethod, class_file.methods.len);
    errdefer allocator.free(methods); // TODO: Deal with leak on error
    for (class_file.methods, 0..class_file.methods.len) |method, idx| {
        const parsed = u.parseMethodDescriptor(allocator, method.descriptor) catch |err| {
            // cleanup
            for (0..idx) |i| {
                allocator.free(methods[i].args);
            }
            return err;
        }; // TODO: Recover with exception
        methods[idx] = .{
            .class = self_storage,
            .method_id = @intCast(idx),
            .return_ty = parsed.return_ty,
            .args = parsed.args,
            .code = blk: {
                for (method.attributes) |attr| {
                    switch (attr.info) {
                        .Code => |code| {
                            break :blk code;
                        },
                        else => {},
                    }
                }
                break :blk null;
            },
            .info = class_file.methods[idx],
        };
    }

    const parent_fields: []RawClassFile.FieldInfo = if (class_file.super_class) |super| (class_loader.resolveClass(super) catch unreachable).flat_fields else &[_]RawClassFile.FieldInfo{};
    const flat_fields_size = class_file.fields.len - static_fields_size + parent_fields.len;
    const flat_fields = try allocator.alloc(RawClassFile.FieldInfo, flat_fields_size);
    errdefer allocator.free(flat_fields);
    @memcpy(flat_fields[0..parent_fields.len], parent_fields);
    var i: usize = parent_fields.len;
    for (class_file.fields) |field| {
        if (field.access_flags.static) {
            continue;
        }
        flat_fields[i] = field;
        i += 1;
    }

    std.log.info("Init class {s} with {d} static fields", .{ class_file.this_class, static_fields_size });

    self_storage.* = Self{
        .allocator = allocator,
        .class_loader = class_loader,
        .class_file = class_file,
        .initialized = false,
        .static_fields = static_fields,
        .flat_fields = flat_fields,
        .constant_pool_mapping = constant_pool_mapping,
        .resolved_methods = methods,
    };
}

pub fn deinit(self: *Self) void {
    for (self.static_fields) |field| {
        if (field.ty == u.Ty.reference) {
            field.v.reference.deinit();
        }
    }
    for (self.constant_pool_mapping) |entry| if (entry) |e| {
        e.deinit();
    };
    for (self.resolved_methods) |method| {
        self.allocator.free(method.args);
    }
    self.allocator.free(self.resolved_methods);
    self.allocator.free(self.flat_fields);
    self.allocator.free(self.static_fields);
    self.allocator.free(self.constant_pool_mapping);
    self.class_file.deinit();
}

pub fn tryClinit(self: *Self) void {
    if (self.initialized) {
        return;
    }

    self.initialized = true;
    const resolved_clinit = self.resolveMethodInThisClass("<clinit>", "()V") orelse return;
    Interpreter.current.runMethod(Heap.Ref(Object).initNull(), resolved_clinit) catch unreachable; // but if invocation fails, it's a bug
}

fn resolveConstantPoolEntryImpl(self: *Self, constant_pool_id: u32) ResolvedCPEntry {
    self.tryClinit();
    self.constant_pool_mapping[constant_pool_id] = blk: {
        const cp_info = self.class_file.constant_pool[constant_pool_id];
        switch (cp_info) {
            .FieldRef => |fr| {
                std.log.debug("Resolving field_ref {s} for {s}", .{ fr.name, self.class_file.this_class });
                if (std.mem.eql(u8, fr.class_name, self.class_file.this_class)) {
                    break :blk .{
                        .field = self.resolveFieldInThisClassOrSuper(fr) orelse {
                            std.debug.panic("FieldRef not found in this class: {s}.{s}", .{ fr.class_name, fr.name });
                        },
                    };
                }

                const other_class = self.class_loader.resolveClass(fr.class_name) catch {
                    std.debug.panic("FieldRef class not found: {s}", .{fr.class_name});
                }; // TODO: Recover with exception

                break :blk .{ .field = other_class.resolveFieldInThisClassOrSuper(fr) orelse {
                    std.debug.panic("FieldRef not found in other class: {s}.{s}", .{ fr.class_name, fr.name });
                } };
            },
            .MethodRef => |mr| {
                std.log.debug("Resolving method_ref {s}.{s} {s}", .{ mr.class_name, mr.name, mr.descriptor });
                if (std.mem.eql(u8, mr.class_name, self.class_file.this_class)) {
                    // cycle through our methods and try to find the desired one
                    break :blk .{ .method = self.resolveMethodInThisClassOrSuper(mr.name, mr.descriptor) orelse {
                        std.debug.panic("MethodRef not found in this class: {s}.{s} {s}. Looked in {s}", .{ mr.class_name, mr.name, mr.descriptor, self.class_file.this_class });
                    } }; // TODO: Recover with exception
                }

                const other_class = self.class_loader.resolveClass(mr.class_name) catch unreachable; // TODO: Recover with exception

                // cycle through other_class constant pool and find this method ref
                break :blk .{ .method = other_class.resolveMethodInThisClassOrSuper(mr.name, mr.descriptor) orelse {
                    std.debug.panic("MethodRef not found in other class: {s}.{s} {s}. Looked in {s}", .{ mr.class_name, mr.name, mr.descriptor, other_class.class_file.this_class });
                } };
            },
            .Integer => |integer| {
                break :blk .{ .value = .{ .v = .{ .int = integer }, .ty = u.Ty.int } };
            },
            .String => |utf8| {
                const v = u.Value{ .reference = .{ .object = string.initFromUTF8(self.class_loader, utf8) catch unreachable } }; // TODO: Recover with exception
                break :blk .{ .value = .{ .v = v, .ty = u.Ty.reference } };
            },
            .ClassInfo => |class_info| {
                std.log.debug("Resolving class_info {s} for {s}", .{ class_info, self.class_file.this_class });
                if (std.mem.eql(u8, class_info, self.class_file.this_class)) {
                    std.log.debug("Resolving class_info for {s} is self", .{self.class_file.this_class});
                    break :blk .{ .class = self };
                }

                const other_class = self.class_loader.resolveClass(class_info) catch unreachable; // TODO: Recover with exception
                std.log.debug("Resolving class_info for {s} is other", .{class_info});
                break :blk .{ .class = other_class };
            },
            .Float => |float| {
                break :blk .{ .value = .{ .v = .{ .float = float }, .ty = u.Ty.float } };
            },
            else => std.debug.panic("Resolving this constant pool entry is not implemented yet: {}", .{cp_info}),
        }
    };
    return self.constant_pool_mapping[constant_pool_id].?;
}

pub fn resolveConstantPoolEntry(self: *Self, constant_pool_id: u32) ResolvedCPEntry {
    const entry = self.constant_pool_mapping[constant_pool_id] orelse self.resolveConstantPoolEntryImpl(constant_pool_id);
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

pub fn resolveMethodInThisClass(self: *Self, method_name: []const u8, method_descriptor: []const u8) ?ResolvedMethod {
    for (self.resolved_methods) |method| {
        const name_ok = std.mem.eql(u8, self.class_file.methods[method.method_id].name, method_name);
        const desc_ok = std.mem.eql(u8, self.class_file.methods[method.method_id].descriptor, method_descriptor);
        const class_ok = std.mem.eql(u8, method.class.class_file.this_class, self.class_file.this_class);
        if (name_ok and desc_ok and class_ok) {
            return method;
        }
    }
    return null;
}

pub fn resolveMethodInThisClassOrSuper(self: *Self, method_name: []const u8, method_descriptor: []const u8) ?ResolvedMethod {
    return self.resolveMethodInThisClass(method_name, method_descriptor) orelse {
        if (self.class_file.super_class) |super| {
            const super_class = self.class_loader.resolveClass(super) catch unreachable; // TODO: Recover with exception
            return super_class.resolveMethodInThisClassOrSuper(method_name, method_descriptor);
        } else return null;
    };
}

const AnyField = union { static: *u.TyValue, usual: u32 };

pub fn resolveFieldInThisClassOrSuper(self: *Self, field_info: RawClassFile.FieldRef) ?AnyField {
    for (self.flat_fields, 0..self.flat_fields.len) |field, idx| {
        if (std.mem.eql(u8, field.name, field_info.name)) {
            std.log.debug("Found suitable field {s} {s} in class {s}", .{ field.descriptor, field.name, self.class_file.this_class });
            return .{ .usual = @intCast(idx) };
        }
    }

    return resolveStaticFieldInThisClassOrSuper(self, field_info);
}

fn resolveStaticFieldInThisClass(self: *Self, field_info: RawClassFile.FieldRef) ?AnyField {
    var field_idx: u32 = 0;
    for (self.class_file.fields) |field| {
        if (!field.access_flags.static) continue;
        if (std.mem.eql(u8, field.name, field_info.name)) {
            return .{ .static = &self.static_fields[field_idx] };
        }
        field_idx += 1;
    }

    return null;
}

fn resolveStaticFieldInThisClassOrSuper(self: *Self, field_info: RawClassFile.FieldRef) ?AnyField {
    return self.resolveStaticFieldInThisClass(field_info) orelse {
        if (self.class_file.super_class) |super| {
            const super_class = self.class_loader.resolveClass(super) catch unreachable; // TODO: Recover with exception
            return super_class.resolveStaticFieldInThisClassOrSuper(field_info);
        } else return null;
    };
}
