extends Node

var run_time: float = 0.0
var player_level: int = 1
var player_xp: float = 0.0
var xp_to_next_level: float = 20.0
var player_health: float = 100.0
var player_max_health: float = 100.0
var is_level_up_paused: bool = false
var element_slots: Array[StringName] = [&"fire", &"ice", &"lightning"]
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
	element_slots = [&"fire", &"ice", &"lightning"]
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
	GameEvents.reward_selected.emit(reward.id)
	is_level_up_paused = false
	GameEvents.emit_run_state_changed()

func get_element_level(element_id: StringName) -> int:
	return int(element_levels.get(element_id, 1))

func _refresh_xp_to_next_level() -> void:
	var balance = ContentRegistry.get_balance_config() if has_node("/root/ContentRegistry") else null
	if balance == null:
		xp_to_next_level = 20.0
		return
	xp_to_next_level = balance.xp_base * pow(balance.xp_growth, player_level - 1)
