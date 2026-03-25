`timescale 1ns / 1ps

module frame_tick (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [9:0] pixel_x,
    input  wire [9:0] pixel_y,
    output reg        tick
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tick <= 1'b0;
        end else begin
            tick <= (pixel_x == 10'd0) && (pixel_y == 10'd0);
        end
    end

endmodule

