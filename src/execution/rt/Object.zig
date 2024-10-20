/// Object's runtime representation
const Self = @This();
const std = @import("std");
const Class = @import("Class.zig");
const Heap = @import("Heap.zig");
const u = @import("../../common.zig");

allocator: std.mem.Allocator,
class: *Class, // knows dynamic type
fields: []u.TyValue, // TODO: Somehow allocate it inplace on this struct Object

pub fn init(class: *Class, allocator: std.mem.Allocator) !Self {
    const fields = try allocator.alloc(u.TyValue, class.class_file.fields.len);
    for (class.class_file.fields, fields) |cf_field, *real_field| {
        const ty = u.Ty.fromDescriptor(cf_field.descriptor[0]);
        real_field.ty = ty;
        real_field.v = ty.defaultValue();
    }

    return Self{
        .allocator = allocator,
        .class = class,
        .fields = fields,
    };
}

pub fn deinit(self: *Self) void {
    std.log.info("Deallocating object of class {s}", .{self.class.class_file.this_class});
    for (self.fields) |field| {
        if (field.ty == u.Ty.reference) {
            field.v.reference.deinit();
        }
    }
    self.allocator.free(self.fields);
}

pub fn getFieldByName(self: *Self, name: []const u8) ?*u.TyValue {
    for (self.class.class_file.fields, 0..self.class.class_file.fields.len) |field, i| {
        if (std.mem.eql(u8, field.name, name)) {
            return &self.fields[i];
        }
    }

    return null;
}
