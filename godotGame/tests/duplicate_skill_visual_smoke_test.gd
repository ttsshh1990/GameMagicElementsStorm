extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var SkillControllerScript = load("res://scripts/skills/skill_controller.gd")
	var run_state = root.get_node("/root/RunState")
	var duplicate_meteors: Array[StringName] = [&"meteor_fire", &"meteor_fire", &"meteor_fire"]
	run_state.active_skill_ids = duplicate_meteors
	run_state.is_level_up_paused = false

	var player := Node2D.new()
	player.global_position = Vector2.ZERO
	root.add_child(player)

	var enemy_layer := Node2D.new()
	root.add_child(enemy_layer)
	var enemy := Node2D.new()
	enemy.global_position = Vector2(320.0, 180.0)
	enemy_layer.add_child(enemy)

	var projectile_layer := Node2D.new()
	root.add_child(projectile_layer)
	var vfx_layer := Node2D.new()
	root.add_child(vfx_layer)

	var controller := Node.new()
	controller.set_script(SkillControllerScript)
	root.add_child(controller)
	controller.setup(player, enemy_layer, projectile_layer, vfx_layer)

	if float(controller._cooldowns.get(0, 0.0)) >= float(controller._cooldowns.get(1, 0.0)):
		push_error("Duplicate skill visual smoke failed: duplicate meteor slots should start with staggered cooldowns.")
		quit(1)
		return
	if float(controller._cooldowns.get(1, 0.0)) >= float(controller._cooldowns.get(2, 0.0)):
		push_error("Duplicate skill visual smoke failed: third meteor slot should be staggered after second slot.")
		quit(1)
		return

	controller._process(0.16)
	if vfx_layer.get_child_count() != 1:
		push_error("Duplicate skill visual smoke failed: first staggered meteor did not spawn alone.")
		quit(1)
		return
	controller._process(0.23)
	if vfx_layer.get_child_count() != 2:
		push_error("Duplicate skill visual smoke failed: second staggered meteor did not spawn.")
		quit(1)
		return
	controller._process(0.23)
	if vfx_layer.get_child_count() != 3:
		push_error("Duplicate skill visual smoke failed: third staggered meteor did not spawn.")
		quit(1)
		return

	var first_position := (vfx_layer.get_child(0) as Node2D).global_position
	var second_position := (vfx_layer.get_child(1) as Node2D).global_position
	var third_position := (vfx_layer.get_child(2) as Node2D).global_position
	if first_position == second_position or second_position == third_position or first_position == third_position:
		push_error("Duplicate skill visual smoke failed: duplicate meteor impacts should not fully overlap.")
		quit(1)
		return

	print("Duplicate skill visual smoke passed: duplicate meteor slots stagger casts and spread impact positions.")
	quit(0)
