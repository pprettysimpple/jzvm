const std = @import("std");
const ClassLoader = @import("../class-loading/ClassLoader.zig");
const Object = @import("rt/Object.zig");
const Heap = @import("rt/Heap.zig");
const Array = @import("rt/Array.zig");
const u = @import("../common.zig");

pub fn initFromUTF8(class_loader: *ClassLoader, bytes: []const u8) error{ OutOfMemory, InvalidUtf8 }!Heap.Ref(Object) {
    // convert utf8 to utf16
    const utf16 = try std.unicode.utf8ToUtf16LeAlloc(Heap.allocator, bytes);
    defer Heap.allocator.free(utf16);

    // make java-array and copy utf16 bytes to it
    const array = try Array.init(Heap.allocator, u.Ty.char, @intCast(bytes.len)); // TODO: Encode utf8 to utf16
    for (utf16, array.items) |from, *to| {
        to.* = u.Value{ .char = from };
    }

    // make java/lang/String object and set its value field to the that array
    const jlStringObj = try Object.init(class_loader.resolveClass("java/lang/String") catch unreachable, Heap.allocator);
    const ref = try Heap.Ref(Object).init(jlStringObj);
    const array_ref = try Heap.Ref(Array).init(array);
    // TODO: Typecheck
    ref.ptr().?.getFieldByName("value").?.*.v = u.Value{ .reference = u.AnyRef{ .array = array_ref } };

    return ref;
}
