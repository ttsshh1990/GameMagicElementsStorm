# Tests

Smoke tests and future Godot validation scripts live here.

- `smoke_test.gd`: validates that the main scene instantiates.
- `core_loop_smoke_test.gd`: validates reward flow, enemy spawning, and debug health lock.
- `input_actions_smoke_test.gd`: validates WASD / arrow key movement mappings and level-up pause input blocking.
- `display_layout_smoke_test.gd`: validates 1280x720 landscape settings, UI anchors, element icon asset sizing, and the synthesis panel shell.
- `visual_asset_smoke_test.gd`: validates optional runtime art frame loading, single-image fallback, and missing-asset fallback behavior.
- `synthesis_smoke_test.gd`: validates element gain rewards, no auto-synthesis on three fire, and the manual fire-fire-fire meteor synthesis path.
- `meteor_strike_smoke_test.gd`: validates the meteor skill's diagonal falling intro before impact VFX.
