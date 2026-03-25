`timescale 1ns / 1ps

module tb_top_mario_game;

    reg        clk_100mhz;
    reg        btn_left;
    reg        btn_right;
    reg        btn_up;
    reg        btn_center;
    wire [3:0] vga_r;
    wire [3:0] vga_g;
    wire [3:0] vga_b;
    wire       vga_hsync;
    wire       vga_vsync;

    integer errors;

    top_mario_game uut (
        .clk_100mhz(clk_100mhz),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .btn_up(btn_up),
        .btn_center(btn_center),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync)
    );

    initial clk_100mhz = 1'b0;
    always #5 clk_100mhz = ~clk_100mhz;

    initial begin
        $dumpfile("top_mario_game.vcd");
        $dumpvars(0, tb_top_mario_game);

        errors = 0;
        btn_left = 1'b0;
        btn_right = 1'b0;
        btn_up = 1'b0;
        btn_center = 1'b1;

        #100;
        btn_center = 1'b0;

        repeat (2000) @(posedge clk_100mhz);

        if ((vga_r !== 4'h0) || (vga_g !== 4'h0) || (vga_b !== 4'h0)) begin
            $display("FAIL: Phase 0 renderer should currently output a black frame");
            errors = errors + 1;
        end

        if ((vga_hsync !== 1'b0) && (vga_hsync !== 1'b1)) begin
            $display("FAIL: hsync is unknown");
            errors = errors + 1;
        end

        if ((vga_vsync !== 1'b0) && (vga_vsync !== 1'b1)) begin
            $display("FAIL: vsync is unknown");
            errors = errors + 1;
        end

        if (errors == 0) begin
            $display("PASS: tb_top_mario_game");
        end else begin
            $display("FAIL: tb_top_mario_game had %0d error(s)", errors);
        end

        $finish;
    end

endmodule

