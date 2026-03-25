# FPGA Mario VGA

`fpga-mario-vga` is a teaching-oriented FPGA project that grows a simple Mario-style platformer one phase at a time. It starts from the same overall flow as [`StevenFAU/FPGAHelloWorld`](https://github.com/StevenFAU/FPGAHelloWorld): a small Verilog-2001 codebase, a Makefile-driven simulation habit, and a Vivado Tcl script that recreates the project from scratch.

Phase 1 adds the first visible game scene. The project now draws a fixed-screen platformer layout using only colored rectangles: sky, ground, platforms, a player block, and a goal block.

## Project Overview

Goal: build a fixed-screen Mario-like platformer over VGA with simple rectangle graphics first, then extend it gradually toward scrolling, enemies, collectibles, sprite ROMs, animation, and audio.

Current Phase: `Phase 1 - Static game screen`

Current behavior:
- VGA timing pipeline is active.
- A rectangle compositor draws the static scene.
- The player rectangle is visible at a fixed starting position.
- The level is fixed-screen and non-interactive for now.

## Hardware Target

- Board family: Digilent Nexys A7 / Nexys4 DDR
- FPGA part: `xc7a100tcsg324-1`
- Video output: 640x480 VGA at 60 Hz
- Clock input: 100 MHz onboard oscillator

## Toolchain

- Vivado 2025.2 was detected locally for project generation.
- Icarus Verilog (`iverilog` + `vvp`) is used for simulation.
- RTL style target: readable Verilog-2001

## Repo Structure

- `src/` - synthesizable RTL modules
- `sim/` - simulation testbenches
- `constraints/` - board constraints
- `docs/` - per-phase design notes
- `Makefile` - sim and Vivado entry points
- `create_project.tcl` - reproducible Vivado project creation

## Controls

Planned controls for later phases:
- `btn_left` = move left
- `btn_right` = move right
- `btn_up` = jump
- `btn_center` = reset

Phase 0 status:
- Only reset is meaningful today.
- Movement and jumping will arrive in later phases.

## Current Status

Implemented so far:
- clock divider from 100 MHz to 25 MHz VGA pixel clock
- VGA timing generator
- frame tick pulse for once-per-frame game updates
- fixed player state scaffold
- fixed scene layout module for ground, platforms, and goal
- rectangle-based renderer
- top-level integration module for the game project
- simulation checks for VGA timing and representative scene colors
- Vivado Tcl project creation flow

Not implemented yet:
- input handling
- movement
- gravity
- collision
- win/lose logic

## Build Instructions

Create the Vivado project:

```bash
make vivado
```

That generates `vivado_build/fpga_mario_vga.xpr`.

## Simulation Instructions

Run all current simulations:

```bash
make sim
```

Run one testbench:

```bash
make sim_timing
make sim_top
```

The Phase 1 top-level testbench checks representative pixels for:
- sky color
- platform colors
- goal color
- player color
- ground color
- blanking behavior

## Current Screen Layout

The current fixed-screen scene uses simple rectangles only:

- sky background fills the visible area
- ground strip spans the bottom of the screen
- two floating platforms provide future jump targets
- player rectangle starts on the ground near the left side
- goal rectangle sits near the right side

This keeps the initial renderer easy to understand and gives later phases a stable visual target for movement and collision work.

## Rendering Approach

Rendering is intentionally simple:

- `scene_layout.v` defines the fixed world rectangles
- `game_state.v` currently provides the player rectangle
- `renderer.v` composites rectangles in priority order

Current priority order:
- sky
- ground
- platforms
- goal
- player

That separation keeps the video path readable and gives later collision logic a clear place to reuse scene geometry.

## Roadmap / Next Steps

- Phase 2: add synchronized inputs and horizontal movement
- Phase 3: add gravity, jumping, and ground collision
- Phase 4: add platform collision and simple level geometry
- Phase 5: create a minimal playable fixed-screen prototype

## Notes

- Hardware behavior beyond basic synthesis setup is not yet verified on a physical board.
- The button pin assignments for left/right/up were added for the planned control scheme and should be checked against the exact board revision during hardware bring-up.
- The scene is visual only in this phase; controls are not active yet.
- See [`docs/phase-00.md`](docs/phase-00.md) and [`docs/phase-01.md`](docs/phase-01.md) for phase notes.
