extends CanvasLayer

const HUD_MARGIN := Vector2(18.0, 16.0)
const HUD_SIZE := Vector2(330.0, 120.0)
const MODAL_SIZE := Vector2(420.0, 320.0)
const REWARD_BUTTON_SIZE := Vector2(360.0, 68.0)
const ELEMENT_ICON_SIZE := Vector2(34.0, 34.0)

var reward_system: Node
var health_label: Label
var level_label: Label
var xp_bar: ProgressBar
var element_row: HBoxContainer
var modal_panel: PanelContainer
var reward_list: VBoxContainer

func setup(active_reward_system: Node) -> void:
	reward_system = active_reward_system
	_build_hud()
	_build_level_up_modal()
	GameEvents.level_up_requested.connect(_on_level_up_requested)

func _process(_delta: float) -> void:
	_update_hud()

func _build_hud() -> void:
	var hud := VBoxContainer.new()
	hud.name = "HUD"
	# HUD is anchored to the top-left of the 1280x720 landscape canvas.
	hud.anchor_left = 0.0
	hud.anchor_top = 0.0
	hud.anchor_right = 0.0
	hud.anchor_bottom = 0.0
	hud.offset_left = HUD_MARGIN.x
	hud.offset_top = HUD_MARGIN.y
	hud.offset_right = HUD_MARGIN.x + HUD_SIZE.x
	hud.offset_bottom = HUD_MARGIN.y + HUD_SIZE.y
	add_child(hud)

	health_label = Label.new()
	hud.add_child(health_label)

	level_label = Label.new()
	hud.add_child(level_label)

	xp_bar = ProgressBar.new()
	xp_bar.custom_minimum_size = Vector2(300.0, 18.0)
	xp_bar.show_percentage = false
	hud.add_child(xp_bar)

	element_row = HBoxContainer.new()
	element_row.custom_minimum_size = Vector2(300.0, 48.0)
	hud.add_child(element_row)
	_rebuild_element_row()

func _build_level_up_modal() -> void:
	modal_panel = PanelContainer.new()
	modal_panel.name = "LevelUpModal"
	modal_panel.visible = false
	# Keep reward choices centered across desktop, tablet, and phone landscape viewports.
	modal_panel.anchor_left = 0.5
	modal_panel.anchor_top = 0.5
	modal_panel.anchor_right = 0.5
	modal_panel.anchor_bottom = 0.5
	modal_panel.offset_left = -MODAL_SIZE.x * 0.5
	modal_panel.offset_top = -MODAL_SIZE.y * 0.5
	modal_panel.offset_right = MODAL_SIZE.x * 0.5
	modal_panel.offset_bottom = MODAL_SIZE.y * 0.5
	add_child(modal_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	modal_panel.add_child(margin)

	reward_list = VBoxContainer.new()
	margin.add_child(reward_list)

	var title := Label.new()
	title.text = "升级奖励"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reward_list.add_child(title)

func _update_hud() -> void:
	if health_label == null:
		return
	health_label.text = "生命：%d / %d" % [int(RunState.player_health), int(RunState.player_max_health)]
	level_label.text = "等级：%d    时间：%02d:%02d" % [RunState.player_level, int(RunState.run_time) / 60, int(RunState.run_time) % 60]
	xp_bar.max_value = RunState.xp_to_next_level
	xp_bar.value = RunState.player_xp

func _rebuild_element_row() -> void:
	for child: Node in element_row.get_children():
		child.queue_free()
	for element_id: StringName in RunState.element_slots:
		var element = ContentRegistry.get_element_def(element_id)
		if element == null:
			continue
		var slot := HBoxContainer.new()
		slot.custom_minimum_size = Vector2(92.0, 42.0)
		var icon := TextureRect.new()
		icon.custom_minimum_size = ELEMENT_ICON_SIZE
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture = _load_png_texture(element.icon_path)
		slot.add_child(icon)
		var label := Label.new()
		label.text = "%s Lv.%d" % [element.display_name, RunState.get_element_level(element_id)]
		slot.add_child(label)
		element_row.add_child(slot)

func _on_level_up_requested(_level: int) -> void:
	_show_reward_choices()

func _show_reward_choices() -> void:
	for index in range(reward_list.get_child_count() - 1, 0, -1):
		reward_list.get_child(index).queue_free()
	var rewards: Array = reward_system.generate_level_up_rewards()
	for reward in rewards:
		var button := Button.new()
		button.text = "%s\n%s" % [reward.display_name, reward.description]
		button.custom_minimum_size = REWARD_BUTTON_SIZE
		button.pressed.connect(_select_reward.bind(reward))
		reward_list.add_child(button)
	modal_panel.visible = true

func _select_reward(reward) -> void:
	reward_system.apply_reward(reward)
	modal_panel.visible = false
	_rebuild_element_row()

func _load_png_texture(path: String) -> Texture2D:
	var image := Image.load_from_file(path)
	if image == null or image.is_empty():
		return null
	return ImageTexture.create_from_image(image)
