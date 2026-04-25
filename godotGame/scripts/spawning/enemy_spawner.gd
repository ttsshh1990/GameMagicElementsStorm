extends Node

const EnemyScene := preload("res://scripts/enemies/enemy.gd")

var enemy_layer: Node
var player: Node2D
var spawn_accumulator: float = 0.0
var rng := RandomNumberGenerator.new()

func setup(target_layer: Node, target_player: Node2D) -> void:
	enemy_layer = target_layer
	player = target_player
	rng.randomize()

func _process(delta: float) -> void:
	if RunState.is_level_up_paused or enemy_layer == null or player == null:
		return
	var balance = ContentRegistry.get_balance_config()
	var minutes := RunState.run_time / 60.0
	var spawn_rate: float = balance.spawn_rate_base * (1.0 + 0.12 * minutes + 0.03 * float(RunState.player_level - 1))
	var max_alive := mini(balance.max_alive_cap, balance.max_alive_base + int(floor(2.5 * minutes)) + int(floor(1.5 * float(RunState.player_level - 1))))
	if enemy_layer.get_child_count() >= max_alive:
		return
	spawn_accumulator += spawn_rate * delta
	while spawn_accumulator >= 1.0 and enemy_layer.get_child_count() < max_alive:
		spawn_accumulator -= 1.0
		_spawn_enemy()

func _spawn_enemy() -> void:
	var enemy_def = _choose_enemy_def()
	var enemy := CharacterBody2D.new()
	enemy.set_script(EnemyScene)
	enemy.global_position = _random_spawn_position()
	enemy_layer.add_child(enemy)
	enemy.setup(enemy_def, player)

func _choose_enemy_def():
	var roll := rng.randf()
	if RunState.run_time > 75.0 and roll > 0.86:
		return ContentRegistry.get_enemy_def(&"tank")
	if RunState.run_time > 35.0 and roll > 0.68:
		return ContentRegistry.get_enemy_def(&"fast")
	return ContentRegistry.get_enemy_def(&"chaser")

func _random_spawn_position() -> Vector2:
	var angle := rng.randf_range(0.0, TAU)
	var distance := rng.randf_range(430.0, 620.0)
	return player.global_position + Vector2.RIGHT.rotated(angle) * distance
