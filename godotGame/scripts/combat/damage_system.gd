extends Node

func calculate_hit_damage(skill) -> float:
	var balance = ContentRegistry.get_balance_config()
	if skill == null or balance == null:
		return 0.0
	var build_power := _quality_multiplier(skill.quality) * _element_power(skill)
	var cast_budget: float = balance.base_dps * skill.cooldown * build_power * skill.profile_multiplier
	return cast_budget / maxf(1.0, skill.expected_hit_count)

func apply_damage(enemy: Node, amount: float, effect_type: StringName = &"none", effect_duration: float = 0.0) -> void:
	if enemy == null or not enemy.has_method("take_damage"):
		return
	enemy.take_damage(amount)
	if enemy.has_method("apply_status") and effect_type != &"none" and effect_duration > 0.0:
		enemy.apply_status(effect_type, effect_duration)

func _element_power(skill) -> float:
	var balance = ContentRegistry.get_balance_config()
	if balance == null or skill.element_ids.is_empty():
		return 1.0
	var total := 0.0
	for element_id: StringName in skill.element_ids:
		total += RunState.get_element_level(element_id)
	var average_level: float = total / skill.element_ids.size()
	return 1.0 + balance.element_level_bonus * maxf(0.0, average_level - 1.0)

func _quality_multiplier(quality: StringName) -> float:
	match quality:
		&"purple":
			return 1.75
		&"orange":
			return 3.0
		_:
			return 1.0
