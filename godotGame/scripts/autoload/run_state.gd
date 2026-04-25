extends Node

const SynthesisService := preload("res://scripts/synthesis/synthesis_service.gd")

var run_time: float = 0.0
var player_level: int = 1
var player_xp: float = 0.0
var xp_to_next_level: float = 20.0
var player_health: float = 100.0
var player_max_health: float = 100.0
var is_level_up_paused: bool = false
var element_slots: Array[StringName] = [&"fire", &"ice", &"lightning"]
var active_skill_ids: Array[StringName] = [&"fireball", &"ice_nova", &"lightning_chain"]
var synthesized_skill_ids: Array[StringName] = []
var element_levels: Dictionary = {}

func _ready() -> void:
	reset_run()

func reset_run() -> void:
	run_time = 0.0
	player_level = 1
	player_xp = 0.0
	player_max_health = 100.0
	player_health = player_max_health
	is_level_up_paused = false
	element_slots = _get_initial_element_slots()
	active_skill_ids = [&"fireball", &"ice_nova", &"lightning_chain"]
	synthesized_skill_ids = []
	element_levels = {
		&"fire": 1,
		&"ice": 1,
		&"lightning": 1,
	}
	_refresh_xp_to_next_level()
	if has_node("/root/GameEvents"):
		GameEvents.emit_run_state_changed()

func advance_time(delta: float) -> void:
	if is_level_up_paused:
		return
	run_time += delta
	GameEvents.emit_run_state_changed()

func add_xp(amount: float) -> void:
	if amount <= 0.0:
		return
	player_xp += amount
	while player_xp >= xp_to_next_level:
		player_xp -= xp_to_next_level
		player_level += 1
		_refresh_xp_to_next_level()
		is_level_up_paused = true
		GameEvents.level_up_requested.emit(player_level)
	GameEvents.emit_run_state_changed()

func damage_player(amount: float) -> void:
	if amount <= 0.0 or is_level_up_paused:
		return
	var min_health := 1.0 if DebugSettings.lock_player_health_to_one else 0.0
	player_health = maxf(min_health, player_health - amount)
	GameEvents.player_damaged.emit(player_health, player_max_health)
	GameEvents.emit_run_state_changed()

func apply_reward(reward) -> void:
	if reward == null:
		return
	if reward.reward_type == &"element_upgrade":
		var current_level := int(element_levels.get(reward.element_id, 1))
		element_levels[reward.element_id] = current_level + 1
	elif reward.reward_type == &"element_gain":
		element_slots.append(reward.element_id)
		if not element_levels.has(reward.element_id):
			element_levels[reward.element_id] = 1
	GameEvents.reward_selected.emit(reward.id)
	if reward.reward_type == &"element_gain":
		GameEvents.run_skills_changed.emit()
	is_level_up_paused = false
	GameEvents.emit_run_state_changed()

func get_element_level(element_id: StringName) -> int:
	return int(element_levels.get(element_id, 1))

func get_owned_element_count(element_id: StringName) -> int:
	var count := 0
	for owned_element_id: StringName in element_slots:
		if owned_element_id == element_id:
			count += 1
	return count

func get_active_element_count(element_id: StringName) -> int:
	var count := 0
	for skill_id: StringName in active_skill_ids:
		var skill = ContentRegistry.get_skill_def(skill_id) if has_node("/root/ContentRegistry") else null
		if skill == null:
			continue
		for active_element_id: StringName in skill.element_ids:
			if active_element_id == element_id:
				count += 1
	return count

func has_active_or_stored_element(element_id: StringName) -> bool:
	return get_active_element_count(element_id) > 0 or element_id in element_slots

func get_activation_skill_ids() -> Array[StringName]:
	var result: Array[StringName] = []
	for element_id: StringName in [&"fire", &"ice", &"lightning"]:
		var element = ContentRegistry.get_element_def(element_id)
		for _index in range(get_owned_element_count(element_id)):
			if element != null:
				result.append(element.default_skill_id)
	for skill_id: StringName in synthesized_skill_ids:
		result.append(skill_id)
	return result

func set_active_skill(slot_index: int, skill_id: StringName) -> bool:
	if slot_index < 0 or slot_index >= active_skill_ids.size():
		return false
	if not _can_activate_skill_in_slot(slot_index, skill_id):
		return false
	active_skill_ids[slot_index] = skill_id
	GameEvents.run_skills_changed.emit()
	GameEvents.emit_run_state_changed()
	return true

func can_activate_skill_in_slot(slot_index: int, skill_id: StringName) -> bool:
	if slot_index < 0 or slot_index >= active_skill_ids.size():
		return false
	return _can_activate_skill_in_slot(slot_index, skill_id)

func synthesize_elements(selected_elements: Array[StringName]) -> bool:
	var changed := SynthesisService.synthesize_elements(selected_elements)
	if changed:
		GameEvents.run_skills_changed.emit()
		GameEvents.emit_run_state_changed()
	return changed

func is_synthesis_unlocked() -> bool:
	if has_node("/root/DebugSettings") and DebugSettings.unlock_synthesis_from_start:
		return true
	var balance = ContentRegistry.get_balance_config() if has_node("/root/ContentRegistry") else null
	var unlock_level: int = 3 if balance == null else int(balance.synthesis_unlock_level)
	return player_level >= unlock_level

func _get_initial_element_slots() -> Array[StringName]:
	var count_per_basic := 1
	if has_node("/root/DebugSettings"):
		count_per_basic = maxi(1, DebugSettings.initial_basic_element_count)
	var slots: Array[StringName] = []
	for element_id: StringName in [&"fire", &"ice", &"lightning"]:
		for _index in range(count_per_basic):
			slots.append(element_id)
	return slots

func _can_activate_skill_in_slot(slot_index: int, skill_id: StringName) -> bool:
	var skill = ContentRegistry.get_skill_def(skill_id)
	if skill == null:
		return false
	var proposed := active_skill_ids.duplicate()
	proposed[slot_index] = skill_id
	for candidate_id: StringName in proposed:
		var candidate = ContentRegistry.get_skill_def(candidate_id)
		if candidate == null:
			return false
		if candidate.quality == &"basic":
			var element_id: StringName = candidate.element_ids[0] if not candidate.element_ids.is_empty() else &""
			if _count_basic_skill_use(proposed, element_id) > get_owned_element_count(element_id):
				return false
		elif _count_skill_use(proposed, candidate_id) > _count_owned_synthesized_skill(candidate_id):
			return false
	return true

func _count_basic_skill_use(skill_ids: Array, element_id: StringName) -> int:
	var count := 0
	for skill_id: StringName in skill_ids:
		var skill = ContentRegistry.get_skill_def(skill_id)
		if skill != null and skill.quality == &"basic" and not skill.element_ids.is_empty() and skill.element_ids[0] == element_id:
			count += 1
	return count

func _count_skill_use(skill_ids: Array, skill_id: StringName) -> int:
	var count := 0
	for active_skill_id: StringName in skill_ids:
		if active_skill_id == skill_id:
			count += 1
	return count

func _count_owned_synthesized_skill(skill_id: StringName) -> int:
	var count := 0
	for owned_skill_id: StringName in synthesized_skill_ids:
		if owned_skill_id == skill_id:
			count += 1
	return count

func _refresh_xp_to_next_level() -> void:
	var balance = ContentRegistry.get_balance_config() if has_node("/root/ContentRegistry") else null
	if balance == null:
		xp_to_next_level = 20.0
		return
	xp_to_next_level = balance.xp_base * pow(balance.xp_growth, player_level - 1)
