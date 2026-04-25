extends Node2D

const VisualAssetScript := preload("res://scripts/visuals/visual_asset.gd")

var skill
var enemy_layer: Node
var damage: float = 0.0
var radius: float = 80.0
var duration: float = 0.35
var age: float = 0.0
var color: Color = Color(0.4, 0.85, 1.0, 0.36)
var visual_node: Node2D
var _has_applied_damage := false

func setup(effect_position: Vector2, skill_def, hit_damage: float, enemies: Node) -> void:
	global_position = effect_position
	skill = skill_def
	damage = hit_damage
	enemy_layer = enemies
	radius = skill.radius
	visual_node = VisualAssetScript.create_visual_node(skill.vfx_frames_dir, skill.vfx_path, radius * 2.0, skill.vfx_fps, skill.vfx_loop)
	if visual_node != null:
		add_child(visual_node)
		_extend_duration_for_animation()

func _process(delta: float) -> void:
	if RunState.is_level_up_paused:
		return
	if not _has_applied_damage:
		_apply_damage_once()
		_has_applied_damage = true
	age += delta
	if age >= duration:
		queue_free()
	queue_redraw()

func _draw() -> void:
	if visual_node != null:
		return
	var alpha := maxf(0.0, 1.0 - age / duration)
	draw_circle(Vector2.ZERO, radius, Color(color.r, color.g, color.b, color.a * alpha))
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 48, Color(0.8, 0.95, 1.0, alpha), 4.0)

func _apply_damage_once() -> void:
	if enemy_layer == null:
		return
	for enemy: Node in enemy_layer.get_children():
		if not enemy is Node2D:
			continue
		if global_position.distance_to((enemy as Node2D).global_position) <= radius:
			DamageSystem.apply_damage(enemy, damage, skill.effect_type, skill.effect_duration)

func _extend_duration_for_animation() -> void:
	if skill == null or skill.vfx_loop or not visual_node is AnimatedSprite2D:
		return
	var animated := visual_node as AnimatedSprite2D
	var sprite_frames := animated.sprite_frames
	var frame_count := sprite_frames.get_frame_count(VisualAssetScript.DEFAULT_ANIMATION)
	var fps := sprite_frames.get_animation_speed(VisualAssetScript.DEFAULT_ANIMATION)
	if frame_count > 0 and fps > 0.0:
		duration = maxf(duration, float(frame_count) / fps)
