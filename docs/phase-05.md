# Phase 05 - Minimal playable level

## What Was Added

Phase 5 turns the project into a small playable fixed-screen prototype:

- goal detection
- latched win state
- reset/restart flow
- simple win-state visual feedback

The player can now move through the level, jump across the platforms, and complete the screen by touching the goal rectangle.

## Why This Design Was Chosen

The goal for this phase was to make the project feel complete enough to play without introducing a large game framework.

The design stays intentionally small:

- one simple goal overlap check
- one latched `game_won` state
- one existing reset button for restart
- one renderer palette shift to show completion

That keeps the architecture extendable while still delivering a coherent prototype.

## Module Breakdown

- `game_state.v`: now latches a win state when the player overlaps the goal and freezes movement after the level is completed
- `renderer.v`: changes the scene colors in the win state so completion is obvious without text or sprites
- `tb_game_state.v`: verifies goal overlap and frozen player movement after winning
- `tb_top_mario_game.v`: verifies the top-level win-state palette shift

## How To Simulate / Build

Simulation:

```bash
make sim
```

Game-state checks:

```bash
make sim_game_state
```

Vivado project creation:

```bash
make vivado
```

## Known Issues

- There is still no lose state or hazard behavior.
- The win state uses palette feedback only; there is no text overlay or score display.
- Inputs are synchronized but not debounced.
- Hardware behavior is still unverified on a physical board.

## Next Phase Ideas

Reasonable next expansions from this foundation:

- hazard rectangle and lose state
- simple restart/play/win/lose state machine
- collectible rectangles or coins
- tile or block representation instead of named rectangles
- sprite ROMs and animation

