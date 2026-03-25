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
    wire       game_won;

    integer errors;
    integer i;
    integer peak_y;
    integer prev_y;
    integer prev_vy;
    integer expected_y;
    integer expected_vy;

    game_state uut (
        .clk(clk),
        .rst_n(rst_n),
        .frame_tick(frame_tick),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .btn_up(btn_up),
        .game_won(game_won),
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

    task seed_state_and_tick;
        input [9:0] seed_x;
        input [9:0] seed_y;
        input signed [10:0] seed_vy;
        input seed_left;
        input seed_right;
        input seed_up;
        begin
            uut.player_x = seed_x;
            uut.player_y = seed_y;
            uut.player_vy = seed_vy;
            btn_left = seed_left;
            btn_right = seed_right;
            btn_up = seed_up;
            pulse_frame_tick;
            btn_left = 1'b0;
            btn_right = 1'b0;
            btn_up = 1'b0;
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

        seed_state_and_tick(10'd612, 10'd200, 11'sd0, 1'b0, 1'b1, 1'b0);

        if (player_x !== 10'd616) begin
            $display("FAIL: right clamp expected x=616, got %0d", player_x);
            errors = errors + 1;
        end

        uut.player_x = 10'd96;
        uut.player_y = 10'd400;
        uut.player_vy = 11'sd0;

        btn_up = 1'b1;
        pulse_frame_tick;
        btn_up = 1'b0;

        if (player_y >= 10'd400) begin
            $display("FAIL: jump should move player upward from the ground, got y=%0d", player_y);
            errors = errors + 1;
        end

        peak_y = player_y;
        for (i = 0; i < 6; i = i + 1) begin
            pulse_frame_tick;
            if (player_y < peak_y) begin
                peak_y = player_y;
            end
        end

        prev_y = player_y;
        prev_vy = uut.player_vy;
        expected_y = prev_y + prev_vy;
        expected_vy = prev_vy + 1;

        btn_up = 1'b1;
        pulse_frame_tick;
        btn_up = 1'b0;

        if (player_y !== expected_y) begin
            $display("FAIL: midair jump changed vertical position unexpectedly, expected %0d got %0d",
                     expected_y, player_y);
            errors = errors + 1;
        end

        if (uut.player_vy !== expected_vy) begin
            $display("FAIL: midair jump changed vertical velocity unexpectedly, expected %0d got %0d",
                     expected_vy, uut.player_vy);
            errors = errors + 1;
        end

        for (i = 0; i < 40; i = i + 1) begin
            pulse_frame_tick;
        end

        if (player_y !== 10'd400) begin
            $display("FAIL: landing expected y=400, got %0d", player_y);
            errors = errors + 1;
        end

        if (uut.player_vy !== 0) begin
            $display("FAIL: vertical velocity should be zero after landing, got %0d", uut.player_vy);
            errors = errors + 1;
        end

        seed_state_and_tick(10'd180, 10'd303, 11'sd10, 1'b0, 1'b0, 1'b0);
        if (player_y !== 10'd312) begin
            $display("FAIL: platform landing expected y=312, got %0d", player_y);
            errors = errors + 1;
        end
        if (uut.player_vy !== 0) begin
            $display("FAIL: platform landing should clear vertical velocity, got %0d", uut.player_vy);
            errors = errors + 1;
        end

        seed_state_and_tick(10'd180, 10'd372, -11'sd8, 1'b0, 1'b0, 1'b0);
        if (player_y !== 10'd368) begin
            $display("FAIL: underside collision expected y=368, got %0d", player_y);
            errors = errors + 1;
        end
        if (uut.player_vy !== 0) begin
            $display("FAIL: underside collision should clear vertical velocity, got %0d", uut.player_vy);
            errors = errors + 1;
        end

        seed_state_and_tick(10'd133, 10'd320, 11'sd0, 1'b0, 1'b1, 1'b0);
        if (player_x !== 10'd136) begin
            $display("FAIL: platform side collision expected x=136, got %0d", player_x);
            errors = errors + 1;
        end

        seed_state_and_tick(10'd284, 10'd312, 11'sd0, 1'b0, 1'b1, 1'b0);
        if (player_y !== 10'd313) begin
            $display("FAIL: stepping off a platform should start falling immediately, got y=%0d", player_y);
            errors = errors + 1;
        end

        if (uut.player_vy !== 1) begin
            $display("FAIL: stepping off a platform should start gravity immediately, got vy=%0d", uut.player_vy);
            errors = errors + 1;
        end

        uut.player_x = 10'd548;
        uut.player_y = 10'd400;
        uut.player_vy = 11'sd0;
        seed_state_and_tick(10'd544, 10'd400, 11'sd0, 1'b0, 1'b1, 1'b0);
        if (game_won !== 1'b1) begin
            $display("FAIL: moving into the goal should set game_won in the same frame");
            errors = errors + 1;
        end

        btn_left = 1'b1;
        pulse_frame_tick;
        btn_left = 1'b0;
        if (player_x !== 10'd548) begin
            $display("FAIL: player should freeze after winning, got x=%0d", player_x);
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
