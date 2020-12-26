const std = @import("std");
const fs = std.fs;

const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
  //  @cInclude("linux/ioctl.h");
    @cInclude("linux/i2c-dev.h");
   // @cInclude("i2c/smbus.h");
});

const SET_CONTRAST = 0x81;
const SET_DISPLAY_ALL_ON_RESUME = 0xA4;
const SET_DISPLAY_ALL_ON = 0xA5;
const SET_NORMAL_DISPLAY = 0xA6;
const SET_INVERT_DISPLAY = 0xA7;
const SET_DISPLAY_OFF = 0xAE;
const SET_DISPLAY_ON = 0xAF;
const SET_DISPLAY_OFFSET = 0xD3;
const SET_COM_PINS = 0xDA;
const SET_VCOM_DETECT = 0xDB;
const SET_DISPLAY_CLOCK_FREQ = 0xD5;
const SET_PRECHARGE = 0xD9;
const SET_MULTIPLEX_RATIO = 0xA8;
const SET_LOW_COLUMN = 0x00;
const SET_HIGH_COLUMN = 0x10;
const SET_START_LINE = 0x40;
const SET_START_PAGE = 0xB0;
const SET_MEMORY_MODE = 0x20;
const SET_COM_SCAN_INC = 0xC0;
const SET_COM_SCAN_DEC = 0xC8;
const SET_SEG_REMAP = 0xA0;
const SET_CHARGE_PUMP = 0x8D;

const screen_width = 128;
const screen_height = 32;
const i2c_addr = 0x3c;
const i2c_device = "/dev/i2c-1";

// https://www.kernel.org/doc/Documentation/i2c/dev-interface

fn init_display(fd: fs.File) !void {
    const cmds = [_]u8 {
        SET_MULTIPLEX_RATIO, 0x3F, 0x00,
        SET_START_LINE,
        SET_SEG_REMAP,
        SET_COM_SCAN_DEC,
        SET_COM_PINS, 0x32,
        SET_DISPLAY_ALL_ON_RESUME,
        SET_NORMAL_DISPLAY,
        SET_DISPLAY_CLOCK_FREQ, 0x80,
        SET_CHARGE_PUMP, 0x14,
        SET_MEMORY_MODE, 0x20,
    };

    inline for (cmds) |cmd| {
       _ = try fd.write(&[3]u8 { i2c_addr, 0x00, cmd });
    }

}

fn display_on(fd: fs.File) !void {
    _ = try fd.write(&[3]u8{ i2c_addr, 0x00, 0xAF });
}

fn fill(fd: fs.File) !void {
    var i: usize = 0;
    
    while (i < 1024) {
        _ = try fd.write(&[3]u8{ i2c_addr, 0x40, 0xff });
        i += 1;
    }
    
    
}

pub fn main() !void {
    const stdout = std.io.getStdOut().outStream();
    const fd = try fs.openFileAbsolute(i2c_device, fs.File.OpenFlags{ .write = true, .read = true });
    defer fd.close();

    // if (c.ioctl(fd, c.I2C_SLAVE, i2c_addr) < 0) {
    //     print("ioctl fail");
    //     exit();
    // }

    try stdout.print("init", .{});
    try init_display(fd);

    try stdout.print("turn on", .{});
    try display_on(fd);

    try stdout.print("fill", .{});
    try fill(fd);
}
