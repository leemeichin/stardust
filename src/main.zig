const std = @import("std");

const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("i2c.h");
});

const SET_CONTRAST = 0x81;
const SET_ENTIRE_ON = 0xA4;
const SET_NORM_INV = 0xA6;
const SET_DISP = 0xAE;
const SET_MEM_ADDR = 0x20;
const SET_COL_ADDR = 0x21;
const SET_PAGE_ADDR = 0x22;
const SET_DISP_START_LINE = 0x40;
const SET_SEG_REMAP = 0xA0;
const SET_MUX_RATIO = 0xA8;
const SET_COM_OUT_DIR = 0xC0;
const SET_DISP_OFFSET = 0xD3;
const SET_COM_PIN_CFG = 0xDA;
const SET_DISP_CLK_DIV = 0xD5;
const SET_PRECHARGE = 0xD9;
const SET_VCOM_DESEL = 0xDB;
const SET_CHARGE_PUMP = 0x8D;

const Device = struct {
    w: i8,
    h: i8,
    i2c: c.I2CDevice,

    pub fn init(w: i8, h: i8, buf: [*]const u8) Device {
        return Device{
            .w = w,
            .h = h,
            .i2c = c.I2CDevice{
                .bus = c.i2c_open(buf),
                .addr = 0x3C,
                .iaddr_bytes = 1,
                .page_bytes = 16,
            },
        };
    }

    pub fn power_off(self: Device) void {
        self.fill(0);
        self.refresh();

        c.i2c_close(self.i2c);
    }

    pub fn write(self: Device, cmd: i8) void {}
};

pub fn main() anyerror!void {
    const d = Device.init(123, 48, "/dev/null");
    std.debug.warn("All your codebase are belong to us.\n", .{});
}
