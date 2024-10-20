/// Object's runtime representation
const Self = @This();
const std = @import("std");
const Class = @import("Class.zig");
const Heap = @import("Heap.zig");
const u = @import("../../common.zig");

allocator: std.mem.Allocator,
ty: u.Ty,
items: []u.Value, // TODO: Allocate nearby

pub fn init(allocator: std.mem.Allocator, ty: u.Ty, size: u32) !Self {
    const items = try allocator.alloc(u.Value, size);
    @memset(items, ty.defaultValue());

    return Self{
        .allocator = allocator,
        .ty = ty,
        .items = items,
    };
}

pub fn deinit(self: *Self) void {
    self.allocator.free(self.items);
}
