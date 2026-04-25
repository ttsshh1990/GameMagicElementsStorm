extends RefCounted

static func synthesize_elements(selected_elements: Array[StringName]) -> bool:
	if not _is_synthesis_unlocked():
		return false
	for recipe in ContentRegistry.get_all_synthesis_recipe_defs():
		if _matches_recipe(recipe, selected_elements) and _can_apply_recipe(recipe):
			_apply_recipe(recipe)
			return true
	return false

static func _is_synthesis_unlocked() -> bool:
	return RunState.is_synthesis_unlocked()

static func _can_apply_recipe(recipe) -> bool:
	if recipe == null:
		return false
	var remaining_slots := RunState.element_slots.duplicate()
	for element_id: StringName in recipe.required_elements:
		var index := remaining_slots.find(element_id)
		if index < 0:
			return false
		remaining_slots.remove_at(index)
	return true

static func _matches_recipe(recipe, selected_elements: Array[StringName]) -> bool:
	if recipe == null or selected_elements.size() != recipe.required_elements.size():
		return false
	var remaining := selected_elements.duplicate()
	for element_id: StringName in recipe.required_elements:
		var index := remaining.find(element_id)
		if index < 0:
			return false
		remaining.remove_at(index)
	return remaining.is_empty()

static func _apply_recipe(recipe) -> void:
	for element_id: StringName in recipe.required_elements:
		RunState.element_slots.erase(element_id)
	RunState.synthesized_skill_ids.append(recipe.result_skill_id)
	_activate_result_skill(recipe)
	_repair_active_skill_instances()

static func _activate_result_skill(recipe) -> void:
	for element_id: StringName in recipe.required_elements:
		var element = ContentRegistry.get_element_def(element_id)
		if element == null:
			continue
		var index := RunState.active_skill_ids.find(element.default_skill_id)
		if index >= 0:
			RunState.active_skill_ids[index] = recipe.result_skill_id
			return
	if RunState.active_skill_ids.size() < 3:
		RunState.active_skill_ids.append(recipe.result_skill_id)

static func _repair_active_skill_instances() -> void:
	var used_counts := {}
	for index in range(RunState.active_skill_ids.size()):
		var skill_id := RunState.active_skill_ids[index]
		if _can_use_skill_instance(skill_id, used_counts):
			_reserve_skill_instance(skill_id, used_counts)
		else:
			RunState.active_skill_ids[index] = &""
	var activation_skill_ids := RunState.get_activation_skill_ids()
	for index in range(RunState.active_skill_ids.size()):
		if RunState.active_skill_ids[index] != &"":
			continue
		for skill_id: StringName in activation_skill_ids:
			if _can_use_skill_instance(skill_id, used_counts):
				RunState.active_skill_ids[index] = skill_id
				_reserve_skill_instance(skill_id, used_counts)
				break

static func _can_use_skill_instance(skill_id: StringName, used_counts: Dictionary) -> bool:
	var skill = ContentRegistry.get_skill_def(skill_id)
	if skill == null:
		return false
	var next_count := int(used_counts.get(skill_id, 0)) + 1
	if skill.quality == &"basic":
		var element_id: StringName = skill.element_ids[0] if not skill.element_ids.is_empty() else &""
		return next_count <= RunState.get_owned_element_count(element_id)
	return next_count <= _count_owned_synthesized_skill(skill_id)

static func _reserve_skill_instance(skill_id: StringName, used_counts: Dictionary) -> void:
	used_counts[skill_id] = int(used_counts.get(skill_id, 0)) + 1

static func _count_owned_synthesized_skill(skill_id: StringName) -> int:
	var count := 0
	for owned_skill_id: StringName in RunState.synthesized_skill_ids:
		if owned_skill_id == skill_id:
			count += 1
	return count
