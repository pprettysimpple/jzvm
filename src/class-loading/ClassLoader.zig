/// Structure to load classes from a given path
/// Stores them internally in a raw format
const std = @import("std");
const RawClassFile = @import("RawClassFile.zig");
const Self = @This();

// Hashmap to store the classes by name
allocator: std.mem.Allocator,
paths: []const []const u8,

pub fn init(allocator: std.mem.Allocator, paths: []const []const u8) Self {
    return Self{
        .allocator = allocator,
        .paths = paths,
    };
}

pub fn deinit(self: *Self) void {
    _ = self;
}

fn loadFromReader(self: *Self, reader: std.io.AnyReader) !RawClassFile {
    return try RawClassFile.read(reader, self.allocator);
}

fn loadFromDir(self: *Self, path_to_dir: []const u8, class_name: []const u8) !RawClassFile {
    var dir = try std.fs.cwd().openDir(path_to_dir, .{ .access_sub_paths = true, .iterate = true });
    defer dir.close();
    // create a file name from the class name
    var buffer: [512]u8 = undefined;
    _ = try std.fmt.bufPrint(buffer[0..], "{s}", .{class_name});
    _ = try std.fmt.bufPrint(buffer[class_name.len..], ".class", .{});
    const class_file_name = buffer[0 .. class_name.len + @as([]const u8, ".class").len];
    var file = try dir.openFile(class_file_name, .{ .mode = .read_only });
    return try self.loadFromReader(file.reader().any());
}

fn loadFromDirs(self: *Self, class_name: []const u8) !RawClassFile {
    for (self.paths) |path| {
        std.log.debug("Loading class {s} from path {s}:", .{ class_name, path });
        return self.loadFromDir(path, class_name) catch |err| {
            if (err == std.fs.File.OpenError.FileNotFound) {
                std.log.debug("\tNot found {s} at {s}", .{ class_name, path });
                continue;
            }
            return err;
        };
    }
    return error.ClassFileNotFound;
}

pub fn load(self: *Self, class_name: []const u8) !RawClassFile {
    return try self.loadFromDirs(class_name);
}
