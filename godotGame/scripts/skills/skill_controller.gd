extends Node

const ProjectileScript := preload("res://scripts/combat/projectile.gd")
const AreaEffectScript := preload("res://scripts/combat/area_effect.gd")
const LightningEffectScript := preload("res://scripts/combat/lightning_effect.gd")
const MeteorStrikeEffectScript := preload("res://scripts/combat/meteor_strike_effect.gd")
const TargetingSystemScript := preload("res://scripts/combat/targeting_system.gd")

var player: Node2D
var enemy_layer: Node
var projectile_layer: Node
var vfx_layer: Node
var _equipped_skills: Array = []
var _cooldowns: Dictionary = {}

func setup(target_player: Node2D, enemies: Node, projectiles: Node, vfx: Node) -> void:
	player = target_player
	enemy_layer = enemies
	projectile_layer = projectiles
	vfx_layer = vfx
	GameEvents.run_skills_changed.connect(_refresh_equipped_skills)
	_refresh_equipped_skills()

func _process(delta: float) -> void:
	if RunState.is_level_up_paused:
		return
	for skill in _equipped_skills:
		var remaining := float(_cooldowns.get(skill.id, 0.0)) - delta
		if remaining <= 0.0:
			_cast_skill(skill)
			remaining = skill.cooldown
		_cooldowns[skill.id] = remaining

func _refresh_equipped_skills() -> void:
	_equipped_skills.clear()
	_cooldowns.clear()
	for skill_id: StringName in RunState.active_skill_ids:
		var skill = ContentRegistry.get_skill_def(skill_id)
		if skill != null:
			_equipped_skills.append(skill)
			_cooldowns[skill.id] = 0.15

func _cast_skill(skill) -> void:
	GameEvents.skill_cast_requested.emit(skill.id)
	match skill.presentation_type:
		&"projectile":
			_cast_projectile(skill)
		&"area":
			_cast_area(skill)
		&"chain":
			_cast_chain(skill)

func _cast_projectile(skill) -> void:
	var target = TargetingSystemScript.find_nearest_enemy(player.global_position, enemy_layer)
	if target == null:
		return
	var projectile := Node2D.new()
	projectile.set_script(ProjectileScript)
	projectile_layer.add_child(projectile)
	projectile.setup(player.global_position, player.global_position.direction_to(target.global_position), skill, DamageSystem.calculate_hit_damage(skill), enemy_layer)

func _cast_area(skill) -> void:
	var target = TargetingSystemScript.find_nearest_enemy(player.global_position, enemy_layer)
	var effect_position: Vector2 = target.global_position if target != null else player.global_position
	if not skill.cast_intro_frames_dir.is_empty() or not skill.cast_intro_path.is_empty():
		var meteor := Node2D.new()
		meteor.set_script(MeteorStrikeEffectScript)
		vfx_layer.add_child(meteor)
		meteor.setup(effect_position, skill, DamageSystem.calculate_hit_damage(skill), enemy_layer)
		return
	var area := Node2D.new()
	area.set_script(AreaEffectScript)
	vfx_layer.add_child(area)
	area.setup(effect_position, skill, DamageSystem.calculate_hit_damage(skill), enemy_layer)

func _cast_chain(skill) -> void:
	var targets = TargetingSystemScript.find_chain_targets(player.global_position, enemy_layer, skill.chain_count + 1, skill.radius)
	if targets.is_empty():
		return
	var hit_damage := DamageSystem.calculate_hit_damage(skill)
	var effect_points: Array[Vector2] = [player.global_position]
	for target: Node2D in targets:
		DamageSystem.apply_damage(target, hit_damage, skill.effect_type, skill.effect_duration)
		effect_points.append(target.global_position)
	var effect := Node2D.new()
	effect.set_script(LightningEffectScript)
	vfx_layer.add_child(effect)
	effect.setup(effect_points, skill)
