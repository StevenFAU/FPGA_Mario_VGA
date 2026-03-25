`timescale 1ns / 1ps

module tb_vga_timing;

    reg        clk;
    reg        rst_n;
    wire       hsync;
    wire       vsync;
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire       video_on;

    integer errors;
    integer h_total_count;
    integer hsync_low_count;
    integer frame_clocks;

    vga_timing uut (
        .clk(clk),
        .rst_n(rst_n),
        .hsync(hsync),
        .vsync(vsync),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on)
    );

    initial clk = 1'b0;
    always #20 clk = ~clk;

    initial begin
        $dumpfile("vga_timing.vcd");
        $dumpvars(0, tb_vga_timing);

        errors = 0;
        rst_n = 1'b0;
        #100;
        rst_n = 1'b1;

        @(posedge clk);
        wait (pixel_x == 10'd0);
        repeat (1) @(posedge clk);
        h_total_count = 1;
        while (pixel_x != 10'd0) begin
            @(posedge clk);
            h_total_count = h_total_count + 1;
        end

        if (h_total_count != 800) begin
            $display("FAIL: horizontal total was %0d, expected 800", h_total_count);
            errors = errors + 1;
        end

        wait (hsync == 1'b1);
        @(negedge hsync);
        hsync_low_count = 0;
        while (hsync == 1'b0) begin
            @(posedge clk);
            #1;
            hsync_low_count = hsync_low_count + 1;
        end

        if (hsync_low_count != 96) begin
            $display("FAIL: hsync pulse width was %0d, expected 96", hsync_low_count);
            errors = errors + 1;
        end

        wait (pixel_y == 10'd0 && pixel_x == 10'd0);
        @(posedge clk);
        frame_clocks = 0;
        while (!(pixel_y == 10'd0 && pixel_x == 10'd0) || frame_clocks == 0) begin
            @(posedge clk);
            frame_clocks = frame_clocks + 1;
        end

        if (frame_clocks != 420000) begin
            $display("FAIL: frame clock count was %0d, expected 420000", frame_clocks);
            errors = errors + 1;
        end

        wait (pixel_x == 10'd320 && pixel_y == 10'd240);
        if (video_on != 1'b1) begin
            $display("FAIL: video_on should be high inside the visible region");
            errors = errors + 1;
        end

        wait (pixel_x == 10'd700);
        if (video_on != 1'b0) begin
            $display("FAIL: video_on should be low during horizontal blanking");
            errors = errors + 1;
        end

        if (errors == 0) begin
            $display("PASS: tb_vga_timing");
        end else begin
            $display("FAIL: tb_vga_timing had %0d error(s)", errors);
        end

        $finish;
    end

endmodule

