pub const __builtin_bswap16 = @import("std").zig.c_builtins.__builtin_bswap16;
pub const __builtin_bswap32 = @import("std").zig.c_builtins.__builtin_bswap32;
pub const __builtin_bswap64 = @import("std").zig.c_builtins.__builtin_bswap64;
pub const __builtin_signbit = @import("std").zig.c_builtins.__builtin_signbit;
pub const __builtin_signbitf = @import("std").zig.c_builtins.__builtin_signbitf;
pub const __builtin_popcount = @import("std").zig.c_builtins.__builtin_popcount;
pub const __builtin_ctz = @import("std").zig.c_builtins.__builtin_ctz;
pub const __builtin_clz = @import("std").zig.c_builtins.__builtin_clz;
pub const __builtin_sqrt = @import("std").zig.c_builtins.__builtin_sqrt;
pub const __builtin_sqrtf = @import("std").zig.c_builtins.__builtin_sqrtf;
pub const __builtin_sin = @import("std").zig.c_builtins.__builtin_sin;
pub const __builtin_sinf = @import("std").zig.c_builtins.__builtin_sinf;
pub const __builtin_cos = @import("std").zig.c_builtins.__builtin_cos;
pub const __builtin_cosf = @import("std").zig.c_builtins.__builtin_cosf;
pub const __builtin_exp = @import("std").zig.c_builtins.__builtin_exp;
pub const __builtin_expf = @import("std").zig.c_builtins.__builtin_expf;
pub const __builtin_exp2 = @import("std").zig.c_builtins.__builtin_exp2;
pub const __builtin_exp2f = @import("std").zig.c_builtins.__builtin_exp2f;
pub const __builtin_log = @import("std").zig.c_builtins.__builtin_log;
pub const __builtin_logf = @import("std").zig.c_builtins.__builtin_logf;
pub const __builtin_log2 = @import("std").zig.c_builtins.__builtin_log2;
pub const __builtin_log2f = @import("std").zig.c_builtins.__builtin_log2f;
pub const __builtin_log10 = @import("std").zig.c_builtins.__builtin_log10;
pub const __builtin_log10f = @import("std").zig.c_builtins.__builtin_log10f;
pub const __builtin_abs = @import("std").zig.c_builtins.__builtin_abs;
pub const __builtin_labs = @import("std").zig.c_builtins.__builtin_labs;
pub const __builtin_llabs = @import("std").zig.c_builtins.__builtin_llabs;
pub const __builtin_fabs = @import("std").zig.c_builtins.__builtin_fabs;
pub const __builtin_fabsf = @import("std").zig.c_builtins.__builtin_fabsf;
pub const __builtin_floor = @import("std").zig.c_builtins.__builtin_floor;
pub const __builtin_floorf = @import("std").zig.c_builtins.__builtin_floorf;
pub const __builtin_ceil = @import("std").zig.c_builtins.__builtin_ceil;
pub const __builtin_ceilf = @import("std").zig.c_builtins.__builtin_ceilf;
pub const __builtin_trunc = @import("std").zig.c_builtins.__builtin_trunc;
pub const __builtin_truncf = @import("std").zig.c_builtins.__builtin_truncf;
pub const __builtin_round = @import("std").zig.c_builtins.__builtin_round;
pub const __builtin_roundf = @import("std").zig.c_builtins.__builtin_roundf;
pub const __builtin_strlen = @import("std").zig.c_builtins.__builtin_strlen;
pub const __builtin_strcmp = @import("std").zig.c_builtins.__builtin_strcmp;
pub const __builtin_object_size = @import("std").zig.c_builtins.__builtin_object_size;
pub const __builtin___memset_chk = @import("std").zig.c_builtins.__builtin___memset_chk;
pub const __builtin_memset = @import("std").zig.c_builtins.__builtin_memset;
pub const __builtin___memcpy_chk = @import("std").zig.c_builtins.__builtin___memcpy_chk;
pub const __builtin_memcpy = @import("std").zig.c_builtins.__builtin_memcpy;
pub const __builtin_expect = @import("std").zig.c_builtins.__builtin_expect;
pub const __builtin_nanf = @import("std").zig.c_builtins.__builtin_nanf;
pub const __builtin_huge_valf = @import("std").zig.c_builtins.__builtin_huge_valf;
pub const __builtin_inff = @import("std").zig.c_builtins.__builtin_inff;
pub const __builtin_isnan = @import("std").zig.c_builtins.__builtin_isnan;
pub const __builtin_isinf = @import("std").zig.c_builtins.__builtin_isinf;
pub const __builtin_isinf_sign = @import("std").zig.c_builtins.__builtin_isinf_sign;
pub const __has_builtin = @import("std").zig.c_builtins.__has_builtin;
pub const __builtin_assume = @import("std").zig.c_builtins.__builtin_assume;
pub const __builtin_unreachable = @import("std").zig.c_builtins.__builtin_unreachable;
pub const __builtin_constant_p = @import("std").zig.c_builtins.__builtin_constant_p;
pub const __builtin_mul_overflow = @import("std").zig.c_builtins.__builtin_mul_overflow;
pub const struct___va_list_tag_1 = extern struct {
    gp_offset: c_uint = @import("std").mem.zeroes(c_uint),
    fp_offset: c_uint = @import("std").mem.zeroes(c_uint),
    overflow_arg_area: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reg_save_area: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const __builtin_va_list = [1]struct___va_list_tag_1;
pub const __gnuc_va_list = __builtin_va_list;
pub const __u_char = u8;
pub const __u_short = c_ushort;
pub const __u_int = c_uint;
pub const __u_long = c_ulong;
pub const __int8_t = i8;
pub const __uint8_t = u8;
pub const __int16_t = c_short;
pub const __uint16_t = c_ushort;
pub const __int32_t = c_int;
pub const __uint32_t = c_uint;
pub const __int64_t = c_long;
pub const __uint64_t = c_ulong;
pub const __int_least8_t = __int8_t;
pub const __uint_least8_t = __uint8_t;
pub const __int_least16_t = __int16_t;
pub const __uint_least16_t = __uint16_t;
pub const __int_least32_t = __int32_t;
pub const __uint_least32_t = __uint32_t;
pub const __int_least64_t = __int64_t;
pub const __uint_least64_t = __uint64_t;
pub const __quad_t = c_long;
pub const __u_quad_t = c_ulong;
pub const __intmax_t = c_long;
pub const __uintmax_t = c_ulong;
pub const __dev_t = c_ulong;
pub const __uid_t = c_uint;
pub const __gid_t = c_uint;
pub const __ino_t = c_ulong;
pub const __ino64_t = c_ulong;
pub const __mode_t = c_uint;
pub const __nlink_t = c_ulong;
pub const __off_t = c_long;
pub const __off64_t = c_long;
pub const __pid_t = c_int;
pub const __fsid_t = extern struct {
    __val: [2]c_int = @import("std").mem.zeroes([2]c_int),
};
pub const __clock_t = c_long;
pub const __rlim_t = c_ulong;
pub const __rlim64_t = c_ulong;
pub const __id_t = c_uint;
pub const __time_t = c_long;
pub const __useconds_t = c_uint;
pub const __suseconds_t = c_long;
pub const __suseconds64_t = c_long;
pub const __daddr_t = c_int;
pub const __key_t = c_int;
pub const __clockid_t = c_int;
pub const __timer_t = ?*anyopaque;
pub const __blksize_t = c_long;
pub const __blkcnt_t = c_long;
pub const __blkcnt64_t = c_long;
pub const __fsblkcnt_t = c_ulong;
pub const __fsblkcnt64_t = c_ulong;
pub const __fsfilcnt_t = c_ulong;
pub const __fsfilcnt64_t = c_ulong;
pub const __fsword_t = c_long;
pub const __ssize_t = c_long;
pub const __syscall_slong_t = c_long;
pub const __syscall_ulong_t = c_ulong;
pub const __loff_t = __off64_t;
pub const __caddr_t = [*c]u8;
pub const __intptr_t = c_long;
pub const __socklen_t = c_uint;
pub const __sig_atomic_t = c_int;
const union_unnamed_2 = extern union {
    __wch: c_uint,
    __wchb: [4]u8,
};
pub const __mbstate_t = extern struct {
    __count: c_int = @import("std").mem.zeroes(c_int),
    __value: union_unnamed_2 = @import("std").mem.zeroes(union_unnamed_2),
};
pub const struct__G_fpos_t = extern struct {
    __pos: __off_t = @import("std").mem.zeroes(__off_t),
    __state: __mbstate_t = @import("std").mem.zeroes(__mbstate_t),
};
pub const __fpos_t = struct__G_fpos_t;
pub const struct__G_fpos64_t = extern struct {
    __pos: __off64_t = @import("std").mem.zeroes(__off64_t),
    __state: __mbstate_t = @import("std").mem.zeroes(__mbstate_t),
};
pub const __fpos64_t = struct__G_fpos64_t;
pub const struct__IO_marker = opaque {};
pub const _IO_lock_t = anyopaque;
pub const struct__IO_codecvt = opaque {};
pub const struct__IO_wide_data = opaque {};
pub const struct__IO_FILE = extern struct {
    _flags: c_int = @import("std").mem.zeroes(c_int),
    _IO_read_ptr: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    _IO_read_end: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    _IO_read_base: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    _IO_write_base: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    _IO_write_ptr: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    _IO_write_end: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    _IO_buf_base: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    _IO_buf_end: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    _IO_save_base: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    _IO_backup_base: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    _IO_save_end: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    _markers: ?*struct__IO_marker = @import("std").mem.zeroes(?*struct__IO_marker),
    _chain: [*c]struct__IO_FILE = @import("std").mem.zeroes([*c]struct__IO_FILE),
    _fileno: c_int = @import("std").mem.zeroes(c_int),
    _flags2: c_int = @import("std").mem.zeroes(c_int),
    _old_offset: __off_t = @import("std").mem.zeroes(__off_t),
    _cur_column: c_ushort = @import("std").mem.zeroes(c_ushort),
    _vtable_offset: i8 = @import("std").mem.zeroes(i8),
    _shortbuf: [1]u8 = @import("std").mem.zeroes([1]u8),
    _lock: ?*_IO_lock_t = @import("std").mem.zeroes(?*_IO_lock_t),
    _offset: __off64_t = @import("std").mem.zeroes(__off64_t),
    _codecvt: ?*struct__IO_codecvt = @import("std").mem.zeroes(?*struct__IO_codecvt),
    _wide_data: ?*struct__IO_wide_data = @import("std").mem.zeroes(?*struct__IO_wide_data),
    _freeres_list: [*c]struct__IO_FILE = @import("std").mem.zeroes([*c]struct__IO_FILE),
    _freeres_buf: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    __pad5: usize = @import("std").mem.zeroes(usize),
    _mode: c_int = @import("std").mem.zeroes(c_int),
    _unused2: [20]u8 = @import("std").mem.zeroes([20]u8),
};
pub const __FILE = struct__IO_FILE;
pub const FILE = struct__IO_FILE;
pub const cookie_read_function_t = fn (?*anyopaque, [*c]u8, usize) callconv(.C) __ssize_t;
pub const cookie_write_function_t = fn (?*anyopaque, [*c]const u8, usize) callconv(.C) __ssize_t;
pub const cookie_seek_function_t = fn (?*anyopaque, [*c]__off64_t, c_int) callconv(.C) c_int;
pub const cookie_close_function_t = fn (?*anyopaque) callconv(.C) c_int;
pub const struct__IO_cookie_io_functions_t = extern struct {
    read: ?*const cookie_read_function_t = @import("std").mem.zeroes(?*const cookie_read_function_t),
    write: ?*const cookie_write_function_t = @import("std").mem.zeroes(?*const cookie_write_function_t),
    seek: ?*const cookie_seek_function_t = @import("std").mem.zeroes(?*const cookie_seek_function_t),
    close: ?*const cookie_close_function_t = @import("std").mem.zeroes(?*const cookie_close_function_t),
};
pub const cookie_io_functions_t = struct__IO_cookie_io_functions_t;
pub const va_list = __gnuc_va_list;
pub const off_t = __off_t;
pub const fpos_t = __fpos_t;
pub extern var stdin: [*c]FILE;
pub extern var stdout: [*c]FILE;
pub extern var stderr: [*c]FILE;
pub extern fn remove(__filename: [*c]const u8) c_int;
pub extern fn rename(__old: [*c]const u8, __new: [*c]const u8) c_int;
pub extern fn renameat(__oldfd: c_int, __old: [*c]const u8, __newfd: c_int, __new: [*c]const u8) c_int;
pub extern fn fclose(__stream: [*c]FILE) c_int;
pub extern fn tmpfile() [*c]FILE;
pub extern fn tmpnam([*c]u8) [*c]u8;
pub extern fn tmpnam_r(__s: [*c]u8) [*c]u8;
pub extern fn tempnam(__dir: [*c]const u8, __pfx: [*c]const u8) [*c]u8;
pub extern fn fflush(__stream: [*c]FILE) c_int;
pub extern fn fflush_unlocked(__stream: [*c]FILE) c_int;
pub extern fn fopen(__filename: [*c]const u8, __modes: [*c]const u8) [*c]FILE;
pub extern fn freopen(noalias __filename: [*c]const u8, noalias __modes: [*c]const u8, noalias __stream: [*c]FILE) [*c]FILE;
pub extern fn fdopen(__fd: c_int, __modes: [*c]const u8) [*c]FILE;
pub extern fn fopencookie(noalias __magic_cookie: ?*anyopaque, noalias __modes: [*c]const u8, __io_funcs: cookie_io_functions_t) [*c]FILE;
pub extern fn fmemopen(__s: ?*anyopaque, __len: usize, __modes: [*c]const u8) [*c]FILE;
pub extern fn open_memstream(__bufloc: [*c][*c]u8, __sizeloc: [*c]usize) [*c]FILE;
pub extern fn setbuf(noalias __stream: [*c]FILE, noalias __buf: [*c]u8) void;
pub extern fn setvbuf(noalias __stream: [*c]FILE, noalias __buf: [*c]u8, __modes: c_int, __n: usize) c_int;
pub extern fn setbuffer(noalias __stream: [*c]FILE, noalias __buf: [*c]u8, __size: usize) void;
pub extern fn setlinebuf(__stream: [*c]FILE) void;
pub extern fn fprintf(__stream: [*c]FILE, __format: [*c]const u8, ...) c_int;
pub extern fn printf(__format: [*c]const u8, ...) c_int;
pub extern fn sprintf(__s: [*c]u8, __format: [*c]const u8, ...) c_int;
pub extern fn vfprintf(__s: [*c]FILE, __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vprintf(__format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vsprintf(__s: [*c]u8, __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn snprintf(__s: [*c]u8, __maxlen: c_ulong, __format: [*c]const u8, ...) c_int;
pub extern fn vsnprintf(__s: [*c]u8, __maxlen: c_ulong, __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vasprintf(noalias __ptr: [*c][*c]u8, noalias __f: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn __asprintf(noalias __ptr: [*c][*c]u8, noalias __fmt: [*c]const u8, ...) c_int;
pub extern fn asprintf(noalias __ptr: [*c][*c]u8, noalias __fmt: [*c]const u8, ...) c_int;
pub extern fn vdprintf(__fd: c_int, noalias __fmt: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn dprintf(__fd: c_int, noalias __fmt: [*c]const u8, ...) c_int;
pub extern fn fscanf(noalias __stream: [*c]FILE, noalias __format: [*c]const u8, ...) c_int;
pub extern fn scanf(noalias __format: [*c]const u8, ...) c_int;
pub extern fn sscanf(noalias __s: [*c]const u8, noalias __format: [*c]const u8, ...) c_int;
pub const _Float32 = f32;
pub const _Float64 = f64;
pub const _Float32x = f64;
pub const _Float64x = c_longdouble;
pub extern fn vfscanf(noalias __s: [*c]FILE, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vscanf(noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vsscanf(noalias __s: [*c]const u8, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn fgetc(__stream: [*c]FILE) c_int;
pub extern fn getc(__stream: [*c]FILE) c_int;
pub extern fn getchar() c_int;
pub extern fn getc_unlocked(__stream: [*c]FILE) c_int;
pub extern fn getchar_unlocked() c_int;
pub extern fn fgetc_unlocked(__stream: [*c]FILE) c_int;
pub extern fn fputc(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn putc(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn putchar(__c: c_int) c_int;
pub extern fn fputc_unlocked(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn putc_unlocked(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn putchar_unlocked(__c: c_int) c_int;
pub extern fn getw(__stream: [*c]FILE) c_int;
pub extern fn putw(__w: c_int, __stream: [*c]FILE) c_int;
pub extern fn fgets(noalias __s: [*c]u8, __n: c_int, noalias __stream: [*c]FILE) [*c]u8;
pub extern fn __getdelim(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, __delimiter: c_int, noalias __stream: [*c]FILE) __ssize_t;
pub extern fn getdelim(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, __delimiter: c_int, noalias __stream: [*c]FILE) __ssize_t;
pub extern fn getline(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, noalias __stream: [*c]FILE) __ssize_t;
pub extern fn fputs(noalias __s: [*c]const u8, noalias __stream: [*c]FILE) c_int;
pub extern fn puts(__s: [*c]const u8) c_int;
pub extern fn ungetc(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn fread(__ptr: ?*anyopaque, __size: c_ulong, __n: c_ulong, __stream: [*c]FILE) c_ulong;
pub extern fn fwrite(__ptr: ?*const anyopaque, __size: c_ulong, __n: c_ulong, __s: [*c]FILE) c_ulong;
pub extern fn fread_unlocked(noalias __ptr: ?*anyopaque, __size: usize, __n: usize, noalias __stream: [*c]FILE) usize;
pub extern fn fwrite_unlocked(noalias __ptr: ?*const anyopaque, __size: usize, __n: usize, noalias __stream: [*c]FILE) usize;
pub extern fn fseek(__stream: [*c]FILE, __off: c_long, __whence: c_int) c_int;
pub extern fn ftell(__stream: [*c]FILE) c_long;
pub extern fn rewind(__stream: [*c]FILE) void;
pub extern fn fseeko(__stream: [*c]FILE, __off: __off_t, __whence: c_int) c_int;
pub extern fn ftello(__stream: [*c]FILE) __off_t;
pub extern fn fgetpos(noalias __stream: [*c]FILE, noalias __pos: [*c]fpos_t) c_int;
pub extern fn fsetpos(__stream: [*c]FILE, __pos: [*c]const fpos_t) c_int;
pub extern fn clearerr(__stream: [*c]FILE) void;
pub extern fn feof(__stream: [*c]FILE) c_int;
pub extern fn ferror(__stream: [*c]FILE) c_int;
pub extern fn clearerr_unlocked(__stream: [*c]FILE) void;
pub extern fn feof_unlocked(__stream: [*c]FILE) c_int;
pub extern fn ferror_unlocked(__stream: [*c]FILE) c_int;
pub extern fn perror(__s: [*c]const u8) void;
pub extern fn fileno(__stream: [*c]FILE) c_int;
pub extern fn fileno_unlocked(__stream: [*c]FILE) c_int;
pub extern fn pclose(__stream: [*c]FILE) c_int;
pub extern fn popen(__command: [*c]const u8, __modes: [*c]const u8) [*c]FILE;
pub extern fn ctermid(__s: [*c]u8) [*c]u8;
pub extern fn flockfile(__stream: [*c]FILE) void;
pub extern fn ftrylockfile(__stream: [*c]FILE) c_int;
pub extern fn funlockfile(__stream: [*c]FILE) void;
pub extern fn __uflow([*c]FILE) c_int;
pub extern fn __overflow([*c]FILE, c_int) c_int;
pub const jint = c_int;
pub const jlong = c_long;
pub const jbyte = i8;
pub const jboolean = u8;
pub const jchar = c_ushort;
pub const jshort = c_short;
pub const jfloat = f32;
pub const jdouble = f64;
pub const jsize = jint;
pub const struct__jobject = opaque {};
pub const jobject = ?*struct__jobject;
pub const jclass = jobject;
pub const jthrowable = jobject;
pub const jstring = jobject;
pub const jarray = jobject;
pub const jbooleanArray = jarray;
pub const jbyteArray = jarray;
pub const jcharArray = jarray;
pub const jshortArray = jarray;
pub const jintArray = jarray;
pub const jlongArray = jarray;
pub const jfloatArray = jarray;
pub const jdoubleArray = jarray;
pub const jobjectArray = jarray;
pub const jweak = jobject;
pub const union_jvalue = extern union {
    z: jboolean,
    b: jbyte,
    c: jchar,
    s: jshort,
    i: jint,
    j: jlong,
    f: jfloat,
    d: jdouble,
    l: jobject,
};
pub const jvalue = union_jvalue;
pub const struct__jfieldID = opaque {};
pub const jfieldID = ?*struct__jfieldID;
pub const struct__jmethodID = opaque {};
pub const jmethodID = ?*struct__jmethodID;
pub const JNIInvalidRefType: c_int = 0;
pub const JNILocalRefType: c_int = 1;
pub const JNIGlobalRefType: c_int = 2;
pub const JNIWeakGlobalRefType: c_int = 3;
pub const enum__jobjectType = c_uint;
pub const jobjectRefType = enum__jobjectType;
pub const JNINativeMethod = extern struct {
    name: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    signature: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    fnPtr: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const JNIEnv = [*c]const struct_JNINativeInterface_;
pub const struct_JNIInvokeInterface_ = extern struct {
    reserved0: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reserved1: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reserved2: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    DestroyJavaVM: ?*const fn ([*c]JavaVM) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JavaVM) callconv(.C) jint),
    AttachCurrentThread: ?*const fn ([*c]JavaVM, [*c]?*anyopaque, ?*anyopaque) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JavaVM, [*c]?*anyopaque, ?*anyopaque) callconv(.C) jint),
    DetachCurrentThread: ?*const fn ([*c]JavaVM) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JavaVM) callconv(.C) jint),
    GetEnv: ?*const fn ([*c]JavaVM, [*c]?*anyopaque, jint) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JavaVM, [*c]?*anyopaque, jint) callconv(.C) jint),
    AttachCurrentThreadAsDaemon: ?*const fn ([*c]JavaVM, [*c]?*anyopaque, ?*anyopaque) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JavaVM, [*c]?*anyopaque, ?*anyopaque) callconv(.C) jint),
};
pub const JavaVM = [*c]const struct_JNIInvokeInterface_;
pub const struct_JNINativeInterface_ = extern struct {
    reserved0: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reserved1: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reserved2: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reserved3: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    GetVersion: ?*const fn ([*c]JNIEnv) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) jint),
    DefineClass: ?*const fn ([*c]JNIEnv, [*c]const u8, jobject, [*c]const jbyte, jsize) callconv(.C) jclass = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8, jobject, [*c]const jbyte, jsize) callconv(.C) jclass),
    FindClass: ?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jclass = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jclass),
    FromReflectedMethod: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jmethodID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jmethodID),
    FromReflectedField: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jfieldID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jfieldID),
    ToReflectedMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, jboolean) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, jboolean) callconv(.C) jobject),
    GetSuperclass: ?*const fn ([*c]JNIEnv, jclass) callconv(.C) jclass = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass) callconv(.C) jclass),
    IsAssignableFrom: ?*const fn ([*c]JNIEnv, jclass, jclass) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jclass) callconv(.C) jboolean),
    ToReflectedField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) jobject),
    Throw: ?*const fn ([*c]JNIEnv, jthrowable) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jthrowable) callconv(.C) jint),
    ThrowNew: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8) callconv(.C) jint),
    ExceptionOccurred: ?*const fn ([*c]JNIEnv) callconv(.C) jthrowable = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) jthrowable),
    ExceptionDescribe: ?*const fn ([*c]JNIEnv) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) void),
    ExceptionClear: ?*const fn ([*c]JNIEnv) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) void),
    FatalError: ?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) void),
    PushLocalFrame: ?*const fn ([*c]JNIEnv, jint) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jint) callconv(.C) jint),
    PopLocalFrame: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject),
    NewGlobalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject),
    DeleteGlobalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) void),
    DeleteLocalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) void),
    IsSameObject: ?*const fn ([*c]JNIEnv, jobject, jobject) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jobject) callconv(.C) jboolean),
    NewLocalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject),
    EnsureLocalCapacity: ?*const fn ([*c]JNIEnv, jint) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jint) callconv(.C) jint),
    AllocObject: ?*const fn ([*c]JNIEnv, jclass) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass) callconv(.C) jobject),
    NewObject: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject),
    NewObjectV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jobject),
    NewObjectA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    GetObjectClass: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jclass = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jclass),
    IsInstanceOf: ?*const fn ([*c]JNIEnv, jobject, jclass) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass) callconv(.C) jboolean),
    GetMethodID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID),
    CallObjectMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jobject),
    CallObjectMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jobject),
    CallObjectMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    CallBooleanMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jboolean),
    CallBooleanMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jboolean),
    CallBooleanMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jboolean),
    CallByteMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jbyte),
    CallByteMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jbyte),
    CallByteMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jbyte),
    CallCharMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jchar),
    CallCharMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jchar),
    CallCharMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jchar),
    CallShortMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jshort),
    CallShortMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jshort),
    CallShortMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jshort),
    CallIntMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jint),
    CallIntMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jint),
    CallIntMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jint),
    CallLongMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jlong),
    CallLongMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jlong),
    CallLongMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jlong),
    CallFloatMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jfloat),
    CallFloatMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jfloat),
    CallFloatMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jfloat),
    CallDoubleMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jdouble),
    CallDoubleMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jdouble),
    CallDoubleMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jdouble),
    CallVoidMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) void),
    CallVoidMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) void),
    CallVoidMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) void),
    CallNonvirtualObjectMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jobject),
    CallNonvirtualObjectMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jobject),
    CallNonvirtualObjectMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    CallNonvirtualBooleanMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jboolean),
    CallNonvirtualBooleanMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jboolean),
    CallNonvirtualBooleanMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean),
    CallNonvirtualByteMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jbyte),
    CallNonvirtualByteMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jbyte),
    CallNonvirtualByteMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte),
    CallNonvirtualCharMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jchar),
    CallNonvirtualCharMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jchar),
    CallNonvirtualCharMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar),
    CallNonvirtualShortMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jshort),
    CallNonvirtualShortMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jshort),
    CallNonvirtualShortMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort),
    CallNonvirtualIntMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jint),
    CallNonvirtualIntMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jint),
    CallNonvirtualIntMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint),
    CallNonvirtualLongMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jlong),
    CallNonvirtualLongMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jlong),
    CallNonvirtualLongMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong),
    CallNonvirtualFloatMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jfloat),
    CallNonvirtualFloatMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jfloat),
    CallNonvirtualFloatMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat),
    CallNonvirtualDoubleMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jdouble),
    CallNonvirtualDoubleMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jdouble),
    CallNonvirtualDoubleMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble),
    CallNonvirtualVoidMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) void),
    CallNonvirtualVoidMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) void),
    CallNonvirtualVoidMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) void),
    GetFieldID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID),
    GetObjectField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jobject),
    GetBooleanField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jboolean),
    GetByteField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jbyte),
    GetCharField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jchar),
    GetShortField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jshort),
    GetIntField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jint),
    GetLongField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jlong),
    GetFloatField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jfloat),
    GetDoubleField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jdouble),
    SetObjectField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jobject) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jobject) callconv(.C) void),
    SetBooleanField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jboolean) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jboolean) callconv(.C) void),
    SetByteField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jbyte) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jbyte) callconv(.C) void),
    SetCharField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jchar) callconv(.C) void),
    SetShortField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jshort) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jshort) callconv(.C) void),
    SetIntField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jint) callconv(.C) void),
    SetLongField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jlong) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jlong) callconv(.C) void),
    SetFloatField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jfloat) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jfloat) callconv(.C) void),
    SetDoubleField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jdouble) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jdouble) callconv(.C) void),
    GetStaticMethodID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID),
    CallStaticObjectMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject),
    CallStaticObjectMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jobject),
    CallStaticObjectMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    CallStaticBooleanMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jboolean),
    CallStaticBooleanMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jboolean),
    CallStaticBooleanMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean),
    CallStaticByteMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jbyte),
    CallStaticByteMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jbyte),
    CallStaticByteMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte),
    CallStaticCharMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jchar),
    CallStaticCharMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jchar),
    CallStaticCharMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar),
    CallStaticShortMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jshort),
    CallStaticShortMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jshort),
    CallStaticShortMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort),
    CallStaticIntMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jint),
    CallStaticIntMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jint),
    CallStaticIntMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint),
    CallStaticLongMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jlong),
    CallStaticLongMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jlong),
    CallStaticLongMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong),
    CallStaticFloatMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jfloat),
    CallStaticFloatMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jfloat),
    CallStaticFloatMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat),
    CallStaticDoubleMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jdouble),
    CallStaticDoubleMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) jdouble),
    CallStaticDoubleMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble),
    CallStaticVoidMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) void),
    CallStaticVoidMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]struct___va_list_tag_1) callconv(.C) void),
    CallStaticVoidMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) void),
    GetStaticFieldID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID),
    GetStaticObjectField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jobject),
    GetStaticBooleanField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jboolean),
    GetStaticByteField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jbyte),
    GetStaticCharField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jchar),
    GetStaticShortField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jshort),
    GetStaticIntField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jint),
    GetStaticLongField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jlong),
    GetStaticFloatField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jfloat),
    GetStaticDoubleField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jdouble),
    SetStaticObjectField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jobject) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jobject) callconv(.C) void),
    SetStaticBooleanField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) void),
    SetStaticByteField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jbyte) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jbyte) callconv(.C) void),
    SetStaticCharField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jchar) callconv(.C) void),
    SetStaticShortField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jshort) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jshort) callconv(.C) void),
    SetStaticIntField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jint) callconv(.C) void),
    SetStaticLongField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jlong) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jlong) callconv(.C) void),
    SetStaticFloatField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jfloat) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jfloat) callconv(.C) void),
    SetStaticDoubleField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jdouble) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jdouble) callconv(.C) void),
    NewString: ?*const fn ([*c]JNIEnv, [*c]const jchar, jsize) callconv(.C) jstring = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const jchar, jsize) callconv(.C) jstring),
    GetStringLength: ?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize),
    GetStringChars: ?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar),
    ReleaseStringChars: ?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void),
    NewStringUTF: ?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jstring = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jstring),
    GetStringUTFLength: ?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize),
    GetStringUTFChars: ?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const u8 = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const u8),
    ReleaseStringUTFChars: ?*const fn ([*c]JNIEnv, jstring, [*c]const u8) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]const u8) callconv(.C) void),
    GetArrayLength: ?*const fn ([*c]JNIEnv, jarray) callconv(.C) jsize = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jarray) callconv(.C) jsize),
    NewObjectArray: ?*const fn ([*c]JNIEnv, jsize, jclass, jobject) callconv(.C) jobjectArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize, jclass, jobject) callconv(.C) jobjectArray),
    GetObjectArrayElement: ?*const fn ([*c]JNIEnv, jobjectArray, jsize) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobjectArray, jsize) callconv(.C) jobject),
    SetObjectArrayElement: ?*const fn ([*c]JNIEnv, jobjectArray, jsize, jobject) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobjectArray, jsize, jobject) callconv(.C) void),
    NewBooleanArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbooleanArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbooleanArray),
    NewByteArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbyteArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbyteArray),
    NewCharArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jcharArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jcharArray),
    NewShortArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jshortArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jshortArray),
    NewIntArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jintArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jintArray),
    NewLongArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jlongArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jlongArray),
    NewFloatArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jfloatArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jfloatArray),
    NewDoubleArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jdoubleArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jdoubleArray),
    GetBooleanArrayElements: ?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean) callconv(.C) [*c]jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean) callconv(.C) [*c]jboolean),
    GetByteArrayElements: ?*const fn ([*c]JNIEnv, jbyteArray, [*c]jboolean) callconv(.C) [*c]jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, [*c]jboolean) callconv(.C) [*c]jbyte),
    GetCharArrayElements: ?*const fn ([*c]JNIEnv, jcharArray, [*c]jboolean) callconv(.C) [*c]jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, [*c]jboolean) callconv(.C) [*c]jchar),
    GetShortArrayElements: ?*const fn ([*c]JNIEnv, jshortArray, [*c]jboolean) callconv(.C) [*c]jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, [*c]jboolean) callconv(.C) [*c]jshort),
    GetIntArrayElements: ?*const fn ([*c]JNIEnv, jintArray, [*c]jboolean) callconv(.C) [*c]jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, [*c]jboolean) callconv(.C) [*c]jint),
    GetLongArrayElements: ?*const fn ([*c]JNIEnv, jlongArray, [*c]jboolean) callconv(.C) [*c]jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, [*c]jboolean) callconv(.C) [*c]jlong),
    GetFloatArrayElements: ?*const fn ([*c]JNIEnv, jfloatArray, [*c]jboolean) callconv(.C) [*c]jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, [*c]jboolean) callconv(.C) [*c]jfloat),
    GetDoubleArrayElements: ?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jboolean) callconv(.C) [*c]jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jboolean) callconv(.C) [*c]jdouble),
    ReleaseBooleanArrayElements: ?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean, jint) callconv(.C) void),
    ReleaseByteArrayElements: ?*const fn ([*c]JNIEnv, jbyteArray, [*c]jbyte, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, [*c]jbyte, jint) callconv(.C) void),
    ReleaseCharArrayElements: ?*const fn ([*c]JNIEnv, jcharArray, [*c]jchar, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, [*c]jchar, jint) callconv(.C) void),
    ReleaseShortArrayElements: ?*const fn ([*c]JNIEnv, jshortArray, [*c]jshort, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, [*c]jshort, jint) callconv(.C) void),
    ReleaseIntArrayElements: ?*const fn ([*c]JNIEnv, jintArray, [*c]jint, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, [*c]jint, jint) callconv(.C) void),
    ReleaseLongArrayElements: ?*const fn ([*c]JNIEnv, jlongArray, [*c]jlong, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, [*c]jlong, jint) callconv(.C) void),
    ReleaseFloatArrayElements: ?*const fn ([*c]JNIEnv, jfloatArray, [*c]jfloat, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, [*c]jfloat, jint) callconv(.C) void),
    ReleaseDoubleArrayElements: ?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jdouble, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jdouble, jint) callconv(.C) void),
    GetBooleanArrayRegion: ?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]jboolean) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]jboolean) callconv(.C) void),
    GetByteArrayRegion: ?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]jbyte) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]jbyte) callconv(.C) void),
    GetCharArrayRegion: ?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]jchar) callconv(.C) void),
    GetShortArrayRegion: ?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]jshort) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]jshort) callconv(.C) void),
    GetIntArrayRegion: ?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]jint) callconv(.C) void),
    GetLongArrayRegion: ?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]jlong) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]jlong) callconv(.C) void),
    GetFloatArrayRegion: ?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]jfloat) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]jfloat) callconv(.C) void),
    GetDoubleArrayRegion: ?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]jdouble) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]jdouble) callconv(.C) void),
    SetBooleanArrayRegion: ?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]const jboolean) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]const jboolean) callconv(.C) void),
    SetByteArrayRegion: ?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]const jbyte) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]const jbyte) callconv(.C) void),
    SetCharArrayRegion: ?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]const jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]const jchar) callconv(.C) void),
    SetShortArrayRegion: ?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]const jshort) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]const jshort) callconv(.C) void),
    SetIntArrayRegion: ?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]const jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]const jint) callconv(.C) void),
    SetLongArrayRegion: ?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]const jlong) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]const jlong) callconv(.C) void),
    SetFloatArrayRegion: ?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]const jfloat) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]const jfloat) callconv(.C) void),
    SetDoubleArrayRegion: ?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]const jdouble) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]const jdouble) callconv(.C) void),
    RegisterNatives: ?*const fn ([*c]JNIEnv, jclass, [*c]const JNINativeMethod, jint) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const JNINativeMethod, jint) callconv(.C) jint),
    UnregisterNatives: ?*const fn ([*c]JNIEnv, jclass) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass) callconv(.C) jint),
    MonitorEnter: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint),
    MonitorExit: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint),
    GetJavaVM: ?*const fn ([*c]JNIEnv, [*c][*c]JavaVM) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c][*c]JavaVM) callconv(.C) jint),
    GetStringRegion: ?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]jchar) callconv(.C) void),
    GetStringUTFRegion: ?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]u8) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]u8) callconv(.C) void),
    GetPrimitiveArrayCritical: ?*const fn ([*c]JNIEnv, jarray, [*c]jboolean) callconv(.C) ?*anyopaque = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jarray, [*c]jboolean) callconv(.C) ?*anyopaque),
    ReleasePrimitiveArrayCritical: ?*const fn ([*c]JNIEnv, jarray, ?*anyopaque, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jarray, ?*anyopaque, jint) callconv(.C) void),
    GetStringCritical: ?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar),
    ReleaseStringCritical: ?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void),
    NewWeakGlobalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jweak = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jweak),
    DeleteWeakGlobalRef: ?*const fn ([*c]JNIEnv, jweak) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jweak) callconv(.C) void),
    ExceptionCheck: ?*const fn ([*c]JNIEnv) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) jboolean),
    NewDirectByteBuffer: ?*const fn ([*c]JNIEnv, ?*anyopaque, jlong) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, ?*anyopaque, jlong) callconv(.C) jobject),
    GetDirectBufferAddress: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) ?*anyopaque = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) ?*anyopaque),
    GetDirectBufferCapacity: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jlong),
    GetObjectRefType: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobjectRefType = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobjectRefType),
    GetModule: ?*const fn ([*c]JNIEnv, jclass) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass) callconv(.C) jobject),
    IsVirtualThread: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jboolean),
};
pub const struct_JNIEnv_ = extern struct {
    functions: [*c]const struct_JNINativeInterface_ = @import("std").mem.zeroes([*c]const struct_JNINativeInterface_),
};
pub const struct_JavaVM_ = extern struct {
    functions: [*c]const struct_JNIInvokeInterface_ = @import("std").mem.zeroes([*c]const struct_JNIInvokeInterface_),
};
pub const struct_JavaVMOption = extern struct {
    optionString: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    extraInfo: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const JavaVMOption = struct_JavaVMOption;
pub const struct_JavaVMInitArgs = extern struct {
    version: jint = @import("std").mem.zeroes(jint),
    nOptions: jint = @import("std").mem.zeroes(jint),
    options: [*c]JavaVMOption = @import("std").mem.zeroes([*c]JavaVMOption),
    ignoreUnrecognized: jboolean = @import("std").mem.zeroes(jboolean),
};
pub const JavaVMInitArgs = struct_JavaVMInitArgs;
pub const struct_JavaVMAttachArgs = extern struct {
    version: jint = @import("std").mem.zeroes(jint),
    name: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    group: jobject = @import("std").mem.zeroes(jobject),
};
pub const JavaVMAttachArgs = struct_JavaVMAttachArgs;
pub extern fn JNI_GetDefaultJavaVMInitArgs(args: ?*anyopaque) jint;
pub extern fn JNI_CreateJavaVM(pvm: [*c][*c]JavaVM, penv: [*c]?*anyopaque, args: ?*anyopaque) jint;
pub extern fn JNI_GetCreatedJavaVMs([*c][*c]JavaVM, jsize, [*c]jsize) jint;
pub extern fn JNI_OnLoad(vm: [*c]JavaVM, reserved: ?*anyopaque) jint;
pub extern fn JNI_OnUnload(vm: [*c]JavaVM, reserved: ?*anyopaque) void;
pub const __llvm__ = @as(c_int, 1);
pub const __clang__ = @as(c_int, 1);
pub const __clang_major__ = @as(c_int, 18);
pub const __clang_minor__ = @as(c_int, 1);
pub const __clang_patchlevel__ = @as(c_int, 8);
pub const __clang_version__ = "18.1.8 ";
pub const __GNUC__ = @as(c_int, 4);
pub const __GNUC_MINOR__ = @as(c_int, 2);
pub const __GNUC_PATCHLEVEL__ = @as(c_int, 1);
pub const __GXX_ABI_VERSION = @as(c_int, 1002);
pub const __ATOMIC_RELAXED = @as(c_int, 0);
pub const __ATOMIC_CONSUME = @as(c_int, 1);
pub const __ATOMIC_ACQUIRE = @as(c_int, 2);
pub const __ATOMIC_RELEASE = @as(c_int, 3);
pub const __ATOMIC_ACQ_REL = @as(c_int, 4);
pub const __ATOMIC_SEQ_CST = @as(c_int, 5);
pub const __MEMORY_SCOPE_SYSTEM = @as(c_int, 0);
pub const __MEMORY_SCOPE_DEVICE = @as(c_int, 1);
pub const __MEMORY_SCOPE_WRKGRP = @as(c_int, 2);
pub const __MEMORY_SCOPE_WVFRNT = @as(c_int, 3);
pub const __MEMORY_SCOPE_SINGLE = @as(c_int, 4);
pub const __OPENCL_MEMORY_SCOPE_WORK_ITEM = @as(c_int, 0);
pub const __OPENCL_MEMORY_SCOPE_WORK_GROUP = @as(c_int, 1);
pub const __OPENCL_MEMORY_SCOPE_DEVICE = @as(c_int, 2);
pub const __OPENCL_MEMORY_SCOPE_ALL_SVM_DEVICES = @as(c_int, 3);
pub const __OPENCL_MEMORY_SCOPE_SUB_GROUP = @as(c_int, 4);
pub const __FPCLASS_SNAN = @as(c_int, 0x0001);
pub const __FPCLASS_QNAN = @as(c_int, 0x0002);
pub const __FPCLASS_NEGINF = @as(c_int, 0x0004);
pub const __FPCLASS_NEGNORMAL = @as(c_int, 0x0008);
pub const __FPCLASS_NEGSUBNORMAL = @as(c_int, 0x0010);
pub const __FPCLASS_NEGZERO = @as(c_int, 0x0020);
pub const __FPCLASS_POSZERO = @as(c_int, 0x0040);
pub const __FPCLASS_POSSUBNORMAL = @as(c_int, 0x0080);
pub const __FPCLASS_POSNORMAL = @as(c_int, 0x0100);
pub const __FPCLASS_POSINF = @as(c_int, 0x0200);
pub const __PRAGMA_REDEFINE_EXTNAME = @as(c_int, 1);
pub const __VERSION__ = "Clang 18.1.8";
pub const __OBJC_BOOL_IS_BOOL = @as(c_int, 0);
pub const __CONSTANT_CFSTRINGS__ = @as(c_int, 1);
pub const __clang_literal_encoding__ = "UTF-8";
pub const __clang_wide_literal_encoding__ = "UTF-32";
pub const __ORDER_LITTLE_ENDIAN__ = @as(c_int, 1234);
pub const __ORDER_BIG_ENDIAN__ = @as(c_int, 4321);
pub const __ORDER_PDP_ENDIAN__ = @as(c_int, 3412);
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = @as(c_int, 1);
pub const _LP64 = @as(c_int, 1);
pub const __LP64__ = @as(c_int, 1);
pub const __CHAR_BIT__ = @as(c_int, 8);
pub const __BOOL_WIDTH__ = @as(c_int, 8);
pub const __SHRT_WIDTH__ = @as(c_int, 16);
pub const __INT_WIDTH__ = @as(c_int, 32);
pub const __LONG_WIDTH__ = @as(c_int, 64);
pub const __LLONG_WIDTH__ = @as(c_int, 64);
pub const __BITINT_MAXWIDTH__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 8388608, .decimal);
pub const __SCHAR_MAX__ = @as(c_int, 127);
pub const __SHRT_MAX__ = @as(c_int, 32767);
pub const __INT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __LONG_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __WCHAR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __WCHAR_WIDTH__ = @as(c_int, 32);
pub const __WINT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __WINT_WIDTH__ = @as(c_int, 32);
pub const __INTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTMAX_WIDTH__ = @as(c_int, 64);
pub const __SIZE_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __SIZE_WIDTH__ = @as(c_int, 64);
pub const __UINTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTMAX_WIDTH__ = @as(c_int, 64);
pub const __PTRDIFF_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __PTRDIFF_WIDTH__ = @as(c_int, 64);
pub const __INTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTPTR_WIDTH__ = @as(c_int, 64);
pub const __UINTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTPTR_WIDTH__ = @as(c_int, 64);
pub const __SIZEOF_DOUBLE__ = @as(c_int, 8);
pub const __SIZEOF_FLOAT__ = @as(c_int, 4);
pub const __SIZEOF_INT__ = @as(c_int, 4);
pub const __SIZEOF_LONG__ = @as(c_int, 8);
pub const __SIZEOF_LONG_DOUBLE__ = @as(c_int, 16);
pub const __SIZEOF_LONG_LONG__ = @as(c_int, 8);
pub const __SIZEOF_POINTER__ = @as(c_int, 8);
pub const __SIZEOF_SHORT__ = @as(c_int, 2);
pub const __SIZEOF_PTRDIFF_T__ = @as(c_int, 8);
pub const __SIZEOF_SIZE_T__ = @as(c_int, 8);
pub const __SIZEOF_WCHAR_T__ = @as(c_int, 4);
pub const __SIZEOF_WINT_T__ = @as(c_int, 4);
pub const __SIZEOF_INT128__ = @as(c_int, 16);
pub const __INTMAX_TYPE__ = c_long;
pub const __INTMAX_FMTd__ = "ld";
pub const __INTMAX_FMTi__ = "li";
pub const __INTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`");
// (no file):95:9
pub const __UINTMAX_TYPE__ = c_ulong;
pub const __UINTMAX_FMTo__ = "lo";
pub const __UINTMAX_FMTu__ = "lu";
pub const __UINTMAX_FMTx__ = "lx";
pub const __UINTMAX_FMTX__ = "lX";
pub const __UINTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`");
// (no file):101:9
pub const __PTRDIFF_TYPE__ = c_long;
pub const __PTRDIFF_FMTd__ = "ld";
pub const __PTRDIFF_FMTi__ = "li";
pub const __INTPTR_TYPE__ = c_long;
pub const __INTPTR_FMTd__ = "ld";
pub const __INTPTR_FMTi__ = "li";
pub const __SIZE_TYPE__ = c_ulong;
pub const __SIZE_FMTo__ = "lo";
pub const __SIZE_FMTu__ = "lu";
pub const __SIZE_FMTx__ = "lx";
pub const __SIZE_FMTX__ = "lX";
pub const __WCHAR_TYPE__ = c_int;
pub const __WINT_TYPE__ = c_uint;
pub const __SIG_ATOMIC_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __SIG_ATOMIC_WIDTH__ = @as(c_int, 32);
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __UINTPTR_TYPE__ = c_ulong;
pub const __UINTPTR_FMTo__ = "lo";
pub const __UINTPTR_FMTu__ = "lu";
pub const __UINTPTR_FMTx__ = "lx";
pub const __UINTPTR_FMTX__ = "lX";
pub const __FLT16_DENORM_MIN__ = @as(f16, 5.9604644775390625e-8);
pub const __FLT16_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT16_DIG__ = @as(c_int, 3);
pub const __FLT16_DECIMAL_DIG__ = @as(c_int, 5);
pub const __FLT16_EPSILON__ = @as(f16, 9.765625e-4);
pub const __FLT16_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT16_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT16_MANT_DIG__ = @as(c_int, 11);
pub const __FLT16_MAX_10_EXP__ = @as(c_int, 4);
pub const __FLT16_MAX_EXP__ = @as(c_int, 16);
pub const __FLT16_MAX__ = @as(f16, 6.5504e+4);
pub const __FLT16_MIN_10_EXP__ = -@as(c_int, 4);
pub const __FLT16_MIN_EXP__ = -@as(c_int, 13);
pub const __FLT16_MIN__ = @as(f16, 6.103515625e-5);
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT_DIG__ = @as(c_int, 6);
pub const __FLT_DECIMAL_DIG__ = @as(c_int, 9);
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT_MANT_DIG__ = @as(c_int, 24);
pub const __FLT_MAX_10_EXP__ = @as(c_int, 38);
pub const __FLT_MAX_EXP__ = @as(c_int, 128);
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -@as(c_int, 37);
pub const __FLT_MIN_EXP__ = -@as(c_int, 125);
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = @as(f64, 4.9406564584124654e-324);
pub const __DBL_HAS_DENORM__ = @as(c_int, 1);
pub const __DBL_DIG__ = @as(c_int, 15);
pub const __DBL_DECIMAL_DIG__ = @as(c_int, 17);
pub const __DBL_EPSILON__ = @as(f64, 2.2204460492503131e-16);
pub const __DBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __DBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __DBL_MANT_DIG__ = @as(c_int, 53);
pub const __DBL_MAX_10_EXP__ = @as(c_int, 308);
pub const __DBL_MAX_EXP__ = @as(c_int, 1024);
pub const __DBL_MAX__ = @as(f64, 1.7976931348623157e+308);
pub const __DBL_MIN_10_EXP__ = -@as(c_int, 307);
pub const __DBL_MIN_EXP__ = -@as(c_int, 1021);
pub const __DBL_MIN__ = @as(f64, 2.2250738585072014e-308);
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_HAS_DENORM__ = @as(c_int, 1);
pub const __LDBL_DIG__ = @as(c_int, 18);
pub const __LDBL_DECIMAL_DIG__ = @as(c_int, 21);
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __LDBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __LDBL_MANT_DIG__ = @as(c_int, 64);
pub const __LDBL_MAX_10_EXP__ = @as(c_int, 4932);
pub const __LDBL_MAX_EXP__ = @as(c_int, 16384);
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -@as(c_int, 4931);
pub const __LDBL_MIN_EXP__ = -@as(c_int, 16381);
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __POINTER_WIDTH__ = @as(c_int, 64);
pub const __BIGGEST_ALIGNMENT__ = @as(c_int, 16);
pub const __WINT_UNSIGNED__ = @as(c_int, 1);
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT8_C_SUFFIX__ = "";
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT16_C_SUFFIX__ = "";
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT32_C_SUFFIX__ = "";
pub const __INT64_TYPE__ = c_long;
pub const __INT64_FMTd__ = "ld";
pub const __INT64_FMTi__ = "li";
pub const __INT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`");
// (no file):198:9
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_C_SUFFIX__ = "";
pub const __UINT8_MAX__ = @as(c_int, 255);
pub const __INT8_MAX__ = @as(c_int, 127);
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_C_SUFFIX__ = "";
pub const __UINT16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __INT16_MAX__ = @as(c_int, 32767);
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `U`");
// (no file):220:9
pub const __UINT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __UINT64_TYPE__ = c_ulong;
pub const __UINT64_FMTo__ = "lo";
pub const __UINT64_FMTu__ = "lu";
pub const __UINT64_FMTx__ = "lx";
pub const __UINT64_FMTX__ = "lX";
pub const __UINT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`");
// (no file):228:9
pub const __UINT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __INT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = @as(c_int, 127);
pub const __INT_LEAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_LEAST8_FMTd__ = "hhd";
pub const __INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = @as(c_int, 255);
pub const __UINT_LEAST8_FMTo__ = "hho";
pub const __UINT_LEAST8_FMTu__ = "hhu";
pub const __UINT_LEAST8_FMTx__ = "hhx";
pub const __UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = @as(c_int, 32767);
pub const __INT_LEAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_LEAST16_FMTd__ = "hd";
pub const __INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_LEAST16_FMTo__ = "ho";
pub const __UINT_LEAST16_FMTu__ = "hu";
pub const __UINT_LEAST16_FMTx__ = "hx";
pub const __UINT_LEAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_LEAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_LEAST32_FMTd__ = "d";
pub const __INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_LEAST32_FMTo__ = "o";
pub const __UINT_LEAST32_FMTu__ = "u";
pub const __UINT_LEAST32_FMTx__ = "x";
pub const __UINT_LEAST32_FMTX__ = "X";
pub const __INT_LEAST64_TYPE__ = c_long;
pub const __INT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_LEAST64_FMTd__ = "ld";
pub const __INT_LEAST64_FMTi__ = "li";
pub const __UINT_LEAST64_TYPE__ = c_ulong;
pub const __UINT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_LEAST64_FMTo__ = "lo";
pub const __UINT_LEAST64_FMTu__ = "lu";
pub const __UINT_LEAST64_FMTx__ = "lx";
pub const __UINT_LEAST64_FMTX__ = "lX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = @as(c_int, 127);
pub const __INT_FAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_FAST8_FMTd__ = "hhd";
pub const __INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = @as(c_int, 255);
pub const __UINT_FAST8_FMTo__ = "hho";
pub const __UINT_FAST8_FMTu__ = "hhu";
pub const __UINT_FAST8_FMTx__ = "hhx";
pub const __UINT_FAST8_FMTX__ = "hhX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = @as(c_int, 32767);
pub const __INT_FAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_FAST16_FMTd__ = "hd";
pub const __INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_FAST16_FMTo__ = "ho";
pub const __UINT_FAST16_FMTu__ = "hu";
pub const __UINT_FAST16_FMTx__ = "hx";
pub const __UINT_FAST16_FMTX__ = "hX";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_FAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_FAST32_FMTd__ = "d";
pub const __INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_FAST32_FMTo__ = "o";
pub const __UINT_FAST32_FMTu__ = "u";
pub const __UINT_FAST32_FMTx__ = "x";
pub const __UINT_FAST32_FMTX__ = "X";
pub const __INT_FAST64_TYPE__ = c_long;
pub const __INT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_FAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_FAST64_FMTd__ = "ld";
pub const __INT_FAST64_FMTi__ = "li";
pub const __UINT_FAST64_TYPE__ = c_ulong;
pub const __UINT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_FAST64_FMTo__ = "lo";
pub const __UINT_FAST64_FMTu__ = "lu";
pub const __UINT_FAST64_FMTx__ = "lx";
pub const __UINT_FAST64_FMTX__ = "lX";
pub const __USER_LABEL_PREFIX__ = "";
pub const __FINITE_MATH_ONLY__ = @as(c_int, 0);
pub const __GNUC_STDC_INLINE__ = @as(c_int, 1);
pub const __GCC_ATOMIC_TEST_AND_SET_TRUEVAL = @as(c_int, 1);
pub const __CLANG_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __NO_INLINE__ = @as(c_int, 1);
pub const __PIC__ = @as(c_int, 2);
pub const __pic__ = @as(c_int, 2);
pub const __PIE__ = @as(c_int, 2);
pub const __pie__ = @as(c_int, 2);
pub const __FLT_RADIX__ = @as(c_int, 2);
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __ELF__ = @as(c_int, 1);
pub const __GCC_ASM_FLAG_OUTPUTS__ = @as(c_int, 1);
pub const __code_model_small__ = @as(c_int, 1);
pub const __amd64__ = @as(c_int, 1);
pub const __amd64 = @as(c_int, 1);
pub const __x86_64 = @as(c_int, 1);
pub const __x86_64__ = @as(c_int, 1);
pub const __SEG_GS = @as(c_int, 1);
pub const __SEG_FS = @as(c_int, 1);
pub const __seg_gs = @compileError("unable to translate macro: undefined identifier `address_space`");
// (no file):359:9
pub const __seg_fs = @compileError("unable to translate macro: undefined identifier `address_space`");
// (no file):360:9
pub const __k8 = @as(c_int, 1);
pub const __k8__ = @as(c_int, 1);
pub const __tune_k8__ = @as(c_int, 1);
pub const __REGISTER_PREFIX__ = "";
pub const __NO_MATH_INLINES = @as(c_int, 1);
pub const __AES__ = @as(c_int, 1);
pub const __VAES__ = @as(c_int, 1);
pub const __PCLMUL__ = @as(c_int, 1);
pub const __VPCLMULQDQ__ = @as(c_int, 1);
pub const __LAHF_SAHF__ = @as(c_int, 1);
pub const __LZCNT__ = @as(c_int, 1);
pub const __RDRND__ = @as(c_int, 1);
pub const __FSGSBASE__ = @as(c_int, 1);
pub const __BMI__ = @as(c_int, 1);
pub const __BMI2__ = @as(c_int, 1);
pub const __POPCNT__ = @as(c_int, 1);
pub const __PRFCHW__ = @as(c_int, 1);
pub const __RDSEED__ = @as(c_int, 1);
pub const __ADX__ = @as(c_int, 1);
pub const __MOVBE__ = @as(c_int, 1);
pub const __FMA__ = @as(c_int, 1);
pub const __F16C__ = @as(c_int, 1);
pub const __GFNI__ = @as(c_int, 1);
pub const __SHA__ = @as(c_int, 1);
pub const __FXSR__ = @as(c_int, 1);
pub const __XSAVE__ = @as(c_int, 1);
pub const __XSAVEOPT__ = @as(c_int, 1);
pub const __XSAVEC__ = @as(c_int, 1);
pub const __XSAVES__ = @as(c_int, 1);
pub const __PKU__ = @as(c_int, 1);
pub const __CLFLUSHOPT__ = @as(c_int, 1);
pub const __CLWB__ = @as(c_int, 1);
pub const __SHSTK__ = @as(c_int, 1);
pub const __RDPID__ = @as(c_int, 1);
pub const __WAITPKG__ = @as(c_int, 1);
pub const __MOVDIRI__ = @as(c_int, 1);
pub const __MOVDIR64B__ = @as(c_int, 1);
pub const __PCONFIG__ = @as(c_int, 1);
pub const __PTWRITE__ = @as(c_int, 1);
pub const __INVPCID__ = @as(c_int, 1);
pub const __AVX2__ = @as(c_int, 1);
pub const __AVX__ = @as(c_int, 1);
pub const __SSE4_2__ = @as(c_int, 1);
pub const __SSE4_1__ = @as(c_int, 1);
pub const __SSSE3__ = @as(c_int, 1);
pub const __SSE3__ = @as(c_int, 1);
pub const __SSE2__ = @as(c_int, 1);
pub const __SSE2_MATH__ = @as(c_int, 1);
pub const __SSE__ = @as(c_int, 1);
pub const __SSE_MATH__ = @as(c_int, 1);
pub const __MMX__ = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_16 = @as(c_int, 1);
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const unix = @as(c_int, 1);
pub const __unix = @as(c_int, 1);
pub const __unix__ = @as(c_int, 1);
pub const linux = @as(c_int, 1);
pub const __linux = @as(c_int, 1);
pub const __linux__ = @as(c_int, 1);
pub const __gnu_linux__ = @as(c_int, 1);
pub const __FLOAT128__ = @as(c_int, 1);
pub const __STDC__ = @as(c_int, 1);
pub const __STDC_HOSTED__ = @as(c_int, 1);
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __STDC_UTF_16__ = @as(c_int, 1);
pub const __STDC_UTF_32__ = @as(c_int, 1);
pub const _DEBUG = @as(c_int, 1);
pub const __GCC_HAVE_DWARF2_CFI_ASM = @as(c_int, 1);
pub const _JAVASOFT_JNI_H_ = "";
pub const _STDIO_H = @as(c_int, 1);
pub const __GLIBC_INTERNAL_STARTING_HEADER_IMPLEMENTATION = "";
pub const _FEATURES_H = @as(c_int, 1);
pub const __KERNEL_STRICT_NAMES = "";
pub inline fn __GNUC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub inline fn __glibc_clang_prereq(maj: anytype, min: anytype) @TypeOf(((__clang_major__ << @as(c_int, 16)) + __clang_minor__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__clang_major__ << @as(c_int, 16)) + __clang_minor__) >= ((maj << @as(c_int, 16)) + min);
}
pub const __GLIBC_USE = @compileError("unable to translate macro: undefined identifier `__GLIBC_USE_`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/features.h:188:9
pub const _DEFAULT_SOURCE = @as(c_int, 1);
pub const __GLIBC_USE_ISOC2X = @as(c_int, 0);
pub const __USE_ISOC11 = @as(c_int, 1);
pub const __USE_ISOC99 = @as(c_int, 1);
pub const __USE_ISOC95 = @as(c_int, 1);
pub const __USE_POSIX_IMPLICITLY = @as(c_int, 1);
pub const _POSIX_SOURCE = @as(c_int, 1);
pub const _POSIX_C_SOURCE = @as(c_long, 200809);
pub const __USE_POSIX = @as(c_int, 1);
pub const __USE_POSIX2 = @as(c_int, 1);
pub const __USE_POSIX199309 = @as(c_int, 1);
pub const __USE_POSIX199506 = @as(c_int, 1);
pub const __USE_XOPEN2K = @as(c_int, 1);
pub const __USE_XOPEN2K8 = @as(c_int, 1);
pub const _ATFILE_SOURCE = @as(c_int, 1);
pub const __WORDSIZE = @as(c_int, 64);
pub const __WORDSIZE_TIME64_COMPAT32 = @as(c_int, 1);
pub const __SYSCALL_WORDSIZE = @as(c_int, 64);
pub const __TIMESIZE = __WORDSIZE;
pub const __USE_MISC = @as(c_int, 1);
pub const __USE_ATFILE = @as(c_int, 1);
pub const __USE_FORTIFY_LEVEL = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_GETS = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_SCANF = @as(c_int, 0);
pub const __GLIBC_USE_C2X_STRTOL = @as(c_int, 0);
pub const _STDC_PREDEF_H = @as(c_int, 1);
pub const __STDC_IEC_559__ = @as(c_int, 1);
pub const __STDC_IEC_60559_BFP__ = @as(c_long, 201404);
pub const __STDC_IEC_559_COMPLEX__ = @as(c_int, 1);
pub const __STDC_IEC_60559_COMPLEX__ = @as(c_long, 201404);
pub const __STDC_ISO_10646__ = @as(c_long, 201706);
pub const __GNU_LIBRARY__ = @as(c_int, 6);
pub const __GLIBC__ = @as(c_int, 2);
pub const __GLIBC_MINOR__ = @as(c_int, 39);
pub inline fn __GLIBC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub const _SYS_CDEFS_H = @as(c_int, 1);
pub const __glibc_has_attribute = @compileError("unable to translate macro: undefined identifier `__has_attribute`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:45:10
pub inline fn __glibc_has_builtin(name: anytype) @TypeOf(__has_builtin(name)) {
    _ = &name;
    return __has_builtin(name);
}
pub const __glibc_has_extension = @compileError("unable to translate macro: undefined identifier `__has_extension`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:55:10
pub const __LEAF = "";
pub const __LEAF_ATTR = "";
pub const __THROW = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:79:11
pub const __THROWNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:80:11
pub const __NTH = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:81:11
pub const __NTHNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:82:11
pub const __COLD = @compileError("unable to translate macro: undefined identifier `__cold__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:102:11
pub inline fn __P(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub inline fn __PMT(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub const __CONCAT = @compileError("unable to translate C expr: unexpected token '##'");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:131:9
pub const __STRING = @compileError("unable to translate C expr: unexpected token '#'");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:132:9
pub const __ptr_t = ?*anyopaque;
pub const __BEGIN_DECLS = "";
pub const __END_DECLS = "";
pub inline fn __bos(ptr: anytype) @TypeOf(__builtin_object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1))) {
    _ = &ptr;
    return __builtin_object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1));
}
pub inline fn __bos0(ptr: anytype) @TypeOf(__builtin_object_size(ptr, @as(c_int, 0))) {
    _ = &ptr;
    return __builtin_object_size(ptr, @as(c_int, 0));
}
pub inline fn __glibc_objsize0(__o: anytype) @TypeOf(__bos0(__o)) {
    _ = &__o;
    return __bos0(__o);
}
pub inline fn __glibc_objsize(__o: anytype) @TypeOf(__bos(__o)) {
    _ = &__o;
    return __bos(__o);
}
pub const __warnattr = @compileError("unable to translate C expr: unexpected token ''");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:216:10
pub const __errordecl = @compileError("unable to translate C expr: unexpected token 'extern'");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:217:10
pub const __flexarr = @compileError("unable to translate C expr: unexpected token '['");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:225:10
pub const __glibc_c99_flexarr_available = @as(c_int, 1);
pub const __REDIRECT = @compileError("unable to translate C expr: unexpected token '__asm__'");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:256:10
pub const __REDIRECT_NTH = @compileError("unable to translate C expr: unexpected token '__asm__'");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:263:11
pub const __REDIRECT_NTHNL = @compileError("unable to translate C expr: unexpected token '__asm__'");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:265:11
pub const __ASMNAME = @compileError("unable to translate C expr: unexpected token ','");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:268:10
pub inline fn __ASMNAME2(prefix: anytype, cname: anytype) @TypeOf(__STRING(prefix) ++ cname) {
    _ = &prefix;
    _ = &cname;
    return __STRING(prefix) ++ cname;
}
pub const __REDIRECT_FORTIFY = __REDIRECT;
pub const __REDIRECT_FORTIFY_NTH = __REDIRECT_NTH;
pub const __attribute_malloc__ = @compileError("unable to translate macro: undefined identifier `__malloc__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:298:10
pub const __attribute_alloc_size__ = @compileError("unable to translate C expr: unexpected token ''");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:309:10
pub const __attribute_alloc_align__ = @compileError("unable to translate macro: undefined identifier `__alloc_align__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:315:10
pub const __attribute_pure__ = @compileError("unable to translate macro: undefined identifier `__pure__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:325:10
pub const __attribute_const__ = @compileError("unable to translate C expr: unexpected token '__attribute__'");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:332:10
pub const __attribute_maybe_unused__ = @compileError("unable to translate macro: undefined identifier `__unused__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:338:10
pub const __attribute_used__ = @compileError("unable to translate macro: undefined identifier `__used__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:347:10
pub const __attribute_noinline__ = @compileError("unable to translate macro: undefined identifier `__noinline__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:348:10
pub const __attribute_deprecated__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:356:10
pub const __attribute_deprecated_msg__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:366:10
pub const __attribute_format_arg__ = @compileError("unable to translate macro: undefined identifier `__format_arg__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:379:10
pub const __attribute_format_strfmon__ = @compileError("unable to translate macro: undefined identifier `__format__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:389:10
pub const __attribute_nonnull__ = @compileError("unable to translate macro: undefined identifier `__nonnull__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:401:11
pub inline fn __nonnull(params: anytype) @TypeOf(__attribute_nonnull__(params)) {
    _ = &params;
    return __attribute_nonnull__(params);
}
pub const __returns_nonnull = @compileError("unable to translate macro: undefined identifier `__returns_nonnull__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:414:10
pub const __attribute_warn_unused_result__ = @compileError("unable to translate macro: undefined identifier `__warn_unused_result__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:423:10
pub const __wur = "";
pub const __always_inline = @compileError("unable to translate macro: undefined identifier `__always_inline__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:441:10
pub const __attribute_artificial__ = @compileError("unable to translate macro: undefined identifier `__artificial__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:450:10
pub const __extern_inline = @compileError("unable to translate macro: undefined identifier `__gnu_inline__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:468:11
pub const __extern_always_inline = @compileError("unable to translate macro: undefined identifier `__gnu_inline__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:469:11
pub const __fortify_function = __extern_always_inline ++ __attribute_artificial__;
pub const __restrict_arr = @compileError("unable to translate C expr: unexpected token '__restrict'");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:512:10
pub inline fn __glibc_unlikely(cond: anytype) @TypeOf(__builtin_expect(cond, @as(c_int, 0))) {
    _ = &cond;
    return __builtin_expect(cond, @as(c_int, 0));
}
pub inline fn __glibc_likely(cond: anytype) @TypeOf(__builtin_expect(cond, @as(c_int, 1))) {
    _ = &cond;
    return __builtin_expect(cond, @as(c_int, 1));
}
pub const __attribute_nonstring__ = "";
pub const __attribute_copy__ = @compileError("unable to translate C expr: unexpected token ''");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:561:10
pub const __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = @as(c_int, 0);
pub inline fn __LDBL_REDIR1(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR(name: anytype, proto: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR1_NTH(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto ++ __THROW;
}
pub inline fn __LDBL_REDIR_NTH(name: anytype, proto: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    return name ++ proto ++ __THROW;
}
pub const __LDBL_REDIR2_DECL = @compileError("unable to translate C expr: unexpected token ''");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:638:10
pub const __LDBL_REDIR_DECL = @compileError("unable to translate C expr: unexpected token ''");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:639:10
pub inline fn __REDIRECT_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT(name, proto, alias);
}
pub inline fn __REDIRECT_NTH_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT_NTH(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT_NTH(name, proto, alias);
}
pub const __glibc_macro_warning1 = @compileError("unable to translate macro: undefined identifier `_Pragma`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:653:10
pub const __glibc_macro_warning = @compileError("unable to translate macro: undefined identifier `GCC`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:654:10
pub const __HAVE_GENERIC_SELECTION = @as(c_int, 1);
pub const __fortified_attr_access = @compileError("unable to translate C expr: unexpected token ''");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:699:11
pub const __attr_access = @compileError("unable to translate C expr: unexpected token ''");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:700:11
pub const __attr_access_none = @compileError("unable to translate C expr: unexpected token ''");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:701:11
pub const __attr_dealloc = @compileError("unable to translate C expr: unexpected token ''");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:711:10
pub const __attr_dealloc_free = "";
pub const __attribute_returns_twice__ = @compileError("unable to translate macro: undefined identifier `__returns_twice__`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/sys/cdefs.h:718:10
pub const __stub___compat_bdflush = "";
pub const __stub_chflags = "";
pub const __stub_fchflags = "";
pub const __stub_gtty = "";
pub const __stub_revoke = "";
pub const __stub_setlogin = "";
pub const __stub_sigreturn = "";
pub const __stub_stty = "";
pub const __GLIBC_USE_LIB_EXT2 = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT_C2X = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_TYPES_EXT = @as(c_int, 0);
pub const __need_size_t = "";
pub const __need_NULL = "";
pub const _SIZE_T = "";
pub const NULL = @import("std").zig.c_translation.cast(?*anyopaque, @as(c_int, 0));
pub const __need___va_list = "";
pub const __GNUC_VA_LIST = "";
pub const _BITS_TYPES_H = @as(c_int, 1);
pub const __S16_TYPE = c_short;
pub const __U16_TYPE = c_ushort;
pub const __S32_TYPE = c_int;
pub const __U32_TYPE = c_uint;
pub const __SLONGWORD_TYPE = c_long;
pub const __ULONGWORD_TYPE = c_ulong;
pub const __SQUAD_TYPE = c_long;
pub const __UQUAD_TYPE = c_ulong;
pub const __SWORD_TYPE = c_long;
pub const __UWORD_TYPE = c_ulong;
pub const __SLONG32_TYPE = c_int;
pub const __ULONG32_TYPE = c_uint;
pub const __S64_TYPE = c_long;
pub const __U64_TYPE = c_ulong;
pub const __STD_TYPE = @compileError("unable to translate C expr: unexpected token 'typedef'");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/types.h:137:10
pub const _BITS_TYPESIZES_H = @as(c_int, 1);
pub const __SYSCALL_SLONG_TYPE = __SLONGWORD_TYPE;
pub const __SYSCALL_ULONG_TYPE = __ULONGWORD_TYPE;
pub const __DEV_T_TYPE = __UQUAD_TYPE;
pub const __UID_T_TYPE = __U32_TYPE;
pub const __GID_T_TYPE = __U32_TYPE;
pub const __INO_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __INO64_T_TYPE = __UQUAD_TYPE;
pub const __MODE_T_TYPE = __U32_TYPE;
pub const __NLINK_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSWORD_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF64_T_TYPE = __SQUAD_TYPE;
pub const __PID_T_TYPE = __S32_TYPE;
pub const __RLIM_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __RLIM64_T_TYPE = __UQUAD_TYPE;
pub const __BLKCNT_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __BLKCNT64_T_TYPE = __SQUAD_TYPE;
pub const __FSBLKCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSBLKCNT64_T_TYPE = __UQUAD_TYPE;
pub const __FSFILCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSFILCNT64_T_TYPE = __UQUAD_TYPE;
pub const __ID_T_TYPE = __U32_TYPE;
pub const __CLOCK_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __TIME_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __USECONDS_T_TYPE = __U32_TYPE;
pub const __SUSECONDS_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __SUSECONDS64_T_TYPE = __SQUAD_TYPE;
pub const __DADDR_T_TYPE = __S32_TYPE;
pub const __KEY_T_TYPE = __S32_TYPE;
pub const __CLOCKID_T_TYPE = __S32_TYPE;
pub const __TIMER_T_TYPE = ?*anyopaque;
pub const __BLKSIZE_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __FSID_T_TYPE = @compileError("unable to translate macro: undefined identifier `__val`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/typesizes.h:73:9
pub const __SSIZE_T_TYPE = __SWORD_TYPE;
pub const __CPU_MASK_TYPE = __SYSCALL_ULONG_TYPE;
pub const __OFF_T_MATCHES_OFF64_T = @as(c_int, 1);
pub const __INO_T_MATCHES_INO64_T = @as(c_int, 1);
pub const __RLIM_T_MATCHES_RLIM64_T = @as(c_int, 1);
pub const __STATFS_MATCHES_STATFS64 = @as(c_int, 1);
pub const __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = @as(c_int, 1);
pub const __FD_SETSIZE = @as(c_int, 1024);
pub const _BITS_TIME64_H = @as(c_int, 1);
pub const __TIME64_T_TYPE = __TIME_T_TYPE;
pub const _____fpos_t_defined = @as(c_int, 1);
pub const ____mbstate_t_defined = @as(c_int, 1);
pub const _____fpos64_t_defined = @as(c_int, 1);
pub const ____FILE_defined = @as(c_int, 1);
pub const __FILE_defined = @as(c_int, 1);
pub const __struct_FILE_defined = @as(c_int, 1);
pub const __getc_unlocked_body = @compileError("TODO postfix inc/dec expr");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/types/struct_FILE.h:102:9
pub const __putc_unlocked_body = @compileError("TODO postfix inc/dec expr");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/types/struct_FILE.h:106:9
pub const _IO_EOF_SEEN = @as(c_int, 0x0010);
pub inline fn __feof_unlocked_body(_fp: anytype) @TypeOf((_fp.*._flags & _IO_EOF_SEEN) != @as(c_int, 0)) {
    _ = &_fp;
    return (_fp.*._flags & _IO_EOF_SEEN) != @as(c_int, 0);
}
pub const _IO_ERR_SEEN = @as(c_int, 0x0020);
pub inline fn __ferror_unlocked_body(_fp: anytype) @TypeOf((_fp.*._flags & _IO_ERR_SEEN) != @as(c_int, 0)) {
    _ = &_fp;
    return (_fp.*._flags & _IO_ERR_SEEN) != @as(c_int, 0);
}
pub const _IO_USER_LOCK = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8000, .hex);
pub const __cookie_io_functions_t_defined = @as(c_int, 1);
pub const _VA_LIST_DEFINED = "";
pub const __off_t_defined = "";
pub const __ssize_t_defined = "";
pub const _IOFBF = @as(c_int, 0);
pub const _IOLBF = @as(c_int, 1);
pub const _IONBF = @as(c_int, 2);
pub const BUFSIZ = @as(c_int, 8192);
pub const EOF = -@as(c_int, 1);
pub const SEEK_SET = @as(c_int, 0);
pub const SEEK_CUR = @as(c_int, 1);
pub const SEEK_END = @as(c_int, 2);
pub const P_tmpdir = "/tmp";
pub const L_tmpnam = @as(c_int, 20);
pub const TMP_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 238328, .decimal);
pub const _BITS_STDIO_LIM_H = @as(c_int, 1);
pub const FILENAME_MAX = @as(c_int, 4096);
pub const L_ctermid = @as(c_int, 9);
pub const FOPEN_MAX = @as(c_int, 16);
pub const __attr_dealloc_fclose = __attr_dealloc(fclose, @as(c_int, 1));
pub const _BITS_FLOATN_H = "";
pub const __HAVE_FLOAT128 = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT128 = @as(c_int, 0);
pub const __HAVE_FLOAT64X = @as(c_int, 1);
pub const __HAVE_FLOAT64X_LONG_DOUBLE = @as(c_int, 1);
pub const _BITS_FLOATN_COMMON_H = "";
pub const __HAVE_FLOAT16 = @as(c_int, 0);
pub const __HAVE_FLOAT32 = @as(c_int, 1);
pub const __HAVE_FLOAT64 = @as(c_int, 1);
pub const __HAVE_FLOAT32X = @as(c_int, 1);
pub const __HAVE_FLOAT128X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT16 = __HAVE_FLOAT16;
pub const __HAVE_DISTINCT_FLOAT32 = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT64 = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT32X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT64X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT128X = __HAVE_FLOAT128X;
pub const __HAVE_FLOAT128_UNLIKE_LDBL = (__HAVE_DISTINCT_FLOAT128 != 0) and (__LDBL_MANT_DIG__ != @as(c_int, 113));
pub const __HAVE_FLOATN_NOT_TYPEDEF = @as(c_int, 0);
pub const __f32 = @import("std").zig.c_translation.Macros.F_SUFFIX;
pub inline fn __f64(x: anytype) @TypeOf(x) {
    _ = &x;
    return x;
}
pub inline fn __f32x(x: anytype) @TypeOf(x) {
    _ = &x;
    return x;
}
pub const __f64x = @import("std").zig.c_translation.Macros.L_SUFFIX;
pub const __CFLOAT32 = @compileError("unable to translate: TODO _Complex");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:149:12
pub const __CFLOAT64 = @compileError("unable to translate: TODO _Complex");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:160:13
pub const __CFLOAT32X = @compileError("unable to translate: TODO _Complex");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:169:12
pub const __CFLOAT64X = @compileError("unable to translate: TODO _Complex");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:178:13
pub inline fn __builtin_huge_valf32() @TypeOf(__builtin_huge_valf()) {
    return __builtin_huge_valf();
}
pub inline fn __builtin_inff32() @TypeOf(__builtin_inff()) {
    return __builtin_inff();
}
pub inline fn __builtin_nanf32(x: anytype) @TypeOf(__builtin_nanf(x)) {
    _ = &x;
    return __builtin_nanf(x);
}
pub const __builtin_nansf32 = @compileError("unable to translate macro: undefined identifier `__builtin_nansf`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:221:12
pub const __builtin_huge_valf64 = @compileError("unable to translate macro: undefined identifier `__builtin_huge_val`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:255:13
pub const __builtin_inff64 = @compileError("unable to translate macro: undefined identifier `__builtin_inf`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:256:13
pub const __builtin_nanf64 = @compileError("unable to translate macro: undefined identifier `__builtin_nan`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:257:13
pub const __builtin_nansf64 = @compileError("unable to translate macro: undefined identifier `__builtin_nans`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:258:13
pub const __builtin_huge_valf32x = @compileError("unable to translate macro: undefined identifier `__builtin_huge_val`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:272:12
pub const __builtin_inff32x = @compileError("unable to translate macro: undefined identifier `__builtin_inf`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:273:12
pub const __builtin_nanf32x = @compileError("unable to translate macro: undefined identifier `__builtin_nan`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:274:12
pub const __builtin_nansf32x = @compileError("unable to translate macro: undefined identifier `__builtin_nans`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:275:12
pub const __builtin_huge_valf64x = @compileError("unable to translate macro: undefined identifier `__builtin_huge_vall`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:289:13
pub const __builtin_inff64x = @compileError("unable to translate macro: undefined identifier `__builtin_infl`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:290:13
pub const __builtin_nanf64x = @compileError("unable to translate macro: undefined identifier `__builtin_nanl`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:291:13
pub const __builtin_nansf64x = @compileError("unable to translate macro: undefined identifier `__builtin_nansl`");
// /nix/store/wlavaybjbzgllhq11lib6qgr7rm8imgp-glibc-2.39-52-dev/include/bits/floatn-common.h:292:13
pub const __STDARG_H = "";
pub const __need_va_list = "";
pub const __need_va_arg = "";
pub const __need___va_copy = "";
pub const __need_va_copy = "";
pub const _VA_LIST = "";
pub const va_start = @compileError("unable to translate macro: undefined identifier `__builtin_va_start`");
// /nix/store/vm8x0fdp3gn99adhig5g0z9ri40hrq3w-zig-0.13.0/lib/zig/include/__stdarg_va_arg.h:17:9
pub const va_end = @compileError("unable to translate macro: undefined identifier `__builtin_va_end`");
// /nix/store/vm8x0fdp3gn99adhig5g0z9ri40hrq3w-zig-0.13.0/lib/zig/include/__stdarg_va_arg.h:19:9
pub const va_arg = @compileError("unable to translate C expr: unexpected token 'an identifier'");
// /nix/store/vm8x0fdp3gn99adhig5g0z9ri40hrq3w-zig-0.13.0/lib/zig/include/__stdarg_va_arg.h:20:9
pub const __va_copy = @compileError("unable to translate macro: undefined identifier `__builtin_va_copy`");
// /nix/store/vm8x0fdp3gn99adhig5g0z9ri40hrq3w-zig-0.13.0/lib/zig/include/__stdarg___va_copy.h:11:9
pub const va_copy = @compileError("unable to translate macro: undefined identifier `__builtin_va_copy`");
// /nix/store/vm8x0fdp3gn99adhig5g0z9ri40hrq3w-zig-0.13.0/lib/zig/include/__stdarg_va_copy.h:11:9
pub const _JAVASOFT_JNI_MD_H_ = "";
pub const JNIEXPORT = @compileError("unable to translate macro: undefined identifier `visibility`");
// include-jdk-21/jni_md.h:38:15
pub const JNIIMPORT = @compileError("unable to translate macro: undefined identifier `visibility`");
// include-jdk-21/jni_md.h:49:13
pub const JNICALL = "";
pub const JNI_FALSE = @as(c_int, 0);
pub const JNI_TRUE = @as(c_int, 1);
pub const JNI_OK = @as(c_int, 0);
pub const JNI_ERR = -@as(c_int, 1);
pub const JNI_EDETACHED = -@as(c_int, 2);
pub const JNI_EVERSION = -@as(c_int, 3);
pub const JNI_ENOMEM = -@as(c_int, 4);
pub const JNI_EEXIST = -@as(c_int, 5);
pub const JNI_EINVAL = -@as(c_int, 6);
pub const JNI_COMMIT = @as(c_int, 1);
pub const JNI_ABORT = @as(c_int, 2);
pub const JDK1_2 = "";
pub const JDK1_4 = "";
pub const _JNI_IMPORT_OR_EXPORT_ = JNIIMPORT;
pub const JNI_VERSION_1_1 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010001, .hex);
pub const JNI_VERSION_1_2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010002, .hex);
pub const JNI_VERSION_1_4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010004, .hex);
pub const JNI_VERSION_1_6 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010006, .hex);
pub const JNI_VERSION_1_8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010008, .hex);
pub const JNI_VERSION_9 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00090000, .hex);
pub const JNI_VERSION_10 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x000a0000, .hex);
pub const JNI_VERSION_19 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00130000, .hex);
pub const JNI_VERSION_20 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00140000, .hex);
pub const JNI_VERSION_21 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00150000, .hex);
pub const _G_fpos_t = struct__G_fpos_t;
pub const _G_fpos64_t = struct__G_fpos64_t;
pub const _IO_marker = struct__IO_marker;
pub const _IO_codecvt = struct__IO_codecvt;
pub const _IO_wide_data = struct__IO_wide_data;
pub const _IO_FILE = struct__IO_FILE;
pub const _IO_cookie_io_functions_t = struct__IO_cookie_io_functions_t;
pub const _jobject = struct__jobject;
pub const _jfieldID = struct__jfieldID;
pub const _jmethodID = struct__jmethodID;
pub const _jobjectType = enum__jobjectType;
pub const JNIInvokeInterface_ = struct_JNIInvokeInterface_;
pub const JNINativeInterface_ = struct_JNINativeInterface_;
pub const JNIEnv_ = struct_JNIEnv_;
pub const JavaVM_ = struct_JavaVM_;
