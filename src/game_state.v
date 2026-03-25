`timescale 1ns / 1ps

module game_state (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       frame_tick,
    input  wire       btn_left,
    input  wire       btn_right,
    input  wire       btn_up,
    output reg        game_won,
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
    localparam integer GRAVITY_ACCEL = 1;
    localparam integer JUMP_VELOCITY = -12;
    localparam integer MAX_FALL_SPEED = 12;

    wire [9:0] ground_x;
    wire [9:0] ground_y;
    wire [9:0] ground_w;
    wire [9:0] ground_h;
    wire [9:0] platform0_x;
    wire [9:0] platform0_y;
    wire [9:0] platform0_w;
    wire [9:0] platform0_h;
    wire [9:0] platform1_x;
    wire [9:0] platform1_y;
    wire [9:0] platform1_w;
    wire [9:0] platform1_h;
    wire [9:0] goal_x;
    wire [9:0] goal_y;
    wire [9:0] goal_w;
    wire [9:0] goal_h;

    reg signed [10:0] player_vy;
    integer next_x;
    integer next_y;
    integer next_vy;
    integer player_right_now;
    integer player_bottom_now;
    integer player_right_next;
    integer player_bottom_next;
    integer player_bottom_final;
    integer ground_player_y;
    reg standing_on_ground;
    reg standing_on_platform0;
    reg standing_on_platform1;
    reg grounded_now;
    reg goal_reached;
    reg next_standing_on_platform0;
    reg next_standing_on_platform1;
    reg next_grounded_after_move;
    reg goal_reached_next;

    scene_layout u_scene_layout (
        .ground_x(ground_x),
        .ground_y(ground_y),
        .ground_w(ground_w),
        .ground_h(ground_h),
        .platform0_x(platform0_x),
        .platform0_y(platform0_y),
        .platform0_w(platform0_w),
        .platform0_h(platform0_h),
        .platform1_x(platform1_x),
        .platform1_y(platform1_y),
        .platform1_w(platform1_w),
        .platform1_h(platform1_h),
        .goal_x(goal_x),
        .goal_y(goal_y),
        .goal_w(goal_w),
        .goal_h(goal_h)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            game_won <= 1'b0;
            player_x <= PLAYER_START_X;
            player_y <= PLAYER_START_Y;
            player_w <= PLAYER_WIDTH;
            player_h <= PLAYER_HEIGHT;
            player_vy <= 11'sd0;
        end else if (frame_tick) begin
            ground_player_y = ground_y - PLAYER_HEIGHT;
            next_x  = player_x;
            next_y  = player_y;
            next_vy = player_vy;
            player_right_now = player_x + PLAYER_WIDTH;
            player_bottom_now = player_y + PLAYER_HEIGHT;

            standing_on_ground =
                (player_y == ground_player_y);

            standing_on_platform0 =
                (player_y == (platform0_y - PLAYER_HEIGHT)) &&
                (player_x < platform0_x + platform0_w) &&
                (player_right_now > platform0_x);

            standing_on_platform1 =
                (player_y == (platform1_y - PLAYER_HEIGHT)) &&
                (player_x < platform1_x + platform1_w) &&
                (player_right_now > platform1_x);

            grounded_now =
                standing_on_ground ||
                standing_on_platform0 ||
                standing_on_platform1;

            goal_reached =
                (player_x < goal_x + goal_w) &&
                (player_x + PLAYER_WIDTH > goal_x) &&
                (player_y < goal_y + goal_h) &&
                (player_y + PLAYER_HEIGHT > goal_y);

            if (game_won) begin
                game_won <= 1'b1;
                player_x <= player_x;
                player_y <= player_y;
                player_w <= player_w;
                player_h <= player_h;
                player_vy <= 11'sd0;
            end else begin

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

                if ((player_y < platform0_y + platform0_h) &&
                    (player_bottom_now > platform0_y)) begin
                    if ((player_right_now <= platform0_x) &&
                        (next_x + PLAYER_WIDTH > platform0_x)) begin
                        next_x = platform0_x - PLAYER_WIDTH;
                    end

                    if ((player_x >= platform0_x + platform0_w) &&
                        (next_x < platform0_x + platform0_w)) begin
                        next_x = platform0_x + platform0_w;
                    end
                end

                if ((player_y < platform1_y + platform1_h) &&
                    (player_bottom_now > platform1_y)) begin
                    if ((player_right_now <= platform1_x) &&
                        (next_x + PLAYER_WIDTH > platform1_x)) begin
                        next_x = platform1_x - PLAYER_WIDTH;
                    end

                    if ((player_x >= platform1_x + platform1_w) &&
                        (next_x < platform1_x + platform1_w)) begin
                        next_x = platform1_x + platform1_w;
                    end
                end

                player_right_next = next_x + PLAYER_WIDTH;

                next_standing_on_platform0 =
                    (player_y == (platform0_y - PLAYER_HEIGHT)) &&
                    (next_x < platform0_x + platform0_w) &&
                    (player_right_next > platform0_x);

                next_standing_on_platform1 =
                    (player_y == (platform1_y - PLAYER_HEIGHT)) &&
                    (next_x < platform1_x + platform1_w) &&
                    (player_right_next > platform1_x);

                next_grounded_after_move =
                    standing_on_ground ||
                    next_standing_on_platform0 ||
                    next_standing_on_platform1;

                if (next_grounded_after_move && btn_up) begin
                    next_vy = JUMP_VELOCITY;
                    next_y = player_y + JUMP_VELOCITY;
                end else begin
                    if (grounded_now && !next_grounded_after_move && (next_vy == 0)) begin
                        next_vy = GRAVITY_ACCEL;
                        next_y = next_y + GRAVITY_ACCEL;
                    end else begin
                        next_y = next_y + next_vy;

                        if (!next_grounded_after_move || (next_vy != 0)) begin
                            next_vy = next_vy + GRAVITY_ACCEL;
                        end else begin
                            next_vy = 0;
                        end
                    end

                    if (next_vy > MAX_FALL_SPEED) begin
                        next_vy = MAX_FALL_SPEED;
                    end
                end

                player_bottom_next = next_y + PLAYER_HEIGHT;

                if ((player_bottom_now <= platform0_y) &&
                    (player_bottom_next >= platform0_y) &&
                    (next_vy >= 0) &&
                    (next_x < platform0_x + platform0_w) &&
                    (player_right_next > platform0_x)) begin
                    next_y = platform0_y - PLAYER_HEIGHT;
                    next_vy = 0;
                end else if ((player_y >= platform0_y + platform0_h) &&
                             (next_y < platform0_y + platform0_h) &&
                             (player_x < platform0_x + platform0_w) &&
                             (player_right_next > platform0_x)) begin
                    next_y = platform0_y + platform0_h;
                    next_vy = 0;
                end

                player_bottom_next = next_y + PLAYER_HEIGHT;

                if ((player_bottom_now <= platform1_y) &&
                    (player_bottom_next >= platform1_y) &&
                    (next_vy >= 0) &&
                    (next_x < platform1_x + platform1_w) &&
                    (player_right_next > platform1_x)) begin
                    next_y = platform1_y - PLAYER_HEIGHT;
                    next_vy = 0;
                end else if ((player_y >= platform1_y + platform1_h) &&
                             (next_y < platform1_y + platform1_h) &&
                             (player_x < platform1_x + platform1_w) &&
                             (player_right_next > platform1_x)) begin
                    next_y = platform1_y + platform1_h;
                    next_vy = 0;
                end

                if (next_y >= ground_player_y) begin
                    next_y = ground_player_y;
                    next_vy = 0;
                end

                player_bottom_final = next_y + PLAYER_HEIGHT;
                goal_reached_next =
                    (next_x < goal_x + goal_w) &&
                    (player_right_next > goal_x) &&
                    (next_y < goal_y + goal_h) &&
                    (player_bottom_final > goal_y);

                if (goal_reached || goal_reached_next) begin
                    game_won <= 1'b1;
                    player_x <= next_x[9:0];
                    player_y <= next_y[9:0];
                    player_w <= player_w;
                    player_h <= player_h;
                    player_vy <= 11'sd0;
                end else begin
                    game_won <= 1'b0;
                    player_x <= next_x[9:0];
                    player_y <= next_y[9:0];
                    player_w <= player_w;
                    player_h <= player_h;
                    player_vy <= next_vy[10:0];
                end
            end
        end
    end

endmodule
