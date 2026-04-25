extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene := load("res://scenes/main/main.tscn")
	var main: Node = scene.instantiate()
	root.add_child(main)
	await process_frame

	var world := main.get_node_or_null("GameWorld")
	if world == null:
		push_error("Core loop smoke failed: GameWorld missing.")
		quit(1)
		return

	var run_state = root.get_node("/root/RunState")
	run_state.add_xp(run_state.xp_to_next_level)
	await process_frame
	if not run_state.is_level_up_paused:
		push_error("Core loop smoke failed: level-up did not pause reward flow.")
		quit(1)
		return

	var reward_system = world.reward_system
	var rewards: Array = reward_system.generate_level_up_rewards()
	if rewards.size() != 3:
		push_error("Core loop smoke failed: expected 3 rewards.")
		quit(1)
		return
	reward_system.apply_reward(rewards[0])
	if run_state.is_level_up_paused:
		push_error("Core loop smoke failed: reward did not resume run.")
		quit(1)
		return

	await create_timer(1.5).timeout
	var enemy_layer := world.get_node_or_null("EnemyLayer")
	if enemy_layer == null or enemy_layer.get_child_count() == 0:
		push_error("Core loop smoke failed: enemies did not spawn.")
		quit(1)
		return

	run_state.damage_player(9999.0)
	if run_state.player_health != 1.0:
		push_error("Core loop smoke failed: debug health lock did not clamp to 1.")
		quit(1)
		return

	print("Core loop smoke passed: reward flow and enemy spawning work.")
	quit(0)
