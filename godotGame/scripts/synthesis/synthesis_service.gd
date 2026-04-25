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
	if recipe == null or recipe.result_skill_id in RunState.synthesized_skill_ids:
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

static func _activate_result_skill(recipe) -> void:
	if recipe.result_skill_id in RunState.active_skill_ids:
		return
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
	else:
		RunState.active_skill_ids[0] = recipe.result_skill_id
