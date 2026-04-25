extends Node

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func generate_level_up_rewards() -> Array:
	var available := ContentRegistry.get_all_reward_defs()
	available.shuffle()
	return available.slice(0, mini(3, available.size()))

func apply_reward(reward) -> void:
	RunState.apply_reward(reward)
