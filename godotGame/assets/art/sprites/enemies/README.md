# Enemy Sprite Slots

Enemy animation and fallback sprite paths are configured in `resources/enemies/*.tres`.

- `enemy_chaser_frames/frame_000.png`, ... preferred; `enemy_chaser.png` fallback. Ordinary chaser, PNG, transparent background, `96x96`, `8 FPS`, displayed at roughly `84x84` world units.
- `enemy_fast_frames/frame_000.png`, ... preferred; `enemy_fast.png` fallback. Fast low-health enemy, PNG, transparent background, `80x80`, `10 FPS`, displayed at roughly `69x69` world units.
- `enemy_tank_frames/frame_000.png`, ... preferred; `enemy_tank.png` fallback. High-health slow enemy, PNG, transparent background, `128x128`, `6 FPS`, displayed at roughly `108x108` world units.

Collision and contact radius remain separate from visual footprint. If a file is missing, `scripts/enemies/enemy.gd` draws the configured placeholder color.
