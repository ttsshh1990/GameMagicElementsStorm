extends SceneTree

const MeteorStrikeEffectScript := preload("res://scripts/combat/meteor_strike_effect.gd")

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var skill = root.get_node("/root/ContentRegistry").get_skill_def(&"meteor_fire")
	if skill == null:
		push_error("Meteor smoke failed: meteor skill missing.")
		quit(1)
		return
	if skill.cast_intro_frames_dir.is_empty():
		push_error("Meteor smoke failed: meteor fall frames are not configured.")
		quit(1)
		return
	if skill.cast_intro_start_offset.x >= 0.0 or skill.cast_intro_start_offset.y >= 0.0:
		push_error("Meteor smoke failed: fall start offset should place meteor at upper-left.")
		quit(1)
		return

	var enemy_layer := Node.new()
	root.add_child(enemy_layer)
	var effect := Node2D.new()
	effect.set_script(MeteorStrikeEffectScript)
	root.add_child(effect)
	effect.setup(Vector2(300.0, 300.0), skill, 10.0, enemy_layer)
	await process_frame

	if effect.fall_visual == null:
		push_error("Meteor smoke failed: fall visual did not load.")
		quit(1)
		return
	if not effect.fall_visual is AnimatedSprite2D:
		push_error("Meteor smoke failed: fall visual should use AnimatedSprite2D frames.")
		quit(1)
		return
	if effect.fall_visual.position.x >= 0.0 or effect.fall_visual.position.y >= 0.0:
		push_error("Meteor smoke failed: fall visual did not start at upper-left offset.")
		quit(1)
		return
	if effect.has_impacted:
		push_error("Meteor smoke failed: impact should not happen before fall duration.")
		quit(1)
		return

	effect._process(skill.cast_intro_duration + 0.05)
	if not effect.has_impacted:
		push_error("Meteor smoke failed: impact did not trigger after fall duration.")
		quit(1)
		return
	if effect.impact_visual == null:
		push_error("Meteor smoke failed: impact visual did not load.")
		quit(1)
		return

	effect.queue_free()
	enemy_layer.queue_free()
	await process_frame
	print("Meteor smoke passed: falling meteor intro plays from upper-left before impact VFX.")
	quit(0)
