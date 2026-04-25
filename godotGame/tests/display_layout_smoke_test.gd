extends SceneTree

const EXPECTED_VIEWPORT := Vector2i(1280, 720)
const EXPECTED_ICON_SIZE := Vector2i(512, 512)

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	if not _check_project_display_settings():
		quit(1)
		return

	var scene := load("res://scenes/main/main.tscn")
	var main: Node = scene.instantiate()
	root.add_child(main)
	await process_frame

	if not _check_ui_layout(main):
		quit(1)
		return
	if not _check_element_icon_assets(main):
		quit(1)
		return

	print("Display layout smoke passed: 1280x720 landscape settings, responsive UI anchors, and icon assets are valid.")
	quit(0)

func _check_project_display_settings() -> bool:
	var width := int(ProjectSettings.get_setting("display/window/size/viewport_width"))
	var height := int(ProjectSettings.get_setting("display/window/size/viewport_height"))
	var stretch_mode := str(ProjectSettings.get_setting("display/window/stretch/mode"))
	var stretch_aspect := str(ProjectSettings.get_setting("display/window/stretch/aspect"))
	if Vector2i(width, height) != EXPECTED_VIEWPORT:
		push_error("Display layout smoke failed: viewport is %sx%s, expected %sx%s." % [width, height, EXPECTED_VIEWPORT.x, EXPECTED_VIEWPORT.y])
		return false
	if stretch_mode != "canvas_items":
		push_error("Display layout smoke failed: stretch mode is %s, expected canvas_items." % stretch_mode)
		return false
	if stretch_aspect != "expand":
		push_error("Display layout smoke failed: stretch aspect is %s, expected expand." % stretch_aspect)
		return false
	return true

func _check_ui_layout(main: Node) -> bool:
	var ui_root = main.ui_root
	if ui_root == null:
		push_error("Display layout smoke failed: UIRoot missing.")
		return false
	var hud := ui_root.get_node_or_null("HUD") as Control
	var modal := ui_root.get_node_or_null("LevelUpModal") as Control
	if hud == null or modal == null:
		push_error("Display layout smoke failed: HUD or LevelUpModal missing.")
		return false
	if hud.anchor_left != 0.0 or hud.anchor_top != 0.0:
		push_error("Display layout smoke failed: HUD is not anchored to top-left.")
		return false
	if modal.anchor_left != 0.5 or modal.anchor_top != 0.5 or modal.anchor_right != 0.5 or modal.anchor_bottom != 0.5:
		push_error("Display layout smoke failed: LevelUpModal is not center-anchored.")
		return false
	if modal.size != Vector2(420.0, 320.0):
		push_error("Display layout smoke failed: LevelUpModal size is %s." % modal.size)
		return false
	return true

func _check_element_icon_assets(main: Node) -> bool:
	var ui_root = main.ui_root
	var run_state = root.get_node("/root/RunState")
	var content_registry = root.get_node("/root/ContentRegistry")
	for element_id: StringName in run_state.element_slots:
		var element = content_registry.get_element_def(element_id)
		if element == null:
			push_error("Display layout smoke failed: missing element def %s." % element_id)
			return false
		var image := Image.load_from_file(element.icon_path)
		if image == null or image.is_empty():
			push_error("Display layout smoke failed: icon failed to load for %s." % element_id)
			return false
		if Vector2i(image.get_width(), image.get_height()) != EXPECTED_ICON_SIZE:
			push_error("Display layout smoke failed: icon %s is %sx%s, expected %sx%s." % [element.icon_path, image.get_width(), image.get_height(), EXPECTED_ICON_SIZE.x, EXPECTED_ICON_SIZE.y])
			return false

	for slot: Node in ui_root.element_row.get_children():
		var icon := slot.get_child(0) as TextureRect
		if icon == null:
			push_error("Display layout smoke failed: element slot is missing TextureRect.")
			return false
		if icon.custom_minimum_size != Vector2(34.0, 34.0):
			push_error("Display layout smoke failed: HUD icon display size is %s." % icon.custom_minimum_size)
			return false
		if icon.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
			push_error("Display layout smoke failed: HUD icon does not preserve aspect ratio.")
			return false
	return true
