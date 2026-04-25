extends CharacterBody2D

const VisualAssetScript := preload("res://scripts/visuals/visual_asset.gd")
const ANIMATION_DIR := "res://assets/art/sprites/player/player_idle_frames"
const SPRITE_PATH := "res://assets/art/sprites/player/player_idle.png"
const ANIMATION_FPS := 8.0
const MOVE_SPEED := 260.0
const RADIUS := 18.0
const VISUAL_WORLD_SIZE := 108.0

var visual_node: Node2D

func _ready() -> void:
	name = "Player"
	visual_node = VisualAssetScript.create_visual_node(ANIMATION_DIR, SPRITE_PATH, VISUAL_WORLD_SIZE, ANIMATION_FPS, true)
	if visual_node != null:
		add_child(visual_node)

func _physics_process(_delta: float) -> void:
	if RunState.is_level_up_paused:
		velocity = Vector2.ZERO
		return
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * MOVE_SPEED
	move_and_slide()
	queue_redraw()

func _draw() -> void:
	if visual_node != null:
		return
	draw_circle(Vector2.ZERO, RADIUS, Color(0.2, 0.75, 1.0))
	draw_circle(Vector2.ZERO, RADIUS * 0.55, Color(0.85, 0.95, 1.0))
