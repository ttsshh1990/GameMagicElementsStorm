extends Node

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func generate_level_up_rewards() -> Array:
	var available := _get_available_rewards()
	available.shuffle()
	return available.slice(0, mini(3, available.size()))

func apply_reward(reward) -> void:
	RunState.apply_reward(reward)

func _get_available_rewards() -> Array:
	var result: Array = []
	for reward in ContentRegistry.get_all_reward_defs():
		if _is_reward_available(reward):
			result.append(reward)
	return result

func _is_reward_available(reward) -> bool:
	if reward.reward_type == &"element_upgrade":
		return RunState.has_active_or_stored_element(reward.element_id)
	if reward.reward_type == &"element_gain":
		return true
	return false
