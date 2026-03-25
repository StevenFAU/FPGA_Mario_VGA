PROJECT_NAME = fpga_mario_vga
TOP_MODULE = top_mario_game
CONSTRAINTS = constraints/nexys_a7_100t.xdc

SRCS = \
	src/clk_div.v \
	src/vga_timing.v \
	src/frame_tick.v \
	src/input_sync.v \
	src/scene_layout.v \
	src/game_state.v \
	src/renderer.v \
	src/top_mario_game.v

IVERILOG = iverilog
VVP = vvp

.PHONY: all sim sim_timing sim_game_state sim_top vivado clean

all: sim

sim: sim_timing sim_game_state sim_top

sim_game_state:
	@echo "=== Running game-state movement testbench ==="
	$(IVERILOG) -g2001 -o sim_game_state.out $(SRCS) sim/tb_game_state.v
	$(VVP) sim_game_state.out

sim_timing:
	@echo "=== Running VGA timing testbench ==="
	$(IVERILOG) -g2001 -o sim_timing.out $(SRCS) sim/tb_vga_timing.v
	$(VVP) sim_timing.out

sim_top:
	@echo "=== Running top-level smoke testbench ==="
	$(IVERILOG) -g2001 -o sim_top.out $(SRCS) sim/tb_top_mario_game.v
	$(VVP) sim_top.out

vivado:
	@echo "=== Creating Vivado project ==="
	vivado -mode batch -source create_project.tcl

clean:
	rm -f *.out *.vcd
