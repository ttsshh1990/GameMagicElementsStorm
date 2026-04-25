extends Node

const LOCK_HEALTH_SETTING := "debug/game/lock_player_health_to_one"

var lock_player_health_to_one: bool = false

func _ready() -> void:
	# Debug assists are gated behind Godot debug builds so exported release builds ignore them.
	lock_player_health_to_one = OS.is_debug_build() and bool(ProjectSettings.get_setting(LOCK_HEALTH_SETTING, false))
