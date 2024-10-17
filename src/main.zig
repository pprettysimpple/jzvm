const std = @import("std");
const cl = @import("class-loading/root.zig");
const exe = @import("execution/root.zig");

pub const log_level: std.log.Level = .debug;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{
        .verbose_log = false,
        .safety = true,
    }){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len == 1) {
        return std.debug.print("Usage: {s} <class-name>", .{args[0]});
    }

    const hardcoded_paths = [_][]const u8{ "/home/pprettysimpple/prjs/jzvm/data", "/home/pprettysimpple/prjs/jzvm/userdata" };

    var class_loader = cl.ClassLoader.init(allocator, &hardcoded_paths);
    var engine = exe.Engine.init(allocator);
    var driver = exe.Driver.init(allocator, &class_loader, &engine);
    defer class_loader.deinit();
    defer engine.deinit();
    defer driver.deinit();

    const resolved_main = driver.resolveClassMethod(args[1], "main", "([Ljava/lang/String;)V") catch |err| {
        if (err == error.MethodNotFound) {
            try std.io.getStdOut().writer().print("Main method was not found for class {s}", .{args[1]});
            return;
        } else {
            return err;
        }
    };
    try engine.runMethod(&driver, resolved_main.class, resolved_main.method_id);
}
