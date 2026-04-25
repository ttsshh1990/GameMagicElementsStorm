extends SceneTree

const VisualAssetScript := preload("res://scripts/visuals/visual_asset.gd")

const EXISTING_ICON_PATH := "res://assets/art/icons/elements/icon_element_fire_512.png"
const PLAYER_PATH := "res://assets/art/sprites/player/player_idle.png"
const PLAYER_FRAMES := "res://assets/art/sprites/player/player_idle_frames"
const MISSING_TEXTURE_PATH := "res://assets/art/__missing__/missing.png"
const MISSING_FRAMES_DIR := "res://assets/art/__missing__/missing_frames"
const EXPECTED_CHASER_PATH := "res://assets/art/sprites/enemies/enemy_chaser.png"
const EXPECTED_CHASER_FRAMES := "res://assets/art/sprites/enemies/enemy_chaser_frames"
const EXPECTED_FAST_PATH := "res://assets/art/sprites/enemies/enemy_fast.png"
const EXPECTED_FAST_FRAMES := "res://assets/art/sprites/enemies/enemy_fast_frames"
const EXPECTED_TANK_PATH := "res://assets/art/sprites/enemies/enemy_tank.png"
const EXPECTED_TANK_FRAMES := "res://assets/art/sprites/enemies/enemy_tank_frames"
const EXPECTED_FIREBALL_PATH := "res://assets/art/vfx/projectiles/fireball.png"
const EXPECTED_FIREBALL_FRAMES := "res://assets/art/vfx/projectiles/fireball_frames"
const PLAYER_VISUAL_WORLD_SIZE := 108.0

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	if not _check_loader():
		quit(1)
		return

	var scene := load("res://scenes/main/main.tscn")
	var main: Node = scene.instantiate()
	root.add_child(main)
	await process_frame

	if not _check_configured_paths(main):
		quit(1)
		return
	if not _check_player_visual(main):
		quit(1)
		return

	print("Visual asset smoke passed: configured art paths load when present and fall back when missing.")
	quit(0)

func _check_loader() -> bool:
	var texture := VisualAssetScript.load_texture(EXISTING_ICON_PATH)
	if texture == null or texture.get_width() != 512 or texture.get_height() != 512:
		push_error("Visual asset smoke failed: existing texture did not load at expected size.")
		return false
	if not _check_frame_sequence(PLAYER_FRAMES, 4, Vector2i(128, 128)):
		return false
	if not _check_frame_sequence(EXPECTED_CHASER_FRAMES, 4, Vector2i(96, 96)):
		return false
	if not _check_frame_sequence(EXPECTED_FAST_FRAMES, 4, Vector2i(80, 80)):
		return false
	if not _check_frame_sequence(EXPECTED_TANK_FRAMES, 4, Vector2i(128, 128)):
		return false
	if VisualAssetScript.load_texture(MISSING_TEXTURE_PATH) != null:
		push_error("Visual asset smoke failed: dummy missing texture unexpectedly loaded.")
		return false
	if not VisualAssetScript.load_frame_sequence(MISSING_FRAMES_DIR).is_empty():
		push_error("Visual asset smoke failed: dummy missing frame directory unexpectedly loaded.")
		return false
	var sprite := VisualAssetScript.create_sprite(EXISTING_ICON_PATH, 34.0)
	if sprite == null or sprite.name != "VisualSprite" or sprite.texture == null:
		push_error("Visual asset smoke failed: helper did not create Sprite2D.")
		return false
	if not is_equal_approx(sprite.scale.x, 34.0 / 512.0):
		push_error("Visual asset smoke failed: Sprite2D scale is %s." % sprite.scale)
		return false
	sprite.free()
	var animated := VisualAssetScript.create_animated_sprite(PLAYER_FRAMES, PLAYER_VISUAL_WORLD_SIZE, 8.0, true)
	if animated == null or animated.sprite_frames.get_frame_count(VisualAssetScript.DEFAULT_ANIMATION) != 4:
		push_error("Visual asset smoke failed: helper did not create AnimatedSprite2D from PNG sequence.")
		return false
	if not is_equal_approx(animated.scale.x, PLAYER_VISUAL_WORLD_SIZE / 128.0):
		push_error("Visual asset smoke failed: AnimatedSprite2D scale is %s." % animated.scale)
		return false
	animated.free()
	return true

func _check_configured_paths(_main: Node) -> bool:
	var content_registry = root.get_node("/root/ContentRegistry")
	var chaser_def = content_registry.get_enemy_def(&"chaser")
	var fireball_def = content_registry.get_skill_def(&"fireball")
	if chaser_def.animation_dir != EXPECTED_CHASER_FRAMES:
		push_error("Visual asset smoke failed: chaser animation_dir is %s." % chaser_def.animation_dir)
		return false
	if chaser_def.sprite_path != EXPECTED_CHASER_PATH:
		push_error("Visual asset smoke failed: chaser sprite_path is %s." % chaser_def.sprite_path)
		return false
	if not is_equal_approx(chaser_def.visual_world_size, 84.0):
		push_error("Visual asset smoke failed: chaser visual_world_size is %s." % chaser_def.visual_world_size)
		return false
	var fast_def = content_registry.get_enemy_def(&"fast")
	var tank_def = content_registry.get_enemy_def(&"tank")
	if fast_def.animation_dir != EXPECTED_FAST_FRAMES:
		push_error("Visual asset smoke failed: fast animation_dir is %s." % fast_def.animation_dir)
		return false
	if fast_def.sprite_path != EXPECTED_FAST_PATH:
		push_error("Visual asset smoke failed: fast sprite_path is %s." % fast_def.sprite_path)
		return false
	if not is_equal_approx(fast_def.visual_world_size, 69.0):
		push_error("Visual asset smoke failed: fast visual_world_size is %s." % fast_def.visual_world_size)
		return false
	if tank_def.animation_dir != EXPECTED_TANK_FRAMES:
		push_error("Visual asset smoke failed: tank animation_dir is %s." % tank_def.animation_dir)
		return false
	if tank_def.sprite_path != EXPECTED_TANK_PATH:
		push_error("Visual asset smoke failed: tank sprite_path is %s." % tank_def.sprite_path)
		return false
	if not is_equal_approx(tank_def.visual_world_size, 108.0):
		push_error("Visual asset smoke failed: tank visual_world_size is %s." % tank_def.visual_world_size)
		return false
	if fireball_def.vfx_frames_dir != EXPECTED_FIREBALL_FRAMES:
		push_error("Visual asset smoke failed: fireball vfx_frames_dir is %s." % fireball_def.vfx_frames_dir)
		return false
	if fireball_def.vfx_path != EXPECTED_FIREBALL_PATH:
		push_error("Visual asset smoke failed: fireball vfx_path is %s." % fireball_def.vfx_path)
		return false
	return true

func _check_player_visual(main: Node) -> bool:
	var player = main.game_world.player
	var has_player_frames := not VisualAssetScript.load_frame_sequence(PLAYER_FRAMES).is_empty()
	var has_player_texture := VisualAssetScript.load_texture(PLAYER_PATH) != null
	if has_player_frames or has_player_texture:
		if player.visual_node == null:
			push_error("Visual asset smoke failed: player visual asset exists but did not load.")
			return false
		if has_player_frames and not player.visual_node is AnimatedSprite2D:
			push_error("Visual asset smoke failed: player frame sequence did not load as AnimatedSprite2D.")
			return false
		if not is_equal_approx(player.visual_node.scale.x, PLAYER_VISUAL_WORLD_SIZE / 128.0):
			push_error("Visual asset smoke failed: player visual scale is %s." % player.visual_node.scale)
			return false
		return true
	if player.visual_node != null:
		push_error("Visual asset smoke failed: missing player visual should use fallback drawing.")
		return false
	return true

func _check_frame_sequence(frames_dir: String, expected_count: int, expected_size: Vector2i) -> bool:
	var textures := VisualAssetScript.load_frame_sequence(frames_dir)
	if textures.size() != expected_count:
		push_error("Visual asset smoke failed: %s loaded %s frames, expected %s." % [frames_dir, textures.size(), expected_count])
		return false
	for texture: Texture2D in textures:
		if Vector2i(texture.get_width(), texture.get_height()) != expected_size:
			push_error("Visual asset smoke failed: %s has frame size %sx%s, expected %sx%s." % [frames_dir, texture.get_width(), texture.get_height(), expected_size.x, expected_size.y])
			return false
	return true
