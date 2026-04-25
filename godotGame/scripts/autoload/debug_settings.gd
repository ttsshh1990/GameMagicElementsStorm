extends Node

const LOCK_HEALTH_SETTING := "debug/game/lock_player_health_to_one"
const THREE_EACH_BASIC_ELEMENT_SETTING := "debug/game/start_with_three_each_basic_element"
const UNLOCK_SYNTHESIS_FROM_START_SETTING := "debug/game/unlock_synthesis_from_start"

var lock_player_health_to_one: bool = false
var start_with_three_each_basic_element: bool = false
var unlock_synthesis_from_start: bool = false

func _ready() -> void:
	# Debug assists are gated behind Godot debug builds so exported release builds ignore them.
	lock_player_health_to_one = OS.is_debug_build() and bool(ProjectSettings.get_setting(LOCK_HEALTH_SETTING, false))
	start_with_three_each_basic_element = OS.is_debug_build() and bool(ProjectSettings.get_setting(THREE_EACH_BASIC_ELEMENT_SETTING, false))
	unlock_synthesis_from_start = OS.is_debug_build() and bool(ProjectSettings.get_setting(UNLOCK_SYNTHESIS_FROM_START_SETTING, false))
