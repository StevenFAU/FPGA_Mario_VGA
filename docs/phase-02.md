# Phase 02 - Input and horizontal movement

## What Was Added

Phase 2 adds the first interactive behavior:

- synchronized left/right/up button inputs
- frame-based horizontal player movement
- screen boundary clamping
- a dedicated movement testbench

The player can now move across the fixed-screen scene using the board controls.

## Why This Design Was Chosen

This phase keeps the logic intentionally conservative.

The goal is not maximum responsiveness yet. The goal is a stable, readable update path that works cleanly with later gravity and collision logic:

- synchronize asynchronous button inputs
- update the player on the frame tick
- use one fixed integer movement step
- clamp motion at the visible bounds

That matches the teaching-oriented style of the project and avoids introducing unnecessary complexity too early.

## Module Breakdown

- `input_sync.v`: two-flop synchronizer for asynchronous button inputs
- `game_state.v`: adds horizontal motion and boundary clamping
- `top_mario_game.v`: wires synchronized button signals into the game state
- `tb_game_state.v`: verifies movement step size, opposing input behavior, and clamping

## How To Simulate / Build

Simulation:

```bash
make sim
```

Movement-focused simulation:

```bash
make sim_game_state
```

Vivado project creation:

```bash
make vivado
```

## Known Issues

- Inputs are synchronized but not debounced yet.
- Jump input is reserved but not used until Phase 3.
- Movement is still screen-space only; there is no world scrolling.
- Gravity and collision are not implemented yet.
- Hardware behavior is still unverified on a physical board.

## Next Phase Plan

Phase 3 will add the first vertical physics:

- gravity
- jump impulse
- landing on the ground
- no double-jump
- stable frame-based vertical updates

