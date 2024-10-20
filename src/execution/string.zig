const std = @import("std");
const Driver = @import("Driver.zig");
const Object = @import("rt/Object.zig");
const Heap = @import("rt/Heap.zig");

pub fn initFromConstantPool(driver: Driver, bytes: []const u8) Heap.Ref(Object) {
    const jlStringObj = Object.init(driver.resolveClass("java/lang/String")) catch unreachable;
    const ref = try Heap.Ref(Object).init(jlStringObj);
    _ = ref;
    _ = bytes;
    // ref.ptr().getFieldByName("value").?
}
