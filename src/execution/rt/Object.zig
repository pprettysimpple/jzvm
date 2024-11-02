/// Object's runtime representation
const Self = @This();
const std = @import("std");
const Class = @import("Class.zig");
const Heap = @import("Heap.zig");
const string = @import("../string.zig");
const u = @import("../../common.zig");

allocator: std.mem.Allocator,
class: *Class, // knows dynamic type
fields: []u.TyValue, // TODO: Somehow allocate it inplace on this struct Object

pub fn init(class: *Class, allocator: std.mem.Allocator) !Self {
    std.log.info("Init object of class {s}", .{class.class_file.this_class});
    const fields = try allocator.alloc(u.TyValue, class.flat_fields.len);
    for (class.flat_fields, fields) |cls_field, *real_field| {
        real_field.ty = cls_field.ty;
        real_field.v = cls_field.ty.defaultValue();
    }

    return Self{
        .allocator = allocator,
        .class = class,
        .fields = fields,
    };
}

pub fn deinit(self: *Self) void {
    std.log.info("Deinit object of class {s}", .{self.class.class_file.this_class});
    for (self.fields) |field| {
        if (field.ty == u.Ty.reference) {
            field.v.reference.deinit();
        }
    }
    self.allocator.free(self.fields);
}

pub fn getFieldByName(self: *Self, name: []const u8) ?*u.TyValue {
    for (self.class.flat_fields, 0..self.class.flat_fields.len) |field, i| {
        std.log.debug("Checking field {s}", .{field.name});
        if (std.mem.eql(u8, field.name, name)) {
            return &self.fields[i];
        }
    }

    return null;
}

pub fn newJavaLangClassObject(class: *Class, allocator: std.mem.Allocator) error{ OutOfMemory, ClassFileNotFound, InvalidUtf8 }!Heap.Ref(Self) {
    const java_lang_class = try class.class_loader.resolveClass("java/lang/Class");
    const java_lang_class_object = try Self.init(java_lang_class, allocator);
    const ref = try Heap.Ref(Self).init(java_lang_class_object);
    ref.ptr().?.getFieldByName("name").?.v.reference = .{ .object = try string.initFromUTF8(class.class_loader, class.class_file.this_class) };
    return ref;
}
