# Phase 01 - Static game screen

## What Was Added

Phase 1 replaces the placeholder black frame with a simple rectangle-based platformer scene:

- sky background
- ground strip
- two platforms
- visible player rectangle
- visible goal rectangle

The scene is fixed-screen and intentionally non-interactive in this phase.

## Why This Design Was Chosen

The main goal of Phase 1 is to make the repo feel like a game project without introducing movement or physics too early.

The design stays simple on purpose:

- only solid rectangles
- no sprites
- no scrolling
- no animation
- no tile ROM

That keeps the video pipeline easy to reason about while still establishing the visual structure needed for later phases.

## Module Breakdown

- `scene_layout.v`: defines the fixed rectangles for ground, platforms, and goal
- `game_state.v`: still owns the player rectangle, currently at a fixed starting position
- `renderer.v`: composites the visible scene using straightforward region checks and color priority
- `top_mario_game.v`: integrates the timing path, frame tick, state, and renderer

## How To Simulate / Build

Simulation:

```bash
make sim
```

Vivado project creation:

```bash
make vivado
```

## Simulation Coverage

The top-level Phase 1 testbench checks representative pixels to verify:

- sky color
- both platform colors
- goal color
- player color
- ground color
- blanking remains black outside the visible area

This is still lightweight, but it gives a useful regression check for future renderer changes.

## Known Issues

- No board inputs affect gameplay yet.
- The player is drawn at a fixed location and does not move.
- Level geometry is still hard-coded as a few named rectangles rather than a tile map.
- Hardware output has not yet been verified on a physical board.

## Next Phase Plan

Phase 2 will add player input and horizontal movement:

- synchronize button inputs cleanly
- move the player left and right
- clamp the player within screen bounds
- keep the update logic simple and frame-based

