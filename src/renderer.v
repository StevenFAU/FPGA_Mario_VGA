`timescale 1ns / 1ps

module renderer (
    input  wire       video_on,
    input  wire [9:0] pixel_x,
    input  wire [9:0] pixel_y,
    input  wire [9:0] player_x,
    input  wire [9:0] player_y,
    input  wire [9:0] player_w,
    input  wire [9:0] player_h,
    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b
);

    wire unused_player_region;
    assign unused_player_region =
        (pixel_x >= player_x) &&
        (pixel_x <  player_x + player_w) &&
        (pixel_y >= player_y) &&
        (pixel_y <  player_y + player_h);

    assign vga_r = video_on ? 4'h0 : 4'h0;
    assign vga_g = video_on ? 4'h0 : 4'h0;
    assign vga_b = video_on ? 4'h0 : 4'h0;

endmodule

