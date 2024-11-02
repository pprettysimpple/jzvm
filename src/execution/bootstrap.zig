const std = @import("std");
const ClassLoader = @import("../class-loading/root.zig").ClassLoader;
const Interpreter = @import("Interpreter.zig");
const Heap = @import("rt/Heap.zig");
const Object = @import("rt/Object.zig");

pub fn bootstrap(class_loader: *ClassLoader) !void {
    const system_class = try class_loader.resolveClass("java/lang/System");
    const resolved_method = system_class.resolveMethodInThisClass("initializeSystemClass", "()V") orelse {
        std.debug.panic("Error during bootstrap: initializeSystemClass method not found in java/lang/System", .{});
    };

    try Interpreter.current.runMethod(
        Heap.Ref(Object).initNull(),
        resolved_method,
    );
}
