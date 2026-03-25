# Phase 03 - Gravity and jumping

## What Was Added

Phase 3 adds the first vertical gameplay behavior:

- gravity
- jump impulse
- landing on the ground
- no double-jump

The player can now move horizontally, jump from the ground, travel through a simple arc, and land back on the floor.

## Why This Design Was Chosen

The main priority in this phase was stability, not realism.

The design uses a very small frame-based physics model:

- one signed vertical velocity register
- one fixed gravity increment
- one fixed jump impulse
- one simple ground collision rule

This is easy for a student to trace in simulation and leaves a clean path for platform collision in the next phase.

## Module Breakdown

- `game_state.v`: now owns horizontal movement, vertical velocity, gravity, jump start, and ground landing
- `tb_game_state.v`: verifies movement, jump launch, midair jump rejection, and landing
- `tb_top_mario_game.v`: still checks representative rendered colors and now also checks that the player leaves the ground when jump is pressed

## How To Simulate / Build

Simulation:

```bash
make sim
```

Physics-focused simulation:

```bash
make sim_game_state
```

Vivado project creation:

```bash
make vivado
```

## Known Issues

- Only ground collision exists in this phase.
- Platforms are still visual only and do not stop the player yet.
- Inputs are synchronized but not debounced.
- Hardware behavior is still unverified on a physical board.

## Next Phase Plan

Phase 4 will turn level geometry into actual colliders:

- landing on platforms
- preventing fall-through
- simple underside and side collision handling
- level geometry represented in a way that can grow into a block or tile system

