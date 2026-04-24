---
name: elemental-art-assets
description: Generate, review, and integrate visually consistent art assets for Game1, a 2D top-down ice/fire/lightning elemental bullet-hell roguelike. Use when Codex or the art agent needs stable prompt packs, style references, sprite/icon/VFX generation, asset naming, asset registry updates, or Godot art integration planning for Game1.
---

# Elemental Art Assets

Use this skill to keep Game1's generated art coherent across sessions, machines, and agents. It provides the art agent with a repeatable workflow, stable prompt pack, style sample images, and integration rules.

## Required Context

Before generating or integrating assets, read:

- `docs/design/current-design.md`
- `agents/art-agent.md`
- `references/prompt-pack.md`
- `references/asset-workflow.md`

Use the bundled approved assets as visual references:

- `assets/game-ready/icons/icon_element_ice_512.png`
- `assets/game-ready/icons/icon_element_fire_512.png`
- `assets/game-ready/icons/icon_element_lightning_512.png`
- `assets/style-samples/characters-and-enemies-style.png`

Current approval notes:

- `icon_element_ice_512.png`, `icon_element_fire_512.png`, and `icon_element_lightning_512.png` are approved game-ready element icons.
- Use the player character direction from `characters-and-enemies-style.png`.

## Workflow

1. **Classify the request** as style exploration, production asset generation, or Godot integration.
2. **Lock the asset spec** before generation: asset id, use case, target size, transparent background need, animation frame count, and destination path.
3. **Build the prompt** from `references/prompt-pack.md`; do not invent a new global style unless the user explicitly asks to change art direction.
4. **Generate with the `imagegen` skill** for bitmap assets. For transparent assets, use chroma-key generation and local background removal unless the user explicitly asks for true native transparency.
5. **Save project-bound outputs inside the repo**. Do not leave referenced assets only under `$CODEX_HOME/generated_images`.
6. **Update the asset record** using the registry format in `references/asset-workflow.md`.
7. **Integrate into Godot only when a Godot project exists**. If it does not, create a clear engineering handoff task instead of inventing project files.

## Style Contract

- Camera: 2D top-down or top-down-readable asset presentation.
- Rendering: semi-stylized indie game art, crisp silhouettes, high contrast, controlled glow, readable at gameplay scale.
- Background for project assets: transparent PNG preferred; flat chroma-key source is acceptable during generation.
- Element language:
  - Ice: cyan / pale blue / white, vertical diamond-shaped ice crystal crest, frosted facets, sharp ice shards, subtle snowflake etching, cold mist, control and freeze. It must follow `icon_element_ice_512.png` and avoid becoming a generic blue jewel or a large snowflake emblem.
  - Fire: orange / red / gold, rounded flame and molten shapes, burst and impact.
  - Lightning: yellow / violet, sharp zigzags, chained arcs, speed and propagation.
- Avoid: photorealism, text inside images, watermarks, busy backgrounds, low-contrast silhouettes, arbitrary style shifts.

## Integration Boundary

This skill can prepare assets and integration instructions. It should only modify Godot scenes, scripts, import settings, or project directories when the user asks for game integration and a Godot project already exists.

If no Godot project exists, save the asset in a project-local staging path and add an engineering handoff describing where it should be used.
