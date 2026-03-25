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

    task expect_color;
        input [9:0] sample_x;
        input [9:0] sample_y;
        input [3:0] expected_r;
        input [3:0] expected_g;
        input [3:0] expected_b;
        input [255:0] label;
        begin
            wait (uut.pixel_x == sample_x && uut.pixel_y == sample_y);
            #1;
            if ((vga_r !== expected_r) || (vga_g !== expected_g) || (vga_b !== expected_b)) begin
                $display("FAIL: %0s at (%0d,%0d) expected RGB=%0h%0h%0h got %0h%0h%0h",
                         label, sample_x, sample_y, expected_r, expected_g, expected_b,
                         vga_r, vga_g, vga_b);
                errors = errors + 1;
            end
        end
    endtask

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

        wait (uut.video_on == 1'b1);
        expect_color(10'd40,  10'd40,  4'h6, 4'hB, 4'hF, "sky");
        expect_color(10'd200, 10'd350, 4'h2, 4'hA, 4'h2, "platform 0");
        expect_color(10'd380, 10'd290, 4'h2, 4'hA, 4'h2, "platform 1");
        expect_color(10'd570, 10'd390, 4'hF, 4'hE, 4'h2, "goal");
        expect_color(10'd100, 10'd410, 4'hF, 4'h3, 4'h3, "player");
        expect_color(10'd300, 10'd440, 4'h8, 4'h4, 4'h1, "ground");

        btn_right = 1'b1;
        repeat (900000) @(posedge clk_100mhz);
        btn_right = 1'b0;

        if (uut.u_game_state.player_x <= 10'd96) begin
            $display("FAIL: player_x did not move right");
            errors = errors + 1;
        end

        expect_color(uut.u_game_state.player_x + 10'd4, 10'd410, 4'hF, 4'h3, 4'h3, "moved player");

        btn_up = 1'b1;
        repeat (900000) @(posedge clk_100mhz);
        btn_up = 1'b0;

        if (uut.u_game_state.player_y >= 10'd400) begin
            $display("FAIL: player_y did not leave the ground during jump");
            errors = errors + 1;
        end

        uut.u_game_state.player_x = 10'd548;
        uut.u_game_state.player_y = 10'd400;
        uut.u_game_state.player_vy = 11'sd0;
        wait (uut.u_game_state.game_won == 1'b1);
        expect_color(10'd40,  10'd40,  4'hB, 4'hE, 4'h8, "win sky");
        expect_color(10'd570, 10'd390, 4'h2, 4'hF, 4'h4, "win goal");

        wait (uut.pixel_x == 10'd700);
        #1;
        if ((vga_r !== 4'h0) || (vga_g !== 4'h0) || (vga_b !== 4'h0)) begin
            $display("FAIL: blanking region should be black");
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
