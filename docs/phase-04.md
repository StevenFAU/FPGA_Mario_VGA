# Phase 04 - Platforms and collision

## What Was Added

Phase 4 turns the fixed platform rectangles into actual gameplay geometry:

- landing on platforms
- simple underside collision
- simple side collision
- shared scene geometry between rendering and physics

The player now interacts with the visible world instead of only the ground plane.

## Why This Design Was Chosen

The project still aims to stay approachable for a student reading the RTL.

Instead of jumping straight to a tile engine or a large collision system, this phase keeps the rules explicit:

- a few named rectangles
- a few clear collision cases
- one place in `game_state.v` that resolves motion against the level

That keeps the current code easy to understand while creating a clean bridge toward a future block or tile representation.

## Module Breakdown

- `scene_layout.v`: still defines the fixed world rectangles, now reused by both renderer and physics
- `game_state.v`: resolves horizontal movement, jump/gravity, ground landing, platform landing, underside blocking, and side blocking
- `tb_game_state.v`: adds direct checks for landing on a platform, hitting a platform underside, and side clamping

## How To Simulate / Build

Simulation:

```bash
make sim
```

Game-state collision checks:

```bash
make sim_game_state
```

Vivado project creation:

```bash
make vivado
```

## Known Issues

- Collision is intentionally simple and based on a small set of hard-coded rectangles.
- There is still no win/lose state handling.
- Inputs are synchronized but not debounced.
- Hardware behavior is still unverified on a physical board.

## Next Phase Plan

Phase 5 will make the prototype feel like a small game:

- start position
- goal area behavior
- reset/restart behavior
- optional lose or hazard behavior if it fits cleanly
- a very small game state machine if needed

