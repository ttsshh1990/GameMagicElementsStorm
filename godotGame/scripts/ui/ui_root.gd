extends CanvasLayer

const HUD_MARGIN := Vector2(18.0, 16.0)
const HUD_SIZE := Vector2(460.0, 168.0)
const MODAL_SIZE := Vector2(420.0, 320.0)
const SYNTHESIS_PANEL_SIZE := Vector2(620.0, 470.0)
const REWARD_BUTTON_SIZE := Vector2(360.0, 68.0)
const ACTIVE_ICON_SIZE := Vector2(42.0, 42.0)
const INVENTORY_SLOT_SIZE := Vector2(96.0, 68.0)

var reward_system: Node
var health_label: Label
var level_label: Label
var xp_bar: ProgressBar
var active_slot_row: HBoxContainer
var element_stats_row: HBoxContainer
var synthesis_button: Button
var modal_panel: PanelContainer
var reward_list: VBoxContainer
var synthesis_panel: PanelContainer
var synthesis_inventory_grid: GridContainer
var synthesis_box_row: HBoxContainer
var synthesis_activation_row: HBoxContainer
var selected_ingredients_label: Label
var synthesis_status_label: Label
var selected_active_slot: int = 0
var selected_synthesis_box: int = 0
var selected_synthesis_elements: Array[StringName] = [&"", &"", &""]

func setup(active_reward_system: Node) -> void:
	reward_system = active_reward_system
	_build_hud()
	_build_level_up_modal()
	_build_synthesis_panel()
	GameEvents.level_up_requested.connect(_on_level_up_requested)
	GameEvents.run_skills_changed.connect(_on_run_skills_changed)

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

	active_slot_row = HBoxContainer.new()
	active_slot_row.custom_minimum_size = Vector2(420.0, 54.0)
	hud.add_child(active_slot_row)

	element_stats_row = HBoxContainer.new()
	element_stats_row.custom_minimum_size = Vector2(420.0, 32.0)
	hud.add_child(element_stats_row)

	synthesis_button = Button.new()
	synthesis_button.text = "元素 / 合成"
	synthesis_button.custom_minimum_size = Vector2(120.0, 30.0)
	synthesis_button.pressed.connect(_open_synthesis_panel)
	hud.add_child(synthesis_button)

	_rebuild_active_slot_row()
	_rebuild_element_stats_row()
	_update_synthesis_button_state()

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

func _build_synthesis_panel() -> void:
	synthesis_panel = PanelContainer.new()
	synthesis_panel.name = "SynthesisPanel"
	synthesis_panel.visible = false
	synthesis_panel.anchor_left = 0.5
	synthesis_panel.anchor_top = 0.5
	synthesis_panel.anchor_right = 0.5
	synthesis_panel.anchor_bottom = 0.5
	synthesis_panel.offset_left = -SYNTHESIS_PANEL_SIZE.x * 0.5
	synthesis_panel.offset_top = -SYNTHESIS_PANEL_SIZE.y * 0.5
	synthesis_panel.offset_right = SYNTHESIS_PANEL_SIZE.x * 0.5
	synthesis_panel.offset_bottom = SYNTHESIS_PANEL_SIZE.y * 0.5
	add_child(synthesis_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 14)
	synthesis_panel.add_child(margin)

	var root := VBoxContainer.new()
	margin.add_child(root)

	var header := HBoxContainer.new()
	root.add_child(header)
	var title := Label.new()
	title.text = "元素 / 合成"
	title.custom_minimum_size = Vector2(480.0, 28.0)
	header.add_child(title)
	var close_button := Button.new()
	close_button.text = "关闭"
	close_button.pressed.connect(_close_synthesis_panel)
	header.add_child(close_button)

	var inventory_title := Label.new()
	inventory_title.text = "元素背包"
	root.add_child(inventory_title)
	synthesis_inventory_grid = GridContainer.new()
	synthesis_inventory_grid.columns = 5
	synthesis_inventory_grid.custom_minimum_size = Vector2(560.0, 154.0)
	root.add_child(synthesis_inventory_grid)

	var synthesis_title := Label.new()
	synthesis_title.text = "合成框"
	root.add_child(synthesis_title)
	synthesis_box_row = HBoxContainer.new()
	synthesis_box_row.custom_minimum_size = Vector2(560.0, 58.0)
	root.add_child(synthesis_box_row)

	var activation_title := Label.new()
	activation_title.text = "替换选中的激活槽"
	root.add_child(activation_title)
	synthesis_activation_row = HBoxContainer.new()
	synthesis_activation_row.custom_minimum_size = Vector2(560.0, 62.0)
	root.add_child(synthesis_activation_row)

	selected_ingredients_label = Label.new()
	selected_ingredients_label.custom_minimum_size = Vector2(560.0, 24.0)
	root.add_child(selected_ingredients_label)

	var ingredient_row := HBoxContainer.new()
	root.add_child(ingredient_row)
	var clear_button := Button.new()
	clear_button.text = "清空"
	clear_button.custom_minimum_size = Vector2(80.0, 36.0)
	clear_button.pressed.connect(_clear_synthesis_selection)
	ingredient_row.add_child(clear_button)
	var synthesize_button := Button.new()
	synthesize_button.name = "SynthesizeButton"
	synthesize_button.text = "合成"
	synthesize_button.custom_minimum_size = Vector2(92.0, 36.0)
	synthesize_button.pressed.connect(_synthesize_selected_elements)
	ingredient_row.add_child(synthesize_button)

	synthesis_status_label = Label.new()
	synthesis_status_label.custom_minimum_size = Vector2(560.0, 42.0)
	root.add_child(synthesis_status_label)

func _update_hud() -> void:
	if health_label == null:
		return
	health_label.text = "生命：%d / %d" % [int(RunState.player_health), int(RunState.player_max_health)]
	level_label.text = "等级：%d    时间：%02d:%02d" % [RunState.player_level, int(RunState.run_time) / 60, int(RunState.run_time) % 60]
	xp_bar.max_value = RunState.xp_to_next_level
	xp_bar.value = RunState.player_xp
	_update_synthesis_button_state()

func _rebuild_active_slot_row() -> void:
	for child: Node in active_slot_row.get_children():
		child.queue_free()
	for skill_id: StringName in RunState.active_skill_ids:
		var skill = ContentRegistry.get_skill_def(skill_id)
		if skill == null:
			continue
		var slot := HBoxContainer.new()
		slot.custom_minimum_size = Vector2(132.0, 50.0)
		var icon := TextureRect.new()
		icon.custom_minimum_size = ACTIVE_ICON_SIZE
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture = _load_png_texture(skill.icon_path)
		slot.add_child(icon)
		var label := Label.new()
		label.text = skill.display_name
		slot.add_child(label)
		active_slot_row.add_child(slot)

func _rebuild_element_stats_row() -> void:
	for child: Node in element_stats_row.get_children():
		child.queue_free()
	for element_id: StringName in [&"fire", &"ice", &"lightning"]:
		var element = ContentRegistry.get_element_def(element_id)
		if element == null:
			continue
		var label := Label.new()
		label.custom_minimum_size = Vector2(148.0, 24.0)
		label.text = "%s Lv.%d 激活x%d" % [element.display_name, RunState.get_element_level(element_id), RunState.get_active_element_count(element_id)]
		element_stats_row.add_child(label)

func _on_level_up_requested(_level: int) -> void:
	_show_reward_choices()

func _on_run_skills_changed() -> void:
	_rebuild_active_slot_row()
	_rebuild_element_stats_row()
	if synthesis_panel != null and synthesis_panel.visible:
		_rebuild_synthesis_panel()

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
	_rebuild_active_slot_row()
	_rebuild_element_stats_row()
	if synthesis_panel != null and synthesis_panel.visible:
		_rebuild_synthesis_panel()

func _open_synthesis_panel() -> void:
	if not RunState.is_synthesis_unlocked():
		return
	selected_active_slot = clampi(selected_active_slot, 0, max(0, RunState.active_skill_ids.size() - 1))
	_rebuild_synthesis_panel()
	synthesis_panel.visible = true
	RunState.is_level_up_paused = true
	GameEvents.emit_run_state_changed()

func _close_synthesis_panel() -> void:
	synthesis_panel.visible = false
	if not modal_panel.visible:
		RunState.is_level_up_paused = false
	GameEvents.emit_run_state_changed()

func _rebuild_synthesis_panel() -> void:
	_rebuild_synthesis_inventory()
	_rebuild_synthesis_boxes()
	_rebuild_synthesis_activation_choices()
	_update_synthesis_selection_text()

func _rebuild_synthesis_inventory() -> void:
	for child: Node in synthesis_inventory_grid.get_children():
		child.queue_free()
	for entry: Dictionary in _get_inventory_entries():
		var button := Button.new()
		button.custom_minimum_size = INVENTORY_SLOT_SIZE
		button.text = _format_inventory_entry(entry)
		if bool(entry.get("active", false)):
			button.add_theme_color_override("font_color", Color(1.0, 0.92, 0.35))
			button.add_theme_color_override("font_pressed_color", Color(1.0, 0.92, 0.35))
			button.add_theme_color_override("font_hover_color", Color(1.0, 0.95, 0.55))
		button.pressed.connect(_select_inventory_entry.bind(entry))
		synthesis_inventory_grid.add_child(button)

func _rebuild_synthesis_boxes() -> void:
	for child: Node in synthesis_box_row.get_children():
		child.queue_free()
	for index in range(3):
		var button := Button.new()
		var element_id := selected_synthesis_elements[index]
		var element = ContentRegistry.get_element_def(element_id) if element_id != &"" else null
		var marker := "选中\n" if index == selected_synthesis_box else ""
		var name: String = element.display_name if element != null else "空"
		button.text = "%s合成框 %d\n%s" % [marker, index + 1, name]
		button.custom_minimum_size = Vector2(132.0, 52.0)
		button.pressed.connect(_select_synthesis_box.bind(index))
		synthesis_box_row.add_child(button)

func _rebuild_synthesis_activation_choices() -> void:
	for child: Node in synthesis_activation_row.get_children():
		child.queue_free()
	for index in range(RunState.active_skill_ids.size()):
		var button := Button.new()
		var marker := "*" if index == selected_active_slot else ""
		button.text = "%s槽%d" % [marker, index + 1]
		button.custom_minimum_size = Vector2(54.0, 44.0)
		button.pressed.connect(_select_active_slot.bind(index))
		synthesis_activation_row.add_child(button)
	for skill_id: StringName in RunState.get_activation_skill_ids():
		var skill = ContentRegistry.get_skill_def(skill_id)
		if skill == null:
			continue
		var button := Button.new()
		button.text = skill.display_name
		button.custom_minimum_size = Vector2(120.0, 44.0)
		button.disabled = not RunState.can_activate_skill_in_slot(selected_active_slot, skill_id)
		button.pressed.connect(_activate_selected_slot.bind(skill_id))
		synthesis_activation_row.add_child(button)

func _select_active_slot(index: int) -> void:
	selected_active_slot = index
	_rebuild_synthesis_panel()

func _select_synthesis_box(index: int) -> void:
	selected_synthesis_box = index
	_rebuild_synthesis_panel()

func _select_inventory_entry(entry: Dictionary) -> void:
	var element_id := StringName(entry.get("element_id", &""))
	if element_id == &"":
		synthesis_status_label.text = "这个元素暂时不能放入基础合成框。"
		return
	selected_synthesis_elements[selected_synthesis_box] = element_id
	synthesis_status_label.text = ""
	_rebuild_synthesis_panel()

func _activate_selected_slot(skill_id: StringName) -> void:
	if RunState.set_active_skill(selected_active_slot, skill_id):
		synthesis_status_label.text = "已替换激活槽。"
	else:
		synthesis_status_label.text = "当前库存不足，不能替换为这个元素。"
	_rebuild_synthesis_panel()

func _clear_synthesis_selection() -> void:
	selected_synthesis_elements = [&"", &"", &""]
	synthesis_status_label.text = ""
	_rebuild_synthesis_panel()

func _synthesize_selected_elements() -> void:
	if selected_synthesis_elements.has(&""):
		synthesis_status_label.text = "需要选择 3 个元素。"
		return
	if not _has_sufficient_selected_elements():
		synthesis_status_label.text = "合成框中的元素数量超过当前库存。"
		return
	if RunState.synthesize_elements(selected_synthesis_elements):
		selected_synthesis_elements = [&"", &"", &""]
		synthesis_status_label.text = "合成成功。"
	else:
		synthesis_status_label.text = "当前组合没有可用配方，或合成尚未解锁。"
	_rebuild_synthesis_panel()

func _update_synthesis_selection_text() -> void:
	var names: Array[String] = []
	for element_id: StringName in selected_synthesis_elements:
		if element_id == &"":
			names.append("空")
			continue
		var element = ContentRegistry.get_element_def(element_id)
		names.append(element.display_name if element != null else str(element_id))
	selected_ingredients_label.text = "已选：%s" % "、".join(names)
	var synthesize_button = synthesis_panel.find_child("SynthesizeButton", true, false) as Button
	if synthesize_button != null:
		synthesize_button.disabled = selected_synthesis_elements.has(&"") or not _has_sufficient_selected_elements()

func _count_selected_synthesis_element(element_id: StringName) -> int:
	var count := 0
	for selected_element_id: StringName in selected_synthesis_elements:
		if selected_element_id == element_id:
			count += 1
	return count

func _has_sufficient_selected_elements() -> bool:
	for element_id: StringName in [&"fire", &"ice", &"lightning"]:
		if _count_selected_synthesis_element(element_id) > RunState.get_owned_element_count(element_id):
			return false
	return true

func _update_synthesis_button_state() -> void:
	if synthesis_button == null:
		return
	var unlocked := RunState.is_synthesis_unlocked()
	synthesis_button.disabled = not unlocked
	synthesis_button.modulate = Color.WHITE if unlocked else Color(0.08, 0.08, 0.08, 1.0)

func _get_inventory_entries() -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	var remaining_counts := _get_owned_base_counts()
	for slot_index in range(RunState.active_skill_ids.size()):
		var skill = ContentRegistry.get_skill_def(RunState.active_skill_ids[slot_index])
		if skill == null:
			continue
		var entry := {
			"label": skill.display_name,
			"active": true,
			"active_slot": slot_index,
			"skill_id": skill.id,
			"element_id": _get_basic_element_id_for_skill(skill),
		}
		entries.append(entry)
		var element_id: StringName = entry["element_id"]
		if element_id != &"":
			remaining_counts[element_id] = maxi(0, int(remaining_counts.get(element_id, 0)) - 1)
	for element_id: StringName in [&"fire", &"ice", &"lightning"]:
		var count := int(remaining_counts.get(element_id, 0))
		var element = ContentRegistry.get_element_def(element_id)
		for _index in range(count):
			entries.append({
				"label": element.display_name if element != null else str(element_id),
				"active": false,
				"active_slot": -1,
				"skill_id": &"",
				"element_id": element_id,
			})
	var active_skill_counts := {}
	for skill_id: StringName in RunState.active_skill_ids:
		active_skill_counts[skill_id] = int(active_skill_counts.get(skill_id, 0)) + 1
	for skill_id: StringName in RunState.synthesized_skill_ids:
		var active_count := int(active_skill_counts.get(skill_id, 0))
		if active_count > 0:
			active_skill_counts[skill_id] = active_count - 1
			continue
		var skill = ContentRegistry.get_skill_def(skill_id)
		entries.append({
			"label": skill.display_name if skill != null else str(skill_id),
			"active": false,
			"active_slot": -1,
			"skill_id": skill_id,
			"element_id": &"",
		})
	return entries

func _format_inventory_entry(entry: Dictionary) -> String:
	var active_slot := int(entry.get("active_slot", -1))
	var prefix := "激活%d\n" % (active_slot + 1) if active_slot >= 0 else ""
	return "%s%s" % [prefix, str(entry.get("label", ""))]

func _get_owned_base_counts() -> Dictionary:
	var counts := {
		&"fire": 0,
		&"ice": 0,
		&"lightning": 0,
	}
	for element_id: StringName in RunState.element_slots:
		counts[element_id] = int(counts.get(element_id, 0)) + 1
	return counts

func _get_basic_element_id_for_skill(skill) -> StringName:
	if skill == null or skill.quality != &"basic" or skill.element_ids.is_empty():
		return &""
	return skill.element_ids[0]

func _load_png_texture(path: String) -> Texture2D:
	var image := Image.load_from_file(path)
	if image == null or image.is_empty():
		return null
	return ImageTexture.create_from_image(image)
