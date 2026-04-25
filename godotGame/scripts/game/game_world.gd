extends Node2D

const PlayerScript := preload("res://scripts/player/player_controller.gd")
const EnemySpawnerScript := preload("res://scripts/spawning/enemy_spawner.gd")
const ProgressionSystemScript := preload("res://scripts/progression/progression_system.gd")
const RewardSystemScript := preload("res://scripts/rewards/reward_system.gd")
const SkillControllerScript := preload("res://scripts/skills/skill_controller.gd")
const XpShardScript := preload("res://scripts/pickups/xp_shard.gd")

const BACKGROUND_VIEW_SIZE := Vector2(1800.0, 1100.0)
const BACKGROUND_GRID_SIZE := 96.0

var player: CharacterBody2D
var enemy_layer: Node2D
var projectile_layer: Node2D
var pickup_layer: Node2D
var vfx_layer: Node2D
var reward_system: Node

func _ready() -> void:
	name = "GameWorld"
	_create_layers()
	_create_player()
	_create_systems()
	GameEvents.enemy_died.connect(_on_enemy_died)

func _process(delta: float) -> void:
	RunState.advance_time(delta)
	queue_redraw()

func _draw() -> void:
	var center := player.global_position if player != null else Vector2.ZERO
	var rect := Rect2(center - BACKGROUND_VIEW_SIZE * 0.5, BACKGROUND_VIEW_SIZE)
	draw_rect(rect, Color(0.70, 0.72, 0.72))
	_draw_repeating_grid(rect)

func _draw_repeating_grid(rect: Rect2) -> void:
	var grid_color := Color(0.58, 0.60, 0.60, 0.42)
	var start_x := floorf(rect.position.x / BACKGROUND_GRID_SIZE) * BACKGROUND_GRID_SIZE
	var end_x := rect.end.x + BACKGROUND_GRID_SIZE
	var x := start_x
	while x <= end_x:
		draw_line(Vector2(x, rect.position.y), Vector2(x, rect.end.y), grid_color, 1.0)
		x += BACKGROUND_GRID_SIZE

	var start_y := floorf(rect.position.y / BACKGROUND_GRID_SIZE) * BACKGROUND_GRID_SIZE
	var end_y := rect.end.y + BACKGROUND_GRID_SIZE
	var y := start_y
	while y <= end_y:
		draw_line(Vector2(rect.position.x, y), Vector2(rect.end.x, y), grid_color, 1.0)
		y += BACKGROUND_GRID_SIZE

func _create_layers() -> void:
	enemy_layer = _named_layer("EnemyLayer")
	projectile_layer = _named_layer("ProjectileLayer")
	pickup_layer = _named_layer("PickupLayer")
	vfx_layer = _named_layer("VFXLayer")

func _create_player() -> void:
	player = CharacterBody2D.new()
	player.set_script(PlayerScript)
	player.global_position = Vector2.ZERO
	add_child(player)
	# Keep the infinite-room prototype centered on the player instead of the viewport origin.
	var camera := Camera2D.new()
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 8.0
	player.add_child(camera)
	camera.make_current()

func _create_systems() -> void:
	var spawner := Node.new()
	spawner.set_script(EnemySpawnerScript)
	add_child(spawner)
	spawner.setup(enemy_layer, player)

	var progression := Node.new()
	progression.set_script(ProgressionSystemScript)
	add_child(progression)

	reward_system = Node.new()
	reward_system.set_script(RewardSystemScript)
	add_child(reward_system)

	var skills := Node.new()
	skills.set_script(SkillControllerScript)
	add_child(skills)
	skills.setup(player, enemy_layer, projectile_layer, vfx_layer)

func _named_layer(layer_name: String) -> Node2D:
	var layer := Node2D.new()
	layer.name = layer_name
	add_child(layer)
	return layer

func _on_enemy_died(_enemy: Node, xp_amount: float, death_position: Vector2) -> void:
	var shard := Node2D.new()
	shard.set_script(XpShardScript)
	pickup_layer.add_child(shard)
	shard.setup(death_position, xp_amount, player)
