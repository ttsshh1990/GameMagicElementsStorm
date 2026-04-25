# Projectile VFX Slots

- Preferred frames: `fireball_frames/frame_000.png`, `frame_001.png`, ...
- Fallback file: `fireball.png`
- Format: PNG, transparent background
- Source size: `64x64`
- Playback: `12 FPS`, loop while projectile exists
- Runtime footprint: scaled to roughly `16x16` world units
- Current fallback: orange circular projectile in `scripts/combat/projectile.gd`
