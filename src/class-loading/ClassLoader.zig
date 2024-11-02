/// Structure to load classes from a given path
/// Stores them internally in a raw format
const std = @import("std");
const RawClassFile = @import("RawClassFile.zig");
const Class = @import("../execution/rt/Class.zig");
const Self = @This();

// Hashmap to store the classes by name
allocator: std.mem.Allocator,
paths: []const []const u8,
classes: std.DoublyLinkedList(Class),
classes_by_name: std.StringHashMap(*Class), // class-name -> *Class

pub fn init(allocator: std.mem.Allocator, paths: []const []const u8) Self {
    return Self{
        .allocator = allocator,
        .paths = paths,
        .classes = std.DoublyLinkedList(Class){},
        .classes_by_name = std.StringHashMap(*Class).init(allocator),
    };
}

pub fn deinit(self: *Self) void {
    _ = self;
}

fn loadFromReader(self: *Self, reader: std.io.AnyReader) error{ OutOfMemory, BadClassFile }!RawClassFile {
    return try RawClassFile.read(reader, self.allocator);
}

fn loadFromDir(self: *Self, path_to_dir: []const u8, class_name: []const u8) error{ OutOfMemory, ClassFileNotFound }!RawClassFile {
    var dir = std.fs.cwd().openDir(path_to_dir, .{ .access_sub_paths = true, .iterate = true }) catch |err| switch (err) {
        error.FileNotFound => return error.ClassFileNotFound,
        else => unreachable,
    };
    defer dir.close();
    // create a file name from the class name
    var buffer: [512]u8 = undefined;
    _ = std.fmt.bufPrint(buffer[0..], "{s}", .{class_name}) catch unreachable;
    _ = std.fmt.bufPrint(buffer[class_name.len..], ".class", .{}) catch unreachable;
    const class_file_name = buffer[0 .. class_name.len + @as([]const u8, ".class").len];
    var file = dir.openFile(class_file_name, .{ .mode = .read_only }) catch |err| switch (err) {
        error.FileNotFound => return error.ClassFileNotFound,
        else => unreachable,
    };
    return self.loadFromReader(file.reader().any()) catch |err| switch (err) {
        error.BadClassFile => unreachable,
        error.OutOfMemory => return error.OutOfMemory,
    };
}

fn loadFromDirs(self: *Self, class_name: []const u8) error{ OutOfMemory, ClassFileNotFound }!RawClassFile {
    for (self.paths) |path| {
        // std.log.debug("Loading class {s} from path {s}:", .{ class_name, path });
        return self.loadFromDir(path, class_name) catch |err| switch (err) {
            error.ClassFileNotFound => continue,
            else => return err,
        };
    }
    return error.ClassFileNotFound;
}

fn loadUncached(self: *Self, class_name: []const u8) error{ OutOfMemory, ClassFileNotFound }!*Class {
    const new_class_file = try self.loadFromDirs(class_name);
    const node = try self.allocator.create(std.DoublyLinkedList(Class).Node);
    errdefer self.allocator.destroy(node);
    // ownership of the raw_class_file is transferred to the class
    Class.init(&node.data, self.allocator, self, new_class_file) catch |err| switch (err) {
        error.InvalidMethodDescriptor => std.debug.panic("Invalid method descriptor in class {s}", .{class_name}),
        error.InvalidFieldDescriptor => std.debug.panic("Invalid field descriptor in class {s}", .{class_name}),
        error.OutOfMemory => return error.OutOfMemory,
    };
    errdefer node.data.deinit();
    self.classes.append(node);
    errdefer _ = self.classes.pop();

    try self.classes_by_name.put(class_name, &node.data);
    std.log.info("Loaded new class \"{s}\"", .{class_name});

    return &node.data;
}

pub fn resolveClass(self: *Self, class_name: []const u8) error{ OutOfMemory, ClassFileNotFound }!*Class {
    return self.classes_by_name.get(class_name) orelse try self.loadUncached(class_name);
}
