# Chess Cards — Godot Migration Plan

## Pre-Phase: Setup
- [ ] Fix asset naming inconsistencies (typos, mixed hyphens/underscores)
- [ ] Switch renderer from Forward+ to Compatibility (gl_compatibility)
- [ ] Set viewport to 1080x1920 portrait, canvas_items stretch mode
- [ ] Create project folder structure (src/data, src/managers, src/state, src/ui, scenes, resources)

## Phase 1: "Two Pawns Fight" — Data Model + Combat + Card Rendering
- [ ] `src/data/ability.gd` — Ability enum
- [ ] `src/data/piece_type.gd` — PieceType enum + STATS dictionary
- [ ] `src/data/card_data.gd` — Resource class: name, attack, defense, abilities
- [ ] `src/data/slot_result.gd` + `combat_result.gd` — Combat result data
- [ ] `src/data/health_bar_data.gd` — Resource with signal, HP logic
- [ ] `src/managers/combat_resolver.gd` — Autoload: pure combat math
- [ ] `src/util/constants.gd` — Autoload: game constants
- [ ] `scenes/card_ui.tscn` + `src/ui/card_ui.gd` — 9-layer card scene
- [ ] `scenes/health_bar_ui.tscn` + `src/ui/health_bar_ui.gd` — Reactive HP bar
- [ ] Test scene: two cards fight, verify damage + animations

## Phase 2: "Place and Fight" — Full Local Round
- [ ] `src/data/deck.gd` — Deck resource with shuffle/draw
- [ ] `src/data/player_state.gd` — Resource: health, deck, hand, slots
- [ ] `src/data/point_tracker_data.gd` — Points resource
- [ ] State machine: game_state_machine.gd + base state.gd
- [ ] States: player_turn, pass_device, combat, round_end, game_over
- [ ] `src/managers/input_manager.gd` — Unified touch/mouse input
- [ ] `src/managers/game_manager.gd` — Central orchestrator
- [ ] Hand UI, BattleSlot UI, HUD, pass screen scenes
- [ ] `scenes/game_board.tscn` — Full board layout
- [ ] Tween helpers + damage popups

## Phase 3: "Play to Win" — Complete Local Game
- [ ] Main menu + game over screens
- [ ] Point tracker UI
- [ ] Multi-round flow, deck depletion, win conditions
- [ ] Responsive layout for different screens

## Phase 4: Polish & Cross-Platform
- [ ] Audio manager + SFX
- [ ] Card animations (idle sway, pickup scale, drop bounce)
- [ ] Combat particles, screen shake
- [ ] PC keyboard shortcuts, mobile touch tuning
- [ ] Export presets (macOS, Windows, iOS, Android)

## Phase 5: AI Opponent
- [ ] AI controller + strategy classes (random, heuristic)
- [ ] state_ai_turn.gd — slots into existing state machine
- [ ] Difficulty selection in menu

## Phase 6: Online Multiplayer
- [ ] Network manager (client-server, authoritative host)
- [ ] RPC-based action sending
- [ ] state_waiting_for_opponent.gd
- [ ] Lobby/matchmaking UI

---

## Architecture Quick Reference

**Swift → Godot**: Struct→Resource, Delegate→Signal, Static class→Autoload, SKAction→Tween, SKSpriteNode→PackedScene

**Signal flow**: InputManager → GameBoard → GameManager → PlayerState → UI (reactive via signals)

**Key principle**: All game logic through GameManager. UI never mutates state directly. This makes local/AI/online interchangeable.
