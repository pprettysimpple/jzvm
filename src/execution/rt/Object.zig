/// Object's runtime representation
const Self = @This();
const std = @import("std");
const Class = @import("Class.zig");
const Heap = @import("Heap.zig");
const u = @import("../../common.zig");

class: *Class, // knows dynamic type
fields: []u.Value, // TODO: Somehow allocate it inplace on this struct Object

pub fn init(class: *Class) !Self {
    return Self{
        .class = class,
        .fields = try Heap.allocator.alloc(u64, class.class_file.fields.len),
    };
}

pub fn deinit(self: *Self) void {
    Heap.allocator.free(self.fields);
}

pub fn getFieldByName(self: *Self, name: []const u8) ?*u.Value {
    for (self.class.class_file.fields, 0..self.class.class_file.fields.len) |field, i| {
        if (std.mem.eql(u8, field.name, name)) {
            return &self.fields[i];
        }
    }

    return null;
}
