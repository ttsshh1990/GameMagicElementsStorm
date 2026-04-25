extends Node

signal enemy_died(enemy: Node, xp_amount: float, death_position: Vector2)
signal xp_collected(amount: float)
signal level_up_requested(level: int)
signal reward_selected(reward_id: StringName)
signal player_damaged(current_health: float, max_health: float)
signal skill_cast_requested(skill_id: StringName)
signal run_state_changed

func emit_run_state_changed() -> void:
	run_state_changed.emit()
