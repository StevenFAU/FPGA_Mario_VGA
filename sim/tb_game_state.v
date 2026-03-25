`timescale 1ns / 1ps

module tb_game_state;

    reg        clk;
    reg        rst_n;
    reg        frame_tick;
    reg        btn_left;
    reg        btn_right;
    reg        btn_up;
    wire [9:0] player_x;
    wire [9:0] player_y;
    wire [9:0] player_w;
    wire [9:0] player_h;

    integer errors;
    integer i;

    game_state uut (
        .clk(clk),
        .rst_n(rst_n),
        .frame_tick(frame_tick),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .btn_up(btn_up),
        .player_x(player_x),
        .player_y(player_y),
        .player_w(player_w),
        .player_h(player_h)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task pulse_frame_tick;
        begin
            @(posedge clk);
            frame_tick = 1'b1;
            @(posedge clk);
            frame_tick = 1'b0;
        end
    endtask

    initial begin
        $dumpfile("game_state.vcd");
        $dumpvars(0, tb_game_state);

        errors = 0;
        rst_n = 1'b0;
        frame_tick = 1'b0;
        btn_left = 1'b0;
        btn_right = 1'b0;
        btn_up = 1'b0;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);

        if (player_x !== 10'd96) begin
            $display("FAIL: reset player_x expected 96, got %0d", player_x);
            errors = errors + 1;
        end

        if (player_y !== 10'd400) begin
            $display("FAIL: reset player_y expected 400, got %0d", player_y);
            errors = errors + 1;
        end

        btn_right = 1'b1;
        pulse_frame_tick;
        pulse_frame_tick;
        pulse_frame_tick;
        btn_right = 1'b0;

        if (player_x !== 10'd108) begin
            $display("FAIL: right movement expected x=108, got %0d", player_x);
            errors = errors + 1;
        end

        btn_left = 1'b1;
        pulse_frame_tick;
        pulse_frame_tick;
        btn_left = 1'b0;

        if (player_x !== 10'd100) begin
            $display("FAIL: left movement expected x=100, got %0d", player_x);
            errors = errors + 1;
        end

        btn_left = 1'b1;
        btn_right = 1'b1;
        pulse_frame_tick;
        btn_left = 1'b0;
        btn_right = 1'b0;

        if (player_x !== 10'd100) begin
            $display("FAIL: opposing inputs should cancel, got %0d", player_x);
            errors = errors + 1;
        end

        btn_left = 1'b1;
        for (i = 0; i < 40; i = i + 1) begin
            pulse_frame_tick;
        end
        btn_left = 1'b0;

        if (player_x !== 10'd0) begin
            $display("FAIL: left clamp expected x=0, got %0d", player_x);
            errors = errors + 1;
        end

        btn_right = 1'b1;
        for (i = 0; i < 200; i = i + 1) begin
            pulse_frame_tick;
        end
        btn_right = 1'b0;

        if (player_x !== 10'd616) begin
            $display("FAIL: right clamp expected x=616, got %0d", player_x);
            errors = errors + 1;
        end

        if (player_w !== 10'd24 || player_h !== 10'd32) begin
            $display("FAIL: player dimensions changed unexpectedly");
            errors = errors + 1;
        end

        if (errors == 0) begin
            $display("PASS: tb_game_state");
        end else begin
            $display("FAIL: tb_game_state had %0d error(s)", errors);
        end

        $finish;
    end

endmodule

