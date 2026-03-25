# FPGA Mario VGA

`fpga-mario-vga` is a teaching-oriented FPGA project that grows a simple Mario-style platformer one phase at a time. It starts from the same overall flow as [`StevenFAU/FPGAHelloWorld`](https://github.com/StevenFAU/FPGAHelloWorld): a small Verilog-2001 codebase, a Makefile-driven simulation habit, and a Vivado Tcl script that recreates the project from scratch.

Phase 0 focuses on the foundation. The repo now contains a clean game-oriented scaffold, a working VGA pipeline, a placeholder game state module, Icarus Verilog smoke tests, and a reproducible Vivado project setup for the Nexys A7-100T.

## Project Overview

Goal: build a fixed-screen Mario-like platformer over VGA with simple rectangle graphics first, then extend it gradually toward scrolling, enemies, collectibles, sprite ROMs, animation, and audio.

Current Phase: `Phase 0 - Scaffold from source repo`

Current behavior:
- VGA timing pipeline is present.
- Top-level game module is present.
- Renderer currently outputs a black active frame as a placeholder.
- Player state outputs are scaffolded but not yet rendered or controlled.

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

Implemented in Phase 0:
- clock divider from 100 MHz to 25 MHz VGA pixel clock
- VGA timing generator
- frame tick pulse for once-per-frame game updates
- placeholder `game_state` module
- placeholder `renderer` module
- top-level integration module for the game project
- simulation smoke tests
- Vivado Tcl project creation flow

Not implemented yet:
- visible scene rendering
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

## Roadmap / Next Steps

- Phase 1: render a static platformer scene with rectangles
- Phase 2: add synchronized inputs and horizontal movement
- Phase 3: add gravity, jumping, and ground collision
- Phase 4: add platform collision and simple level geometry
- Phase 5: create a minimal playable fixed-screen prototype

## Notes

- Hardware behavior beyond basic synthesis setup is not yet verified on a physical board.
- The button pin assignments for left/right/up were added for the planned control scheme and should be checked against the exact board revision during hardware bring-up.
- See [`docs/phase-00.md`](docs/phase-00.md) for the Phase 0 adaptation notes.

