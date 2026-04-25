extends Node2D

const VisualAssetScript := preload("res://scripts/visuals/visual_asset.gd")

var skill
var enemy_layer: Node
var damage: float = 0.0
var radius: float = 80.0
var fall_duration: float = 0.45
var fall_age: float = 0.0
var impact_duration: float = 0.35
var impact_age: float = 0.0
var start_offset: Vector2 = Vector2(-240.0, -300.0)
var fall_visual: Node2D
var impact_visual: Node2D
var has_impacted := false

func setup(effect_position: Vector2, skill_def, hit_damage: float, enemies: Node) -> void:
	global_position = effect_position
	skill = skill_def
	damage = hit_damage
	enemy_layer = enemies
	radius = skill.radius
	fall_duration = maxf(0.05, skill.cast_intro_duration)
	start_offset = skill.cast_intro_start_offset
	fall_visual = VisualAssetScript.create_visual_node(skill.cast_intro_frames_dir, skill.cast_intro_path, skill.cast_intro_world_size, skill.cast_intro_fps, skill.cast_intro_loop)
	if fall_visual != null:
		fall_visual.position = start_offset
		add_child(fall_visual)
	else:
		_start_impact()

func _process(delta: float) -> void:
	if _is_run_paused():
		return
	if not has_impacted:
		_update_fall(delta)
		return
	impact_age += delta
	if impact_age >= impact_duration:
		queue_free()
	queue_redraw()

func _draw() -> void:
	if not has_impacted or impact_visual != null:
		return
	var alpha := maxf(0.0, 1.0 - impact_age / impact_duration)
	draw_circle(Vector2.ZERO, radius, Color(1.0, 0.35, 0.1, 0.32 * alpha))
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 48, Color(1.0, 0.82, 0.25, alpha), 4.0)

func _update_fall(delta: float) -> void:
	fall_age += delta
	var progress := clampf(fall_age / fall_duration, 0.0, 1.0)
	var eased_progress := 1.0 - pow(1.0 - progress, 2.0)
	if fall_visual != null:
		fall_visual.position = start_offset.lerp(Vector2.ZERO, eased_progress)
	if progress >= 1.0:
		_start_impact()

func _start_impact() -> void:
	has_impacted = true
	impact_age = 0.0
	if fall_visual != null:
		fall_visual.queue_free()
		fall_visual = null
	_apply_damage_once()
	impact_visual = VisualAssetScript.create_visual_node(skill.vfx_frames_dir, skill.vfx_path, radius * 2.0, skill.vfx_fps, skill.vfx_loop)
	if impact_visual != null:
		add_child(impact_visual)
		_extend_impact_duration_for_animation()
	queue_redraw()

func _apply_damage_once() -> void:
	if enemy_layer == null:
		return
	for enemy: Node in enemy_layer.get_children():
		if not enemy is Node2D:
			continue
		if global_position.distance_to((enemy as Node2D).global_position) <= radius:
			_apply_damage(enemy)

func _extend_impact_duration_for_animation() -> void:
	if skill == null or skill.vfx_loop or not impact_visual is AnimatedSprite2D:
		return
	var animated := impact_visual as AnimatedSprite2D
	var sprite_frames := animated.sprite_frames
	var frame_count := sprite_frames.get_frame_count(VisualAssetScript.DEFAULT_ANIMATION)
	var fps := sprite_frames.get_animation_speed(VisualAssetScript.DEFAULT_ANIMATION)
	if frame_count > 0 and fps > 0.0:
		impact_duration = maxf(impact_duration, float(frame_count) / fps)

func _is_run_paused() -> bool:
	var run_state = get_node_or_null("/root/RunState")
	return run_state != null and run_state.is_level_up_paused

func _apply_damage(enemy: Node) -> void:
	var damage_system = get_node_or_null("/root/DamageSystem")
	if damage_system != null:
		damage_system.apply_damage(enemy, damage, skill.effect_type, skill.effect_duration)
		return
	if enemy != null and enemy.has_method("take_damage"):
		enemy.take_damage(damage)
