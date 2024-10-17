/// File with common definitions, used by jvm specification
pub const JavaType = struct {
    pub const Byte = u8;
    pub const Short = i16;
    pub const Int = i32;
    pub const Long = i64;
    pub const Char = u16;
    pub const Float = f32;
    pub const Double = f64;
    pub const Boolean = bool;
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
