extends Node2D

const VisualAssetScript := preload("res://scripts/visuals/visual_asset.gd")
const ANIMATION_DIR := "res://assets/art/sprites/pickups/xp_shard_frames"
const SPRITE_PATH := "res://assets/art/sprites/pickups/xp_shard.png"
const ANIMATION_FPS := 8.0
const RADIUS := 7.0
const MAGNET_RANGE := 95.0
const COLLECT_RANGE := 22.0
const MAGNET_SPEED := 260.0

var amount: float = 1.0
var player: Node2D
var visual_node: Node2D

func _ready() -> void:
	visual_node = VisualAssetScript.create_visual_node(ANIMATION_DIR, SPRITE_PATH, RADIUS * 2.0, ANIMATION_FPS, true)
	if visual_node != null:
		add_child(visual_node)

func setup(spawn_position: Vector2, xp_amount: float, target_player: Node2D) -> void:
	global_position = spawn_position
	amount = xp_amount
	player = target_player

func _process(delta: float) -> void:
	if RunState.is_level_up_paused or player == null:
		return
	var distance := global_position.distance_to(player.global_position)
	if distance <= COLLECT_RANGE:
		GameEvents.xp_collected.emit(amount)
		queue_free()
	elif distance <= MAGNET_RANGE:
		global_position = global_position.move_toward(player.global_position, MAGNET_SPEED * delta)

func _draw() -> void:
	if visual_node != null:
		return
	draw_circle(Vector2.ZERO, RADIUS, Color(0.35, 0.95, 1.0))
	draw_circle(Vector2.ZERO, RADIUS * 0.45, Color(0.9, 1.0, 1.0))
