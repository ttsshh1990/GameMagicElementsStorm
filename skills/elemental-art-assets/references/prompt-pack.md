# Prompt Pack

Use these prompt blocks to keep Game1 art consistent. Compose prompts from top to bottom: global style, asset-specific block, element block, output constraints.

## Global Style Block

```text
Create game art for Game1, a 2D top-down elemental bullet-hell roguelike about ice, fire, and lightning builds.
Style: semi-stylized indie game art, crisp readable silhouette, high contrast, saturated but controlled elemental colors, subtle painterly edges, clean game-ready shapes, readable at small gameplay scale.
Camera and presentation: top-down readable asset view, centered subject, generous padding, consistent lighting, no scene clutter.
Avoid: photorealism, realistic anatomy, complex background, labels, UI text, watermark, logo, heavy cast shadows, muddy colors, tiny details that disappear at 32-64 px.
```

## Element Blocks

### Ice

```text
Element language: ice uses a vertical diamond-shaped ice crystal crest as the main silhouette, icy cyan, pale blue, white highlights, frosted facets, transparent ice shards, crystalline fracture lines, cold mist, crisp edges, and cold glow.
Gameplay feeling: control, slow, freeze, defensive stability.
Readability rule: the asset must immediately read as ICE at 32-64 px while keeping the simple diamond-crystal direction. Add a subtle snowflake etching or frost veins inside the crystal, but do not turn the whole icon into a large snowflake emblem. Do not make it a generic blue jewel, teal gemstone, water droplet, shield, or abstract blue magic icon.
Color rule: keep the palette cold white / pale blue / icy cyan with small deep-blue shadows. Avoid green or teal dominance.
Approved reference: use `assets/game-ready/icons/icon_element_ice_512.png`.
```

### Fire

```text
Element language: fire uses orange, red, gold highlights, rounded flames, molten cores, ember fragments, explosive impact, warm glow.
Gameplay feeling: burst damage, area impact, fast clearing, direct damage.
Approved reference: use `assets/game-ready/icons/icon_element_fire_512.png`.
```

### Lightning

```text
Element language: lightning uses bright yellow cores, violet plasma edges, sharp zigzags, branching arcs, electric orbs, fast propagation.
Gameplay feeling: chaining, trigger frequency, speed, group clearing.
Approved reference: use `assets/game-ready/icons/icon_element_lightning_512.png`.
```

### Tri-Element

```text
Element language: combine cyan ice facets, orange molten flame, and yellow-violet lightning arcs in one readable magic motif. Keep the three elements visually separated enough to read at small size.
Gameplay feeling: unstable combined elemental power, build payoff, high-energy aura.
```

## Asset Type Blocks

### Gameplay Sprite

```text
Asset type: isolated 2D top-down gameplay sprite.
Requirements: strong silhouette, clear front/top orientation, no background, no text, readable when scaled down, no unnecessary details.
Approved reference: use the player character direction from `assets/style-samples/characters-and-enemies-style.png`.
```

### Skill VFX

```text
Asset type: isolated skill VFX concept for a 2D top-down game.
Requirements: clear attack shape, readable damage area, strong elemental identity, transparent-ready edges, centered subject, no enemies or UI unless requested.
```

### Icon

```text
Asset type: game icon, readable at 32 to 64 px.
Requirements: simple shape, centered object, strong outline or contrast edge, no letters, no numbers, no tiny symbols, consistent stroke weight.
Reference guidance: for ice, fire, and lightning icons, use the approved files in `assets/game-ready/icons/`.
```

### Reward Card Art

```text
Asset type: reward-card illustration or icon.
Requirements: clear subject, simple composition, enough negative space for UI framing, no embedded text, consistent with icon style.
```

### Style Sheet

```text
Asset type: style reference sheet, not a production asset.
Requirements: multiple isolated examples on a flat dark neutral background, consistent scale and lighting, no text labels.
```

## Transparent Asset Block

Use this when the asset will be integrated into the game as PNG with alpha.

```text
Create the requested subject on a perfectly flat solid #00ff00 chroma-key background for background removal.
The background must be one uniform color with no shadows, gradients, texture, reflections, floor plane, or lighting variation.
Keep the subject fully separated from the background with crisp edges and generous padding.
Do not use #00ff00 anywhere in the subject.
No cast shadow, no contact shadow, no reflection, no watermark, and no text unless explicitly requested.
```

## Common Prompt Templates

### Element Icon

```text
<Global Style Block>
<Icon>
<Element Block>
Primary request: create one isolated <ice/fire/lightning/tri-element> element icon for Game1.
Output: square composition, centered subject, transparent-ready, no text.
```

### Skill VFX Concept

```text
<Global Style Block>
<Skill VFX>
<Element Block>
Primary request: create one isolated VFX concept for <skill name>. The effect should communicate <shape>, <damage area>, and <movement/impact behavior>.
Output: transparent-ready, no text, no UI, no character unless requested.
```

### Enemy Sprite

```text
<Global Style Block>
<Gameplay Sprite>
Primary request: create one isolated enemy sprite for <enemy role>.
Design: silhouette should communicate <basic chaser / fast small enemy / heavy enemy>. Use dark body masses with a readable bright magic core.
Output: transparent-ready, no text, no gore, no complex anatomy.
```

### Reward Icon

```text
<Global Style Block>
<Reward Card Art>
Primary request: create one isolated reward icon for <reward name>.
Design: communicate the gameplay effect without letters or symbols that require reading.
Output: transparent-ready, readable at 64 px, no text.
```
