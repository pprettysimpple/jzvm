const std = @import("std");
const cl = @import("class-loading/root.zig");
const exe = @import("execution/root.zig");

pub const log_level: std.log.Level = .debug;

pub fn main() !void {
    var vm_gpa = std.heap.GeneralPurposeAllocator(.{
        .verbose_log = false,
        .safety = true,
    }){};
    defer if (vm_gpa.deinit() == .leak) std.debug.panic("Leak detected", .{});
    const vm_alloc = vm_gpa.allocator();

    var heap_gpa = std.heap.GeneralPurposeAllocator(.{
        .verbose_log = false,
        .safety = true,
    }){};
    defer _ = heap_gpa.deinit();
    const heap_alloc = heap_gpa.allocator();

    const args = try std.process.argsAlloc(vm_alloc);
    defer std.process.argsFree(vm_alloc, args);
    if (args.len != 2) {
        return std.debug.print("Usage: {s} <class-name>", .{args[0]});
    }

    const err_writer = std.io.getStdErr().writer();

    const hardcoded_paths = [_][]const u8{ "/home/pprettysimpple/prjs/jzvm/data", "/home/pprettysimpple/prjs/jzvm/userdata", "/home/pprettysimpple/Downloads/server" };

    var class_loader = cl.ClassLoader.init(vm_alloc, &hardcoded_paths);
    var driver = exe.Driver.init(vm_alloc, heap_alloc, &class_loader);
    defer class_loader.deinit();
    defer driver.deinit();

    // driver.bootstrap() catch |err| {
    //     try err_writer.print("Error during bootstrap: {s}", .{err});
    // };

    const class_with_main = driver.resolveClass(args[1]) catch |err| switch (err) {
        error.ClassNotFound => {
            try err_writer.print("Class {s} was not found: {s}", .{ args[1], @errorName(err) });
            return;
        },
        else => return err,
    };

    const main_method_id = class_with_main.resolveMethodInThisClass("main", "([Ljava/lang/String;)V") orelse {
        try err_writer.print("Main method was not found for class {s}", .{args[1]});
        return;
    };

    try driver.interpreter.runMethod(&driver, .{ .class = class_with_main }, main_method_id);
}
