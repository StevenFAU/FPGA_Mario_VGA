`timescale 1ns / 1ps

module scene_layout (
    output wire [9:0] ground_x,
    output wire [9:0] ground_y,
    output wire [9:0] ground_w,
    output wire [9:0] ground_h,
    output wire [9:0] platform0_x,
    output wire [9:0] platform0_y,
    output wire [9:0] platform0_w,
    output wire [9:0] platform0_h,
    output wire [9:0] platform1_x,
    output wire [9:0] platform1_y,
    output wire [9:0] platform1_w,
    output wire [9:0] platform1_h,
    output wire [9:0] goal_x,
    output wire [9:0] goal_y,
    output wire [9:0] goal_w,
    output wire [9:0] goal_h
);

    assign ground_x    = 10'd0;
    assign ground_y    = 10'd432;
    assign ground_w    = 10'd640;
    assign ground_h    = 10'd48;

    assign platform0_x = 10'd160;
    assign platform0_y = 10'd344;
    assign platform0_w = 10'd128;
    assign platform0_h = 10'd24;

    assign platform1_x = 10'd352;
    assign platform1_y = 10'd280;
    assign platform1_w = 10'd112;
    assign platform1_h = 10'd24;

    assign goal_x      = 10'd560;
    assign goal_y      = 10'd376;
    assign goal_w      = 10'd28;
    assign goal_h      = 10'd56;

endmodule

