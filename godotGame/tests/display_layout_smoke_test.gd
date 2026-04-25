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
	var synthesis_panel := ui_root.get_node_or_null("SynthesisPanel") as Control
	if synthesis_panel == null:
		push_error("Display layout smoke failed: SynthesisPanel missing.")
		return false
	if synthesis_panel.anchor_left != 0.5 or synthesis_panel.anchor_top != 0.5 or synthesis_panel.anchor_right != 0.5 or synthesis_panel.anchor_bottom != 0.5:
		push_error("Display layout smoke failed: SynthesisPanel is not center-anchored.")
		return false
	ui_root._open_synthesis_panel()
	if not synthesis_panel.visible:
		push_error("Display layout smoke failed: SynthesisPanel did not open.")
		return false
	if not root.get_node("/root/RunState").is_level_up_paused:
		push_error("Display layout smoke failed: SynthesisPanel should pause combat while open.")
		return false
	if ui_root.synthesis_inventory_grid.get_child_count() < 9:
		push_error("Display layout smoke failed: SynthesisPanel inventory should show debug inventory slots.")
		return false
	if ui_root.synthesis_box_row.get_child_count() != 3:
		push_error("Display layout smoke failed: SynthesisPanel should show 3 synthesis boxes.")
		return false
	if ui_root.synthesis_button.disabled:
		push_error("Display layout smoke failed: debug synthesis button should be unlocked from start.")
		return false
	ui_root._close_synthesis_panel()
	return true

func _check_element_icon_assets(main: Node) -> bool:
	var ui_root = main.ui_root
	var run_state = root.get_node("/root/RunState")
	var content_registry = root.get_node("/root/ContentRegistry")
	for skill_id: StringName in run_state.active_skill_ids:
		var skill = content_registry.get_skill_def(skill_id)
		if skill == null:
			push_error("Display layout smoke failed: missing active skill def %s." % skill_id)
			return false
		var image := Image.load_from_file(skill.icon_path)
		if image == null or image.is_empty():
			push_error("Display layout smoke failed: icon failed to load for %s." % skill_id)
			return false
		if Vector2i(image.get_width(), image.get_height()) != EXPECTED_ICON_SIZE:
			push_error("Display layout smoke failed: icon %s is %sx%s, expected %sx%s." % [skill.icon_path, image.get_width(), image.get_height(), EXPECTED_ICON_SIZE.x, EXPECTED_ICON_SIZE.y])
			return false

	if ui_root.active_slot_row.get_child_count() != 3:
		push_error("Display layout smoke failed: active slot row should show 3 active skills.")
		return false
	if ui_root.element_stats_row.get_child_count() != 3:
		push_error("Display layout smoke failed: element stats row should show fire, ice, and lightning stats.")
		return false
	for stat_label: Node in ui_root.element_stats_row.get_children():
		if "拥有" in (stat_label as Label).text:
			push_error("Display layout smoke failed: HUD stats should not show owned inventory counts.")
			return false

	for slot: Node in ui_root.active_slot_row.get_children():
		var icon := slot.get_child(0) as TextureRect
		if icon == null:
			push_error("Display layout smoke failed: active slot is missing TextureRect.")
			return false
		if icon.custom_minimum_size != Vector2(42.0, 42.0):
			push_error("Display layout smoke failed: HUD icon display size is %s." % icon.custom_minimum_size)
			return false
		if icon.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
			push_error("Display layout smoke failed: HUD icon does not preserve aspect ratio.")
			return false
	return true
