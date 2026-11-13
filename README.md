# ChessCards 2.0

A card battler where **your deck is a chess army**, rebuilt in **Godot 4** from my original [SpriteKit version](https://github.com/Bttaleb/Chall4Game).

Each player draws from the same set of pieces as a chess side (8 pawns, 2 knights, 2 bishops, 2 rooks, a queen and a king) and plays them into battle slots. Every piece has its own attack, defense and abilities.

<!-- Add a GIF of dragging a card into a slot here -->

## What works so far

- Deck that draws cards into the player's hand with animated movement
- Hand that shows **one card per piece type with a remaining count**, instead of one node per card
- Drag and drop from hand into card slots, with hover highlighting and raycast-based hit testing
- Card data defined in one place (`CardDatabase.gd`)

## Why a rebuild?

Version 1 (Swift/SpriteKit, built at the Apple Developer Academy) proved the idea. Rebuilding it in Godot was a chance to fix the architecture. The biggest lesson: in v1, each card node **was** the data, so you couldn't show "7 pawns left" without seven nodes on screen. v2 keeps the hand as data (piece → count) and treats card nodes purely as display.

I wrote down the principles I learned in [`docs/insights.md`](card-game-2/docs/insights.md):

1. Separate data from display
2. Don't use display objects as dictionary keys
3. Scene-tree ownership vs. data references
4. Array methods don't work on dictionaries
5. Counter variables for position indexing
6. Connecting nodes to data (the bridge pattern)

There's also a flow diagram of the hand system in [`docs/card-hand-system.excalidraw`](card-game-2/docs/card-hand-system.excalidraw) and an HTML [design prototype](card-game-2/design/prototype.html).

## Project structure

```
card-game-2/
├── Main.tscn            main scene
├── InputManager.gd      mouse input + raycasts for cards and deck
├── Scenes/              Card, CardSlot
├── Script/              CardManager, CardDatabase, Deck, PlayerHand, Card, CardSlot
├── Assets/              card art, card backs, battle slots
├── docs/                insights + diagrams
└── design/              HTML prototype
```

## Running it

1. Install [Godot 4](https://godotengine.org/download) (the project targets 4.x, Forward+).
2. In the Godot project manager, **Import** `card-game-2/project.godot`.
3. Press **F5** to run.

## Roadmap

- [ ] Port turn system and combat resolution from v1
- [ ] Piece abilities
- [ ] Second player / AI opponent

## Built with

Godot 4 · GDScript
