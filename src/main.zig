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

    var cwd_path_buf: [512]u8 = undefined;
    var cwd_data_path_buf: [512]u8 = undefined;
    var cwd_userdata_path_buf: [512]u8 = undefined;
    var cwd_userdata_jre_unpacked_path_buf: [512]u8 = undefined;
    const hardcoded_paths = [_][]const u8{
        try std.fs.cwd().realpath("data", &cwd_data_path_buf),
        try std.fs.cwd().realpath("userdata", &cwd_userdata_path_buf),
        try std.fs.cwd().realpath("userdata/jre1.8.0_431", &cwd_userdata_jre_unpacked_path_buf),
        try std.fs.cwd().realpath(".", &cwd_path_buf),
        "/home/pprettysimpple/Downloads/server",
    };

    var booststrap_class_loader = cl.ClassLoader.init(vm_alloc, &hardcoded_paths);
    defer booststrap_class_loader.deinit();
    var interpreter = exe.Interpreter.init(vm_alloc, heap_alloc, &booststrap_class_loader);
    interpreter.attachToThread(); // must be called after we have stable pointer on the interpreter

    try exe.bootstrap(&booststrap_class_loader);

    const class_with_main = booststrap_class_loader.resolveClass(args[1]) catch |err| switch (err) {
        error.ClassFileNotFound => {
            try err_writer.print("Class {s} was not found", .{args[1]});
            return;
        },
        else => return err,
    };

    const resolved_main = class_with_main.resolveMethodInThisClass("main", "([Ljava/lang/String;)V") orelse {
        try err_writer.print("Main method was not found for class {s}", .{args[1]});
        return;
    };

    try interpreter.runMethod(exe.rt.Heap.Ref(exe.rt.Object).initNull(), resolved_main);
}
