extends Node2D

const VisualAssetScript := preload("res://scripts/visuals/visual_asset.gd")

var velocity: Vector2 = Vector2.ZERO
var damage: float = 0.0
var skill
var enemy_layer: Node
var lifetime: float = 2.0
var radius: float = 8.0
var color: Color = Color(1.0, 0.35, 0.1)
var visual_node: Node2D

func setup(start_position: Vector2, direction: Vector2, skill_def, hit_damage: float, enemies: Node) -> void:
	global_position = start_position
	skill = skill_def
	damage = hit_damage
	enemy_layer = enemies
	velocity = direction.normalized() * skill.projectile_speed
	visual_node = VisualAssetScript.create_visual_node(skill.vfx_frames_dir, skill.vfx_path, radius * 2.0, skill.vfx_fps, skill.vfx_loop)
	if visual_node != null:
		add_child(visual_node)

func _process(delta: float) -> void:
	if RunState.is_level_up_paused:
		return
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
		return
	global_position += velocity * delta
	_check_hits()

func _draw() -> void:
	if visual_node != null:
		return
	draw_circle(Vector2.ZERO, radius, color)
	draw_circle(Vector2.ZERO, radius * 0.55, Color(1.0, 0.85, 0.35))

func _check_hits() -> void:
	if enemy_layer == null:
		return
	for enemy: Node in enemy_layer.get_children():
		if not enemy is Node2D:
			continue
		if global_position.distance_to((enemy as Node2D).global_position) <= radius + 18.0:
			DamageSystem.apply_damage(enemy, damage, skill.effect_type, skill.effect_duration)
			queue_free()
			return
