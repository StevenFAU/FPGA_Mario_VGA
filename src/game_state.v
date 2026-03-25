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

    localparam [9:0] PLAYER_START_X = 10'd96;
    localparam [9:0] PLAYER_START_Y = 10'd400;
    localparam [9:0] PLAYER_WIDTH   = 10'd24;
    localparam [9:0] PLAYER_HEIGHT  = 10'd32;
    localparam [9:0] SCREEN_WIDTH   = 10'd640;
    localparam [9:0] MOVE_STEP      = 10'd4;
    localparam [9:0] PLAYER_MAX_X   = SCREEN_WIDTH - PLAYER_WIDTH;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            player_x <= PLAYER_START_X;
            player_y <= PLAYER_START_Y;
            player_w <= PLAYER_WIDTH;
            player_h <= PLAYER_HEIGHT;
        end else if (frame_tick) begin
            if (btn_left && !btn_right) begin
                if (player_x > MOVE_STEP) begin
                    player_x <= player_x - MOVE_STEP;
                end else begin
                    player_x <= 10'd0;
                end
            end else if (btn_right && !btn_left) begin
                if (player_x < PLAYER_MAX_X - MOVE_STEP) begin
                    player_x <= player_x + MOVE_STEP;
                end else begin
                    player_x <= PLAYER_MAX_X;
                end
            end else begin
                player_x <= player_x;
            end

            player_y <= player_y;
            player_w <= player_w;
            player_h <= player_h;
        end
    end

endmodule
