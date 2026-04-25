extends Node

const LOCK_HEALTH_SETTING := "debug/game/lock_player_health_to_one"
const INITIAL_BASIC_ELEMENT_COUNT_SETTING := "debug/game/initial_basic_element_count"
const UNLOCK_SYNTHESIS_FROM_START_SETTING := "debug/game/unlock_synthesis_from_start"

var lock_player_health_to_one: bool = false
var initial_basic_element_count: int = 1
var unlock_synthesis_from_start: bool = false

func _ready() -> void:
	# Debug assists are gated behind Godot debug builds so exported release builds ignore them.
	lock_player_health_to_one = OS.is_debug_build() and bool(ProjectSettings.get_setting(LOCK_HEALTH_SETTING, false))
	initial_basic_element_count = int(ProjectSettings.get_setting(INITIAL_BASIC_ELEMENT_COUNT_SETTING, 1)) if OS.is_debug_build() else 1
	unlock_synthesis_from_start = OS.is_debug_build() and bool(ProjectSettings.get_setting(UNLOCK_SYNTHESIS_FROM_START_SETTING, false))
