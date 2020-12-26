const std = @import("std");
const fs = std.fs;
const ioctl = std.c.ioctl;

const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("linux/i2c-dev.h");
    @cInclude("i2c/smbus.h");
});

const SET_CONTRAST = 0x81;
const DISPLAY_ALL_ON_RESUME = 0xA4;
const DISPLAY_ALL_ON = 0xA5;
const NORMAL_DISPLAY = 0xA6;
const INVERT_DISPLAY = 0xA7;
const DISPLAY_OFF = 0xAE;
const DISPLAY_ON = 0xAF;
const SET_DISPLAY_OFFSET = 0xD3;
const SET_COM_PINS = 0xDA;
const SET_VCOM_DETECT = 0xDB;
const SET_DISPLAY_CLOCKDIV = 0xD5;
const SET_PRECHARGE = 0xD9;
const SET_MULTIPLEX = 0xA8;
const SET_LOW_COLUMN = 0x00;
const SET_HIGH_COLUMN = 0x10;
const SET_START_LINE = 0x40;
const SET_START_PAGE = 0xB0;
const MEMORY_MODE = 0x20;
const COM_SCAN_INC = 0xC0;
const COM_SCAN_DEC = 0xC8;
const SEG_REMAP = 0xA0;
const CHARGE_PUMP = 0x8D;
const EXTERNAL_VCC = 0x1;
const SWITCHCAP_VCC = 0x2;

const screen_width = 128;
const screen_height = 32;
const i2c_addr = 0x3c;
const i2c_device = "/dev/i2c-1";

// https://www.kernel.org/doc/Documentation/i2c/dev-interface

pub fn main() !void {
    var fd = try fs.openFileAbsolute(i2c_device, fs.File.OpenFlags{ .write = true, .read = true });
    defer fd.close();

    return;
}
