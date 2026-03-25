# Phase 00 - Scaffold from source repo

## What Was Added

Phase 0 created a new standalone repo for the Mario-style VGA project while preserving the useful flow from the source repository:

- root-level `Makefile` for simulation and Vivado project creation
- root-level `create_project.tcl`
- `src/`, `sim/`, `constraints/`, and `docs/` directories
- reusable VGA timing and clock modules
- a game-oriented top module and placeholder submodules
- basic simulation smoke tests
- top-level README for GitHub presentation

## Why This Design Was Chosen

The source repo is intentionally small. That is a strength worth keeping.

For the new project, the main adaptation was architectural rather than stylistic:

- preserve the simple Makefile and Tcl flow
- preserve Verilog-2001 compatibility
- preserve a simulation-first habit
- rename the design around a game top-level instead of a one-off text demo
- create clear extension points for rendering, game state, and frame-based updates

Phase 0 stops short of gameplay on purpose. It establishes structure first so later phases can stay incremental and understandable.

## Source Repo Notes

Observed source repo structure:

- `src/clk_div.v`
- `src/vga_timing.v`
- `src/font_rom.v`
- `src/text_renderer.v`
- `src/top_vga.v`
- `sim/tb_vga_timing.v`
- `sim/tb_text_renderer.v`
- `constraints/nexys4ddr.xdc`
- `Makefile`
- `create_project.tcl`

Observed source repo flow:

- use `iverilog` and `vvp` from the repo root
- use one Tcl script to recreate the Vivado project
- target part `xc7a100tcsg324-1`
- drive VGA from a divided-down 25 MHz pixel clock

## Module Breakdown

- `clk_div.v`: divides the 100 MHz board clock down to 25 MHz for VGA timing
- `vga_timing.v`: generates 640x480 sync, pixel coordinates, and `video_on`
- `frame_tick.v`: generates a one-cycle pulse at the start of each frame
- `game_state.v`: placeholder holder for player state and future gameplay logic
- `renderer.v`: placeholder video path that will become the rectangle compositor
- `top_mario_game.v`: top-level integration module for clocking, timing, state, and rendering

## How To Simulate / Build

Simulation:

```bash
make sim
```

Vivado project creation:

```bash
make vivado
```

## Known Issues

- The renderer is intentionally a placeholder and currently outputs a black frame.
- Button synchronization and debouncing are not implemented yet.
- Left/right/up button pin assignments should be validated on real hardware.
- The project has not been exercised on a physical Nexys board yet.

## Next Phase Plan

Phase 1 will replace the placeholder renderer output with a static platformer scene made only from colored rectangles:

- sky/background
- ground
- one or more platforms
- a visible player rectangle
- a goal rectangle or marker
- a cleaner rendering path that remains easy to extend

