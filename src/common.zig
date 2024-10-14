/// File with common definitions, used by jvm specification
pub const EJavaType = enum {
    byte,
    short,
    int,
    long,
    char,
    float,
    double,
    boolean,
    returnAddress, // TODO: might not be needed
};

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
    rsvd1: bool,
    jvolatile: bool,
    transient: bool,
    rsvd2: [4]bool,
    synthetic: bool,
    rsvd3: bool,
    jenum: bool,
};

pub const endian = @import("std").builtin.Endian.big;
