extends Node

const ProjectileScript := preload("res://scripts/combat/projectile.gd")
const AreaEffectScript := preload("res://scripts/combat/area_effect.gd")
const LightningEffectScript := preload("res://scripts/combat/lightning_effect.gd")
const MeteorStrikeEffectScript := preload("res://scripts/combat/meteor_strike_effect.gd")
const TargetingSystemScript := preload("res://scripts/combat/targeting_system.gd")

const DUPLICATE_SKILL_STAGGER := 0.22
const DUPLICATE_AREA_SPREAD := 72.0

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
	for entry: Dictionary in _equipped_skills:
		var slot_index := int(entry.get("slot_index", -1))
		var skill = entry.get("skill")
		var remaining := float(_cooldowns.get(slot_index, 0.0)) - delta
		if remaining <= 0.0:
			_cast_skill(skill, slot_index)
			remaining = skill.cooldown
		_cooldowns[slot_index] = remaining

func _refresh_equipped_skills() -> void:
	_equipped_skills.clear()
	_cooldowns.clear()
	for slot_index in range(RunState.active_skill_ids.size()):
		var skill_id := RunState.active_skill_ids[slot_index]
		var skill = ContentRegistry.get_skill_def(skill_id)
		if skill != null:
			_equipped_skills.append({
				"slot_index": slot_index,
				"skill": skill,
			})
			_cooldowns[slot_index] = 0.15 + _get_duplicate_skill_ordinal(skill_id, slot_index) * DUPLICATE_SKILL_STAGGER

func _cast_skill(skill, slot_index: int) -> void:
	GameEvents.skill_cast_requested.emit(skill.id)
	match skill.presentation_type:
		&"projectile":
			_cast_projectile(skill)
		&"area":
			_cast_area(skill, slot_index)
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

func _cast_area(skill, slot_index: int) -> void:
	var target = TargetingSystemScript.find_nearest_enemy(player.global_position, enemy_layer)
	var effect_position: Vector2 = target.global_position if target != null else player.global_position
	effect_position += _get_duplicate_area_offset(skill.id, slot_index)
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

func _get_duplicate_skill_ordinal(skill_id: StringName, slot_index: int) -> int:
	var ordinal := 0
	for index in range(mini(slot_index, RunState.active_skill_ids.size())):
		if RunState.active_skill_ids[index] == skill_id:
			ordinal += 1
	return ordinal

func _get_active_skill_count(skill_id: StringName) -> int:
	var count := 0
	for active_skill_id: StringName in RunState.active_skill_ids:
		if active_skill_id == skill_id:
			count += 1
	return count

func _get_duplicate_area_offset(skill_id: StringName, slot_index: int) -> Vector2:
	var duplicate_count := _get_active_skill_count(skill_id)
	if duplicate_count <= 1:
		return Vector2.ZERO
	var ordinal := _get_duplicate_skill_ordinal(skill_id, slot_index)
	var centered_index := float(ordinal) - float(duplicate_count - 1) * 0.5
	# Duplicate area skills target the same enemy; a small deterministic spread keeps each cast readable.
	return Vector2(centered_index * DUPLICATE_AREA_SPREAD, absf(centered_index) * DUPLICATE_AREA_SPREAD * 0.35)
