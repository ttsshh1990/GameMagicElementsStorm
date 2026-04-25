extends Node2D

const GameWorldScript := preload("res://scripts/game/game_world.gd")
const UIRootScript := preload("res://scripts/ui/ui_root.gd")

var game_world: Node2D
var ui_root: CanvasLayer

func _ready() -> void:
	_configure_input_actions()
	RunState.reset_run()
	game_world = Node2D.new()
	game_world.set_script(GameWorldScript)
	add_child(game_world)
	ui_root = CanvasLayer.new()
	ui_root.set_script(UIRootScript)
	add_child(ui_root)
	ui_root.setup(game_world.reward_system)

func _configure_input_actions() -> void:
	_ensure_key_action("move_left", [KEY_A, KEY_LEFT])
	_ensure_key_action("move_right", [KEY_D, KEY_RIGHT])
	_ensure_key_action("move_up", [KEY_W, KEY_UP])
	_ensure_key_action("move_down", [KEY_S, KEY_DOWN])

func _ensure_key_action(action_name: StringName, keycodes: Array[int]) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	for keycode: int in keycodes:
		var exists := false
		for event: InputEvent in InputMap.action_get_events(action_name):
			if event is InputEventKey and (event as InputEventKey).physical_keycode == keycode:
				exists = true
		if not exists:
			var key_event := InputEventKey.new()
			key_event.physical_keycode = keycode
			InputMap.action_add_event(action_name, key_event)
