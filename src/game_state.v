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
    localparam [9:0] GROUND_TOP_Y   = 10'd432;
    localparam [9:0] GROUND_Y       = GROUND_TOP_Y - PLAYER_HEIGHT;
    localparam [9:0] MOVE_STEP      = 10'd4;
    localparam [9:0] PLAYER_MAX_X   = SCREEN_WIDTH - PLAYER_WIDTH;
    localparam integer GRAVITY_ACCEL = 1;
    localparam integer JUMP_VELOCITY = -12;
    localparam integer MAX_FALL_SPEED = 12;

    reg signed [10:0] player_vy;
    integer next_x;
    integer next_y;
    integer next_vy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            player_x <= PLAYER_START_X;
            player_y <= GROUND_Y;
            player_w <= PLAYER_WIDTH;
            player_h <= PLAYER_HEIGHT;
            player_vy <= 11'sd0;
        end else if (frame_tick) begin
            next_x  = player_x;
            next_y  = player_y;
            next_vy = player_vy;

            if (btn_left && !btn_right) begin
                if (next_x > MOVE_STEP) begin
                    next_x = next_x - MOVE_STEP;
                end else begin
                    next_x = 10'd0;
                end
            end else if (btn_right && !btn_left) begin
                if (next_x < PLAYER_MAX_X - MOVE_STEP) begin
                    next_x = next_x + MOVE_STEP;
                end else begin
                    next_x = PLAYER_MAX_X;
                end
            end

            if (next_y >= GROUND_Y) begin
                next_y = GROUND_Y;
                next_vy = 0;

                if (btn_up) begin
                    next_vy = JUMP_VELOCITY;
                    next_y = GROUND_Y + JUMP_VELOCITY;
                end
            end else begin
                next_y = next_y + next_vy;
                next_vy = next_vy + GRAVITY_ACCEL;

                if (next_vy > MAX_FALL_SPEED) begin
                    next_vy = MAX_FALL_SPEED;
                end

                if (next_y >= GROUND_Y) begin
                    next_y = GROUND_Y;
                    next_vy = 0;
                end
            end

            player_x <= next_x[9:0];
            player_y <= next_y[9:0];
            player_w <= player_w;
            player_h <= player_h;
            player_vy <= next_vy[10:0];
        end
    end

endmodule
