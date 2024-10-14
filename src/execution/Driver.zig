/// Driver manages the execution of the JVM.
/// It is responsible for resoling dependencies and executing the main method.
const std = @import("std");
const cl = @import("../class-loading/root.zig");
const Engine = @import("Engine.zig");
const Self = @This();

allocator: std.mem.Allocator,
class_loader: *cl.ClassLoader,
classes: std.StringHashMap(cl.RawClassFile), // class-name -> RawClassFile
engine: *Engine,

pub fn init(allocator: std.mem.Allocator, class_loader: *cl.ClassLoader, engine: *Engine) Self {
    return Self{
        .allocator = allocator,
        .class_loader = class_loader,
        .classes = std.StringHashMap(cl.RawClassFile).init(allocator),
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

fn findMethodInClass(class: *cl.RawClassFile, method_name: []const u8, method_descriptor: []const u8) ?cl.RawClassFile.MethodInfo {
    for (class.methods) |method| {
        if (std.mem.eql(u8, method.name, method_name) and std.mem.eql(u8, method.descriptor, method_descriptor)) {
            return method;
        }
    }

    return null;
}

fn loadUncachedClass(self: *Self, class_name: []const u8) !*cl.RawClassFile {
    const new_class_file = try self.class_loader.load(class_name);
    try self.classes.put(class_name, new_class_file);
    std.log.info("Loaded new class \"{s}\" with parent \"{s}\"", .{ class_name, new_class_file.super_class });

    if (new_class_file.super_class.len != 0 and self.classes.getPtr(new_class_file.super_class) == null) {
        _ = try self.loadUncachedClass(new_class_file.super_class); // ignore for now, but we will need it later
    }

    return self.classes.getPtr(class_name).?;
}

pub fn resolve(self: *Self, class_name: []const u8, method_name: []const u8, method_descriptor: []const u8) !struct { cf: *cl.RawClassFile, method: cl.RawClassFile.MethodInfo } {
    const raw_class_file = self.classes.getPtr(class_name) orelse blk: {
        const new_class_file = try self.loadUncachedClass(class_name);
        try self.engine.runMethod(self, try self.resolve(new_class_file.this_class, "<clinit>", "()V"));
        try self.engine.runMethod(self, try self.resolve(new_class_file.this_class, "<init>", "()V"));
        break :blk new_class_file;
    };

    const method = findMethodInClass(raw_class_file, method_name, method_descriptor) orelse {
        return error.MethodNotFound;
    };

    return .{ .cf = raw_class_file, .method = method };
}
