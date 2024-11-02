/// Resolves a native method calls, manages all loaded dynamic libraries
const Self = @This();
const std = @import("std");
const jni = @import("jni.zig");

pub fn init() Self {
    return Self{};
}

pub fn deinit(self: *Self) void {
    _ = self;
}

pub fn findMethod(class_name: []const u8, method_name: []const u8, method_descriptor: []const u8) void {
    // naming convention
    // package p.q.r;
    // class A {
    //     native double f(int i, String s);
    // }
    // Result is: "Java_p_q_r_A_f"
    var buf: [512]u8 = undefined;
    var n: usize = 0;
    n += (std.fmt.bufPrint(buf[n..], "Java_", .{}) catch unreachable).len;
    n += (std.fmt.bufPrint(buf[n..], "{s}", .{class_name}) catch unreachable).len;
    n += (std.fmt.bufPrint(buf[n..], "_{s}", .{method_name}) catch unreachable).len;

    _ = method_descriptor;
    // n += (std.fmt.bufPrint(buf[n..], "{s}", .{method_descriptor}) catch unreachable).len; // TODO: descriptor

    // replace all / with _
    for (&buf) |*c| {
        if (c.* == '/' or c.* == '.') {
            c.* = '_';
        }
    }
    buf[n] = 0;
    const sym_name = @as([*:0]const u8, @ptrCast(buf[0..n]));

    std.log.info("Going to call: {s}", .{sym_name});
    _ = std.DynLib.open("libjava.so") catch unreachable;
    // lib.lookup(fn (), name: [:0]const u8)
    // const f: *const fn () void = @ptrCast(sym);
    // f();
}
