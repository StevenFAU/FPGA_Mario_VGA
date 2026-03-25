`timescale 1ns / 1ps

module input_sync (
    input  wire clk,
    input  wire rst_n,
    input  wire async_in,
    output reg  sync_out
);

    reg sync_stage0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_stage0 <= 1'b0;
            sync_out    <= 1'b0;
        end else begin
            sync_stage0 <= async_in;
            sync_out    <= sync_stage0;
        end
    end

endmodule

