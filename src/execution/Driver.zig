/// Driver manages the execution of the JVM.
/// It is responsible for resoling dependencies and executing the main method.
const std = @import("std");
const cl = @import("../class-loading/root.zig");
const Engine = @import("Engine.zig");
const Class = @import("rt/Class.zig");
const Self = @This();

allocator: std.mem.Allocator,
class_loader: *cl.ClassLoader,
classes: std.StringHashMap(Class), // class-name -> RawClassFile
engine: *Engine,

pub fn init(allocator: std.mem.Allocator, class_loader: *cl.ClassLoader, engine: *Engine) Self {
    return Self{
        .allocator = allocator,
        .class_loader = class_loader,
        .classes = std.StringHashMap(Class).init(allocator),
        .engine = engine,
    };
}

pub fn deinit(self: *Self) void {
    var it = self.classes.valueIterator();
    while (it.next()) |raw_class_file| {
        raw_class_file.deinit();
    }
    self.classes.deinit();
}

fn findMethodInClass(class: *Class, method_name: []const u8, method_descriptor: []const u8) ?u32 {
    for (class.class_file.methods, 0..class.class_file.methods.len) |method, idx| {
        if (std.mem.eql(u8, method.name, method_name) and std.mem.eql(u8, method.descriptor, method_descriptor)) {
            std.log.info(
                "Found method {s} in class {s}, returning index {d}",
                .{ method_name, class.class_file.this_class, idx },
            );
            return @intCast(idx);
        }
    }

    return null;
}

fn loadUncachedClass(self: *Self, class_name: []const u8) !*Class {
    // ownership of the raw_class_file is transferred to the class
    try self.classes.put(class_name, try Class.init(
        self.allocator,
        self,
        try self.class_loader.load(class_name),
    ));
    std.log.info("Loaded new class \"{s}\"", .{class_name});

    return self.classes.getPtr(class_name).?;
}

pub fn resolveClassMethod(
    self: *Self,
    class_name: []const u8,
    method_name: []const u8,
    method_descriptor: []const u8,
) !struct { class: *Class, method_id: u32 } {
    const class = try self.resolveClass(class_name);

    const method_id = findMethodInClass(class, method_name, method_descriptor) orelse {
        return error.MethodNotFound;
    };

    return .{ .class = class, .method_id = method_id };
}

pub fn resolveClass(self: *Self, class_name: []const u8) !*Class {
    return self.classes.getPtr(class_name) orelse blk: {
        const new_class_file = try self.loadUncachedClass(class_name);
        break :blk new_class_file;
    };
}
