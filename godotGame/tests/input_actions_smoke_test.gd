extends SceneTree

const KEY_EXPECTATIONS := {
	"move_left": [KEY_A, KEY_LEFT],
	"move_right": [KEY_D, KEY_RIGHT],
	"move_up": [KEY_W, KEY_UP],
	"move_down": [KEY_S, KEY_DOWN],
}

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene := load("res://scenes/main/main.tscn")
	var main: Node = scene.instantiate()
	root.add_child(main)
	await process_frame

	if not _check_input_map():
		quit(1)
		return

	var world := main.get_node_or_null("GameWorld")
	if world == null or world.player == null:
		push_error("Input smoke failed: GameWorld or player missing.")
		quit(1)
		return

	var player = world.player
	if not await _check_axis(player, "move_right", "x", 1.0):
		quit(1)
		return
	if not await _check_axis(player, "move_left", "x", -1.0):
		quit(1)
		return
	if not await _check_axis(player, "move_down", "y", 1.0):
		quit(1)
		return
	if not await _check_axis(player, "move_up", "y", -1.0):
		quit(1)
		return

	var run_state = root.get_node("/root/RunState")
	run_state.is_level_up_paused = true
	var paused_position: Vector2 = player.global_position
	Input.action_press("move_right")
	await create_timer(0.25).timeout
	Input.action_release("move_right")
	if player.global_position.distance_to(paused_position) > 1.0:
		push_error("Input smoke failed: player moved while level-up pause was active.")
		quit(1)
		return

	print("Input smoke passed: WASD and arrow keys map to movement, and level-up pause blocks movement.")
	quit(0)

func _check_input_map() -> bool:
	for action_name: StringName in KEY_EXPECTATIONS:
		if not InputMap.has_action(action_name):
			push_error("Input smoke failed: missing action %s." % action_name)
			return false
		for keycode: int in KEY_EXPECTATIONS[action_name]:
			if not _action_has_key(action_name, keycode):
				push_error("Input smoke failed: action %s missing keycode %s." % [action_name, keycode])
				return false
	return true

func _action_has_key(action_name: StringName, keycode: int) -> bool:
	for event: InputEvent in InputMap.action_get_events(action_name):
		if event is InputEventKey and (event as InputEventKey).physical_keycode == keycode:
			return true
	return false

func _check_axis(player: CharacterBody2D, action_name: StringName, axis: String, direction: float) -> bool:
	var before: Vector2 = player.global_position
	Input.action_press(action_name)
	await create_timer(0.25).timeout
	Input.action_release(action_name)
	await process_frame
	var delta := player.global_position.x - before.x
	if axis == "y":
		delta = player.global_position.y - before.y
	if delta * direction <= 5.0:
		push_error("Input smoke failed: %s did not move on %s axis." % [action_name, axis])
		return false
	return true
