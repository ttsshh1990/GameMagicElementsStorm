extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene := load("res://scenes/main/main.tscn")
	var main: Node = scene.instantiate()
	root.add_child(main)
	await process_frame

	var run_state = root.get_node("/root/RunState")
	var content_registry = root.get_node("/root/ContentRegistry")
	var world = main.get_node_or_null("GameWorld")
	if world == null:
		push_error("Synthesis smoke failed: GameWorld missing.")
		quit(1)
		return

	if run_state.get_owned_element_count(&"fire") != 9 or run_state.get_owned_element_count(&"ice") != 9 or run_state.get_owned_element_count(&"lightning") != 9:
		push_error("Synthesis smoke failed: debug initial element inventory should start with nine fire, ice, and lightning.")
		quit(1)
		return
	if run_state.active_skill_ids != [&"fireball", &"ice_nova", &"lightning_chain"]:
		push_error("Synthesis smoke failed: initial active skills should be fireball, ice nova, and lightning chain.")
		quit(1)
		return
	if _count_skill_id(run_state.get_activation_skill_ids(), &"ice_nova") != 9:
		push_error("Synthesis smoke failed: each owned ice element should expose one ice nova activation entry.")
		quit(1)
		return
	if not run_state.set_active_skill(0, &"ice_nova") or not run_state.set_active_skill(1, &"ice_nova") or not run_state.set_active_skill(2, &"ice_nova"):
		push_error("Synthesis smoke failed: three owned ice elements should allow three active ice novas.")
		quit(1)
		return
	if run_state.active_skill_ids != [&"ice_nova", &"ice_nova", &"ice_nova"]:
		push_error("Synthesis smoke failed: duplicate basic skills should be valid active slots.")
		quit(1)
		return
	if not run_state.set_active_skill(0, &"fireball") or not run_state.set_active_skill(2, &"lightning_chain"):
		push_error("Synthesis smoke failed: active slots should be restorable after duplicate basic skill activation.")
		quit(1)
		return
	if not run_state.set_active_skill(1, &"fireball") or not run_state.set_active_skill(2, &"fireball"):
		push_error("Synthesis smoke failed: three owned fire elements should allow three active fireballs.")
		quit(1)
		return
	if run_state.active_skill_ids != [&"fireball", &"fireball", &"fireball"]:
		push_error("Synthesis smoke failed: duplicate fireball active slots are incorrect.")
		quit(1)
		return
	if not run_state.set_active_skill(1, &"ice_nova") or not run_state.set_active_skill(2, &"lightning_chain"):
		push_error("Synthesis smoke failed: active slots should restore to baseline before synthesis.")
		quit(1)
		return

	var available_rewards: Array = world.reward_system._get_available_rewards()
	if not _contains_reward(available_rewards, &"gain_fire") or not _contains_reward(available_rewards, &"gain_ice") or not _contains_reward(available_rewards, &"gain_lightning"):
		push_error("Synthesis smoke failed: element gain rewards missing from pool.")
		quit(1)
		return
	if not _contains_reward(available_rewards, &"upgrade_fire") or not _contains_reward(available_rewards, &"upgrade_ice") or not _contains_reward(available_rewards, &"upgrade_lightning"):
		push_error("Synthesis smoke failed: element upgrade availability is incorrect.")
		quit(1)
		return

	run_state.is_level_up_paused = true
	run_state.player_level = 2
	if not run_state.is_synthesis_unlocked():
		push_error("Synthesis smoke failed: debug mode should unlock synthesis before level 3.")
		quit(1)
		return
	if &"meteor_fire" in run_state.synthesized_skill_ids:
		push_error("Synthesis smoke failed: debug unlock should not auto-synthesize before manual input.")
		quit(1)
		return
	run_state.is_level_up_paused = true
	run_state.player_level = 3
	await process_frame

	if &"meteor_fire" in run_state.synthesized_skill_ids:
		push_error("Synthesis smoke failed: fire-fire-fire should not auto synthesize after gaining the third fire.")
		quit(1)
		return
	if run_state.get_owned_element_count(&"fire") != 9:
		push_error("Synthesis smoke failed: owned inactive fire count is incorrect before manual synthesis.")
		quit(1)
		return
	var selected_elements: Array[StringName] = [&"fire", &"fire", &"fire"]
	if not run_state.synthesize_elements(selected_elements):
		push_error("Synthesis smoke failed: manual fire-fire-fire synthesis did not execute.")
		quit(1)
		return
	await process_frame

	if not &"meteor_fire" in run_state.synthesized_skill_ids:
		push_error("Synthesis smoke failed: fire-fire-fire did not synthesize meteor.")
		quit(1)
		return
	if run_state.get_owned_element_count(&"fire") != 6:
		push_error("Synthesis smoke failed: fire synthesis should consume exactly three of nine fire elements.")
		quit(1)
		return
	if not run_state.element_slots.has(&"ice") or not run_state.element_slots.has(&"lightning"):
		push_error("Synthesis smoke failed: non-recipe elements should stay in slots.")
		quit(1)
		return
	if run_state.active_skill_ids != [&"meteor_fire", &"ice_nova", &"lightning_chain"]:
		push_error("Synthesis smoke failed: meteor should replace the active fire skill while keeping 3 active skills.")
		quit(1)
		return
	if run_state.get_active_element_count(&"fire") != 3 or run_state.get_active_element_count(&"ice") != 1 or run_state.get_active_element_count(&"lightning") != 1:
		push_error("Synthesis smoke failed: active element composition counts are incorrect.")
		quit(1)
		return

	var skill_ids: Array[StringName] = run_state.active_skill_ids
	if not &"meteor_fire" in skill_ids or not &"ice_nova" in skill_ids or not &"lightning_chain" in skill_ids or &"fireball" in skill_ids:
		push_error("Synthesis smoke failed: synthesized run skill list is incorrect.")
		quit(1)
		return
	if not run_state.set_active_skill(0, &"fireball") or not run_state.set_active_skill(1, &"fireball") or not run_state.set_active_skill(2, &"fireball"):
		push_error("Synthesis smoke failed: remaining fire instances should support three active fireballs before second synthesis.")
		quit(1)
		return
	if not run_state.synthesize_elements(selected_elements):
		push_error("Synthesis smoke failed: repeated fire-fire-fire synthesis should create another meteor instance.")
		quit(1)
		return
	await process_frame
	if _count_skill_id(run_state.synthesized_skill_ids, &"meteor_fire") != 2:
		push_error("Synthesis smoke failed: repeated synthesis should keep two owned meteor instances.")
		quit(1)
		return
	if _count_skill_id(run_state.get_activation_skill_ids(), &"meteor_fire") != 2:
		push_error("Synthesis smoke failed: activation choices should include one entry per owned meteor instance.")
		quit(1)
		return
	if not run_state.set_active_skill(1, &"meteor_fire"):
		push_error("Synthesis smoke failed: two owned meteor instances should allow two active meteors.")
		quit(1)
		return
	if run_state.set_active_skill(2, &"meteor_fire"):
		push_error("Synthesis smoke failed: two owned meteor instances should not allow three active meteors.")
		quit(1)
		return
	if not run_state.set_active_skill(0, &"fireball") or not run_state.set_active_skill(1, &"fireball") or not run_state.set_active_skill(2, &"fireball"):
		push_error("Synthesis smoke failed: last three fire instances should support three active fireballs before third synthesis.")
		quit(1)
		return
	if not run_state.synthesize_elements(selected_elements):
		push_error("Synthesis smoke failed: third fire-fire-fire synthesis should consume the last fire instances.")
		quit(1)
		return
	await process_frame
	if &"fireball" in run_state.active_skill_ids:
		push_error("Synthesis smoke failed: synthesis should repair active slots that no longer have backing fire instances.")
		quit(1)
		return
	if _count_skill_id(run_state.synthesized_skill_ids, &"meteor_fire") != 3:
		push_error("Synthesis smoke failed: third synthesis should keep three owned meteor instances.")
		quit(1)
		return

	print("Synthesis smoke passed: element gain rewards, repeated synthesis, and duplicate active skills work.")
	quit(0)

func _contains_reward(rewards: Array, reward_id: StringName) -> bool:
	for reward in rewards:
		if reward.id == reward_id:
			return true
	return false

func _count_skill_id(skill_ids: Array, skill_id: StringName) -> int:
	var count := 0
	for candidate_id: StringName in skill_ids:
		if candidate_id == skill_id:
			count += 1
	return count
