/// File with common definitions, used by jvm specification
const Self = @This();
const Heap = @import("execution/rt/Heap.zig");
const Object = @import("execution/rt/Object.zig");
const Array = @import("execution/rt/Array.zig");

// types for jvm
// enum for possible types
pub const Ty = enum {
    pub const Byte = u8;
    pub const Short = i16;
    pub const Int = i32;
    pub const Long = i64;
    pub const Char = u16;
    pub const Float = f32;
    pub const Double = f64;
    pub const Boolean = bool;

    byte,
    short,
    int,
    long,
    char,
    float,
    double,
    boolean,
    reference,
    returnAddress,

    pub fn defaultValue(self: Ty) Value {
        return switch (self) {
            .byte => .{ .byte = 0 },
            .short => .{ .short = 0 },
            .int => .{ .int = 0 },
            .long => .{ .long = 0 },
            .char => .{ .char = 0 },
            .float => .{ .float = 0 },
            .double => .{ .double = 0 },
            .boolean => .{ .boolean = false },
            .reference => .{ .reference = .{ .class = Heap.Ref(Object).initNull() } },
            .returnAddress => .{ .returnAddress = 0 },
        };
    }

    pub fn fromDescriptor(descriptor: u8) Ty {
        return switch (descriptor) {
            'B' => .byte,
            'S' => .short,
            'I' => .int,
            'J' => .long,
            'C' => .char,
            'F' => .float,
            'D' => .double,
            'Z' => .boolean,
            '[' => .reference,
            'L' => .reference,
            else => unreachable,
        };
    }
};

pub const RefTy = enum {
    class,
    array,
    // TODO: primitive maybe?
};

// most of the time, we want to know what type of reference it is
pub const AnyRef = union(RefTy) {
    class: Heap.Ref(Object),
    array: Heap.Ref(Array),

    pub fn clone(self: AnyRef) AnyRef {
        return switch (self) {
            .class => .{ .class = self.class.clone() },
            .array => .{ .array = self.array.clone() },
        };
    }

    pub fn deinit(self: AnyRef) void {
        switch (self) {
            .class => self.class.deinit(),
            .array => self.array.deinit(),
        }
    }
};

// not-tagged union
pub const Value = union {
    byte: u8,
    short: i16,
    int: i32,
    long: i64,
    char: u16,
    float: f32,
    double: f64,
    boolean: bool,
    reference: AnyRef,
    returnAddress: usize,

    // types conversion is always "widening with sign extension" or truncate
    // - if need to truncate, bitcast to unsigned type and @truncate
    // - if need to widen, use zig's bigger signed type (for sign extension) and bitcast to unsigned type

    pub fn cast(self: Value, comptime Src: Ty, comptime Dst: Ty) Value {
        return switch (Src) {
            .byte => switch (Dst) {
                .byte => .{ .byte = self.byte },
                .short => .{ .short = self.byte },
                .int => .{ .int = self.byte },
                .long => .{ .long = self.byte },
                .char => .{ .char = @bitCast(@as(i16, self.byte)) },
                .float => .{ .float = @floatFromInt(self.byte) },
                .double => .{ .double = @floatFromInt(self.byte) },
                else => @compileError("UnsupportedConversion"),
            },
            .short => switch (Dst) {
                .byte => .{ .byte = @truncate(@as(u16, @bitCast(self.short))) },
                .short => .{ .short = self.short },
                .int => .{ .int = self.short },
                .long => .{ .long = self.short },
                .char => .{ .char = @bitCast(self.short) },
                .float => .{ .float = @floatFromInt(self.short) },
                .double => .{ .double = @floatFromInt(self.short) },
                else => @compileError("UnsupportedConversion"),
            },
            .int => switch (Dst) {
                .byte => .{ .byte = @truncate(@as(u32, @bitCast(self.int))) },
                .short => .{ .short = @truncate(@as(u32, @bitCast(self.int))) },
                .int => .{ .int = self.int },
                .long => .{ .long = self.int },
                .char => .{ .char = @bitCast(@as(i16, @truncate(self.int))) },
                .float => .{ .float = @floatFromInt(self.int) },
                .double => .{ .double = @floatFromInt(self.int) },
                else => @compileError("UnsupportedConversion"),
            },
            .long => switch (Dst) {
                .byte => .{ .byte = @truncate(self.long) },
                .short => .{ .short = @truncate(self.long) },
                .int => .{ .int = @truncate(self.long) },
                .long => .{ .long = self.long },
                .char => .{ .char = @bitCast(@as(i16, @truncate(self.long))) },
                .float => .{ .float = @floatFromInt(self.long) },
                .double => .{ .double = @floatFromInt(self.long) },
                else => @compileError("UnsupportedConversion"),
            },
            .char => switch (Dst) {
                .byte => .{ .byte = @truncate(@as(i16, @bitCast(self.char))) },
                .short => .{ .short = @bitCast(self.char) },
                .int => .{ .int = self.char },
                .long => .{ .long = self.char },
                .char => .{ .char = self.char },
                .float => .{ .float = @floatFromInt(self.char) },
                else => @compileError("UnsupportedConversion"),
            },
            .float => switch (Dst) {
                .byte => .{ .byte = @intFromFloat(self.float) },
                .short => .{ .short = @intFromFloat(self.float) },
                .int => .{ .int = @intFromFloat(self.float) },
                .long => .{ .long = @intFromFloat(self.float) },
                .char => .{ .char = @intFromFloat(self.float) },
                .float => .{ .float = self.float },
                .double => .{ .double = self.float },
                else => @compileError("UnsupportedConversion"),
            },
            .double => switch (Dst) {
                .byte => .{ .byte = @intFromFloat(self.double) },
                .short => .{ .short = @intFromFloat(self.double) },
                .int => .{ .int = @intFromFloat(self.double) },
                .long => .{ .long = @intFromFloat(self.double) },
                .char => .{ .char = @intFromFloat(self.double) },
                .float => .{ .float = @floatCast(self.double) },
                .double => .{ .double = self.double },
                else => @compileError("UnsupportedConversion"),
            },
            .boolean => switch (Dst) {
                .byte => .{ .byte = if (self.boolean) 1 else 0 },
                .short => .{ .short = if (self.boolean) 1 else 0 },
                .int => .{ .int = if (self.boolean) 1 else 0 },
                .long => .{ .long = if (self.boolean) 1 else 0 },
                .char => .{ .char = if (self.boolean) 1 else 0 },
                .float => .{ .float = if (self.boolean) 1 else 0 },
                .double => .{ .double = if (self.boolean) 1 else 0 },
                else => @compileError("UnsupportedConversion"),
            },
            .reference => switch (Dst) {
                .reference => .{ .reference = self.reference },
                else => @compileError("UnsupportedConversion"),
            },
            .returnAddress => switch (Dst) {
                .returnAddress => .{ .returnAddress = self.returnAddress },
                else => @compileError("UnsupportedConversion"),
            },
        };
    }
};

pub const TyValue = struct {
    v: Value,
    ty: Ty,
};

pub const FieldAccessFlags = packed struct {
    public: bool,
    private: bool,
    protected: bool,
    static: bool,
    final: bool,
    _1: bool,
    @"volatile": bool,
    transient: bool,
    _2: bool,
    _3: bool,
    _4: bool,
    _5: bool,
    synthetic: bool,
    rsv3: bool,
    @"enum": bool,
    _6: bool,
};

pub const ClassAccessFlags = packed struct {
    public: bool,
    _1: bool,
    _2: bool,
    _3: bool,
    final: bool,
    super: bool,
    _4: bool,
    _5: bool,
    _6: bool,
    interface: bool,
    _7: bool,
    abstract: bool,
    synthetic: bool,
    annotation: bool,
    @"enum": bool,
    _8: bool,
};

pub const MethodAccessFlags = packed struct {
    public: bool,
    private: bool,
    protected: bool,
    static: bool,
    final: bool,
    synchronized: bool,
    bridge: bool,
    varargs: bool,
    native: bool,
    _1: bool,
    abstract: bool,
    strict: bool,
    synthetic: bool,
    _2: bool,
    _3: bool,
    _4: bool,
};

pub const MethodId = u32;

pub const endian = @import("std").builtin.Endian.big;
