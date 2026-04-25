class_name VisualAsset
extends RefCounted

const SPRITE_NODE_NAME := "VisualSprite"
const ANIMATED_NODE_NAME := "VisualAnimation"
const DEFAULT_ANIMATION := &"default"

static func load_texture(path: String) -> Texture2D:
	if path.is_empty() or not path.begins_with("res://"):
		return null
	if ResourceLoader.exists(path):
		var resource := load(path)
		if resource is Texture2D:
			return resource
	if not FileAccess.file_exists(path):
		return null
	var image := Image.load_from_file(path)
	if image == null or image.is_empty():
		return null
	return ImageTexture.create_from_image(image)

static func create_sprite(path: String, target_world_size: float) -> Sprite2D:
	var texture := load_texture(path)
	if texture == null:
		return null
	var sprite := Sprite2D.new()
	sprite.name = SPRITE_NODE_NAME
	sprite.texture = texture
	sprite.centered = true
	# Art source files can be larger than their in-world footprint; scale by the longest side.
	var max_side := maxf(float(texture.get_width()), float(texture.get_height()))
	if max_side > 0.0 and target_world_size > 0.0:
		sprite.scale = Vector2.ONE * (target_world_size / max_side)
	return sprite

static func create_animated_sprite(frames_dir: String, target_world_size: float, fps: float, loop: bool = true) -> AnimatedSprite2D:
	var textures := load_frame_sequence(frames_dir)
	if textures.is_empty():
		return null
	var sprite_frames := SpriteFrames.new()
	if not sprite_frames.has_animation(DEFAULT_ANIMATION):
		sprite_frames.add_animation(DEFAULT_ANIMATION)
	else:
		sprite_frames.clear(DEFAULT_ANIMATION)
	sprite_frames.set_animation_speed(DEFAULT_ANIMATION, fps)
	sprite_frames.set_animation_loop(DEFAULT_ANIMATION, loop)
	for texture: Texture2D in textures:
		sprite_frames.add_frame(DEFAULT_ANIMATION, texture)

	var animated := AnimatedSprite2D.new()
	animated.name = ANIMATED_NODE_NAME
	animated.sprite_frames = sprite_frames
	animated.animation = DEFAULT_ANIMATION
	animated.centered = true
	_scale_canvas_item_to_world_size(animated, textures[0], target_world_size)
	animated.play(DEFAULT_ANIMATION)
	return animated

static func create_visual_node(frames_dir: String, static_path: String, target_world_size: float, fps: float, loop: bool = true) -> Node2D:
	var animated := create_animated_sprite(frames_dir, target_world_size, fps, loop)
	if animated != null:
		return animated
	return create_sprite(static_path, target_world_size)

static func load_frame_sequence(frames_dir: String) -> Array[Texture2D]:
	var textures: Array[Texture2D] = []
	if frames_dir.is_empty() or not frames_dir.begins_with("res://"):
		return textures
	var dir := DirAccess.open(frames_dir)
	if dir == null:
		return textures
	var file_names: Array[String] = []
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while not file_name.is_empty():
		if not dir.current_is_dir() and file_name.get_extension().to_lower() == "png":
			file_names.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	file_names.sort()
	for sorted_file_name: String in file_names:
		var texture := load_texture(frames_dir.path_join(sorted_file_name))
		if texture != null:
			textures.append(texture)
	return textures

static func _scale_canvas_item_to_world_size(node: Node2D, texture: Texture2D, target_world_size: float) -> void:
	var max_side := maxf(float(texture.get_width()), float(texture.get_height()))
	if max_side > 0.0 and target_world_size > 0.0:
		node.scale = Vector2.ONE * (target_world_size / max_side)
