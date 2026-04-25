extends Node2D

const VisualAssetScript := preload("res://scripts/visuals/visual_asset.gd")

var points: PackedVector2Array = []
var skill
var age: float = 0.0
var duration: float = 0.16
var visual_segments: Array[Node2D] = []

func setup(world_points: Array[Vector2], skill_def = null) -> void:
	points = PackedVector2Array(world_points)
	skill = skill_def
	_create_visual_segments()

func _process(delta: float) -> void:
	age += delta
	if age >= duration:
		queue_free()
	queue_redraw()

func _draw() -> void:
	if points.size() < 2 or not visual_segments.is_empty():
		return
	var alpha := maxf(0.0, 1.0 - age / duration)
	for index in range(points.size() - 1):
		draw_line(to_local(points[index]), to_local(points[index + 1]), Color(0.95, 0.85, 0.25, alpha), 5.0)
		draw_line(to_local(points[index]), to_local(points[index + 1]), Color(0.55, 0.35, 1.0, alpha), 2.0)

func _create_visual_segments() -> void:
	if skill == null or points.size() < 2:
		return
	for index in range(points.size() - 1):
		var from_point := points[index]
		var to_point := points[index + 1]
		var segment_length := from_point.distance_to(to_point)
		var visual := VisualAssetScript.create_visual_node(skill.vfx_frames_dir, skill.vfx_path, segment_length, skill.vfx_fps, skill.vfx_loop)
		if visual == null:
			continue
		visual.global_position = (from_point + to_point) * 0.5
		visual.rotation = from_point.angle_to_point(to_point)
		add_child(visual)
		visual_segments.append(visual)
	_extend_duration_for_animation()

func _extend_duration_for_animation() -> void:
	if skill == null or skill.vfx_loop or visual_segments.is_empty():
		return
	var animated := visual_segments[0] as AnimatedSprite2D
	if animated == null:
		return
	var sprite_frames := animated.sprite_frames
	var frame_count := sprite_frames.get_frame_count(VisualAssetScript.DEFAULT_ANIMATION)
	var fps := sprite_frames.get_animation_speed(VisualAssetScript.DEFAULT_ANIMATION)
	if frame_count > 0 and fps > 0.0:
		duration = maxf(duration, float(frame_count) / fps)
