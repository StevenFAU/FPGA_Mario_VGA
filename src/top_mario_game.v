`timescale 1ns / 1ps

module top_mario_game (
    input  wire       clk_100mhz,
    input  wire       btn_left,
    input  wire       btn_right,
    input  wire       btn_up,
    input  wire       btn_center,
    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b,
    output wire       vga_hsync,
    output wire       vga_vsync
);

    wire rst_n;
    wire clk_25mhz;
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire video_on;
    wire frame_start;
    wire [9:0] player_x;
    wire [9:0] player_y;
    wire [9:0] player_w;
    wire [9:0] player_h;
    wire game_won;
    wire btn_left_sync;
    wire btn_right_sync;
    wire btn_up_sync;

    assign rst_n = ~btn_center;

    clk_div u_clk_div (
        .clk_100mhz(clk_100mhz),
        .rst_n(rst_n),
        .clk_25mhz(clk_25mhz)
    );

    vga_timing u_vga_timing (
        .clk(clk_25mhz),
        .rst_n(rst_n),
        .hsync(vga_hsync),
        .vsync(vga_vsync),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on)
    );

    frame_tick u_frame_tick (
        .clk(clk_25mhz),
        .rst_n(rst_n),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .tick(frame_start)
    );

    input_sync u_sync_left (
        .clk(clk_25mhz),
        .rst_n(rst_n),
        .async_in(btn_left),
        .sync_out(btn_left_sync)
    );

    input_sync u_sync_right (
        .clk(clk_25mhz),
        .rst_n(rst_n),
        .async_in(btn_right),
        .sync_out(btn_right_sync)
    );

    input_sync u_sync_up (
        .clk(clk_25mhz),
        .rst_n(rst_n),
        .async_in(btn_up),
        .sync_out(btn_up_sync)
    );

    game_state u_game_state (
        .clk(clk_25mhz),
        .rst_n(rst_n),
        .frame_tick(frame_start),
        .btn_left(btn_left_sync),
        .btn_right(btn_right_sync),
        .btn_up(btn_up_sync),
        .game_won(game_won),
        .player_x(player_x),
        .player_y(player_y),
        .player_w(player_w),
        .player_h(player_h)
    );

    renderer u_renderer (
        .video_on(video_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .game_won(game_won),
        .player_x(player_x),
        .player_y(player_y),
        .player_w(player_w),
        .player_h(player_h),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b)
    );

endmodule
