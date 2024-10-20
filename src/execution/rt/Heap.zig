/// Java Heap
const Self = @This();
const std = @import("std");

// It's pretty easy to do it that way, with thread-local storage,
// because, we do not need to store nearby an allocator ptr that allocated that block
pub threadlocal var allocator: std.mem.Allocator = std.heap.page_allocator;

pub fn Ref(comptime T: type) type {
    return packed struct {
        const Rf = @This();
        blk: *Block,

        const Block = struct {
            counter: u32,
            value: T,
        };

        pub fn init(value: T) !Rf {
            const blk: *Block = @ptrCast(try allocator.alloc(Block, 1));
            blk.* = Block{ .counter = 1, .value = value };
            return Rf{ .blk = blk };
        }

        pub fn deinit(self: Rf) void {
            if (self.blk.counter == 1) {
                std.log.info("Deallocating type {s}", .{@typeName(T)});
                allocator.free(self.blk);
            } else {
                std.log.info("Dec recount for type {s}, now {d}", .{ @typeName(T), self.blk.counter });
                self.blk.counter -= 1;
            }
        }

        pub fn clone(self: Rf) !Rf {
            self.blk.counter += 1;
            return self;
        }

        pub fn ptr(self: Rf) *T {
            return &self.blk.value;
        }
    };
}
