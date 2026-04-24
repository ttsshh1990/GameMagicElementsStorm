# Asset Workflow

Use this workflow when creating project-bound art for Game1.

## Asset Spec

Before generation, define:

- `asset_id`: lowercase English id, for example `icon_element_ice`.
- `category`: `sprite`, `vfx`, `icon`, `ui`, `concept`, or `reference`.
- `purpose`: where the asset will be used in gameplay or UI.
- `target_size`: intended in-game size, for example `64x64`, `128x128`, or `512 concept`.
- `background`: `transparent`, `chroma-key`, or `reference-sheet`.
- `animation`: `single`, `spritesheet`, or frame count.
- `destination`: repo path for the final project-bound file.

## Suggested Paths

Use these paths once the project has an asset directory or Godot project:

- `assets/art/source/`: generated originals and source references.
- `assets/art/sprites/`: gameplay sprites.
- `assets/art/vfx/`: skill VFX frames and spritesheets.
- `assets/art/icons/`: element, reward, rune, and UI icons.
- `assets/art/ui/`: UI panels, buttons, frames, and reward cards.

While the project has no Godot project, keep skill samples inside:

- `skills/elemental-art-assets/assets/style-samples/`

## Naming

Use lowercase English filenames:

```text
<category>_<subject>_<variant>_<size>.<ext>
```

Examples:

- `icon_element_ice_64.png`
- `vfx_fire_meteor_impact_128.png`
- `sprite_enemy_chaser_base_64.png`
- `ui_reward_card_frame_base_256.png`

## Registry Entry

When an asset becomes project-bound, add or update an asset registry entry in the project documentation. If no registry file exists yet, create one only when the user asks for production asset tracking.

```md
## <asset_id>

- Category:
- Purpose:
- Source prompt:
- Source image:
- Final file:
- Target size:
- Background:
- Integration status: staged / integrated / replaced
- Godot usage:
- Notes:
```

## Godot Integration Rules

Only integrate when a Godot project exists.

For sprites and icons:

- Import as PNG.
- Prefer transparent PNG for gameplay/UI assets.
- Keep source generation files separate from final game-ready files.
- Do not overwrite existing assets without explicit replacement instruction.
- After adding assets, update any scene, script, or resource references needed by the requested task.

For VFX:

- Prefer a single clean sprite first for prototype readability.
- Use spritesheets only after the effect timing is known.
- If animation is requested, define frame count, frame size, playback FPS, and loop mode before generation.

For handoff:

- If art is ready but engineering integration is blocked, add a task for `engineering-agent` with the final file path, intended scene/system, and any import settings.
