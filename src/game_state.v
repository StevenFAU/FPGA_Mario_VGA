`timescale 1ns / 1ps

module game_state (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       frame_tick,
    input  wire       btn_left,
    input  wire       btn_right,
    input  wire       btn_up,
    output reg  [9:0] player_x,
    output reg  [9:0] player_y,
    output reg  [9:0] player_w,
    output reg  [9:0] player_h
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            player_x <= 10'd96;
            player_y <= 10'd368;
            player_w <= 10'd24;
            player_h <= 10'd32;
        end else if (frame_tick) begin
            player_x <= player_x;
            player_y <= player_y;
            player_w <= player_w;
            player_h <= player_h;
        end
    end

endmodule

