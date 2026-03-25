`timescale 1ns / 1ps

module renderer (
    input  wire       video_on,
    input  wire [9:0] pixel_x,
    input  wire [9:0] pixel_y,
    input  wire       game_won,
    input  wire [9:0] player_x,
    input  wire [9:0] player_y,
    input  wire [9:0] player_w,
    input  wire [9:0] player_h,
    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b
);

    localparam [3:0] SKY_R      = 4'h6;
    localparam [3:0] SKY_G      = 4'hB;
    localparam [3:0] SKY_B      = 4'hF;
    localparam [3:0] GROUND_R   = 4'h8;
    localparam [3:0] GROUND_G   = 4'h4;
    localparam [3:0] GROUND_B   = 4'h1;
    localparam [3:0] PLATFORM_R = 4'h2;
    localparam [3:0] PLATFORM_G = 4'hA;
    localparam [3:0] PLATFORM_B = 4'h2;
    localparam [3:0] PLAYER_R   = 4'hF;
    localparam [3:0] PLAYER_G   = 4'h3;
    localparam [3:0] PLAYER_B   = 4'h3;
    localparam [3:0] GOAL_R     = 4'hF;
    localparam [3:0] GOAL_G     = 4'hE;
    localparam [3:0] GOAL_B     = 4'h2;
    localparam [3:0] WIN_SKY_R  = 4'hB;
    localparam [3:0] WIN_SKY_G  = 4'hE;
    localparam [3:0] WIN_SKY_B  = 4'h8;
    localparam [3:0] WIN_GOAL_R = 4'h2;
    localparam [3:0] WIN_GOAL_G = 4'hF;
    localparam [3:0] WIN_GOAL_B = 4'h4;
    localparam [3:0] WIN_PLAYER_R = 4'hF;
    localparam [3:0] WIN_PLAYER_G = 4'hF;
    localparam [3:0] WIN_PLAYER_B = 4'hF;

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
    reg  [3:0] red_reg;
    reg  [3:0] green_reg;
    reg  [3:0] blue_reg;

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

    wire player_region;
    wire ground_region;
    wire platform0_region;
    wire platform1_region;
    wire goal_region;

    assign player_region =
        (pixel_x >= player_x) &&
        (pixel_x <  player_x + player_w) &&
        (pixel_y >= player_y) &&
        (pixel_y <  player_y + player_h);

    assign ground_region =
        (pixel_x >= ground_x) &&
        (pixel_x <  ground_x + ground_w) &&
        (pixel_y >= ground_y) &&
        (pixel_y <  ground_y + ground_h);

    assign platform0_region =
        (pixel_x >= platform0_x) &&
        (pixel_x <  platform0_x + platform0_w) &&
        (pixel_y >= platform0_y) &&
        (pixel_y <  platform0_y + platform0_h);

    assign platform1_region =
        (pixel_x >= platform1_x) &&
        (pixel_x <  platform1_x + platform1_w) &&
        (pixel_y >= platform1_y) &&
        (pixel_y <  platform1_y + platform1_h);

    assign goal_region =
        (pixel_x >= goal_x) &&
        (pixel_x <  goal_x + goal_w) &&
        (pixel_y >= goal_y) &&
        (pixel_y <  goal_y + goal_h);

    always @(*) begin
        red_reg   = 4'h0;
        green_reg = 4'h0;
        blue_reg  = 4'h0;

        if (video_on) begin
            if (game_won) begin
                red_reg   = WIN_SKY_R;
                green_reg = WIN_SKY_G;
                blue_reg  = WIN_SKY_B;
            end else begin
                red_reg   = SKY_R;
                green_reg = SKY_G;
                blue_reg  = SKY_B;
            end

            if (ground_region) begin
                red_reg   = GROUND_R;
                green_reg = GROUND_G;
                blue_reg  = GROUND_B;
            end

            if (platform0_region || platform1_region) begin
                red_reg   = PLATFORM_R;
                green_reg = PLATFORM_G;
                blue_reg  = PLATFORM_B;
            end

            if (goal_region) begin
                if (game_won) begin
                    red_reg   = WIN_GOAL_R;
                    green_reg = WIN_GOAL_G;
                    blue_reg  = WIN_GOAL_B;
                end else begin
                    red_reg   = GOAL_R;
                    green_reg = GOAL_G;
                    blue_reg  = GOAL_B;
                end
            end

            if (player_region) begin
                if (game_won) begin
                    red_reg   = WIN_PLAYER_R;
                    green_reg = WIN_PLAYER_G;
                    blue_reg  = WIN_PLAYER_B;
                end else begin
                    red_reg   = PLAYER_R;
                    green_reg = PLAYER_G;
                    blue_reg  = PLAYER_B;
                end
            end
        end
    end

    assign vga_r = red_reg;
    assign vga_g = green_reg;
    assign vga_b = blue_reg;

endmodule
