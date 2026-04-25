extends CharacterBody2D

const VisualAssetScript := preload("res://scripts/visuals/visual_asset.gd")
const BASE_SPEED := 92.0
const RADIUS := 18.0

var enemy_def
var player: Node2D
var visual_node: Node2D
var current_health: float = 30.0
var max_health: float = 30.0
var xp_amount: float = 1.0
var contact_damage: float = 10.0
var contact_cooldown: float = 0.0
var slow_time: float = 0.0
var stun_time: float = 0.0

func setup(definition, target_player: Node2D) -> void:
	enemy_def = definition
	player = target_player
	var balance = ContentRegistry.get_balance_config()
	var minutes: float = RunState.run_time / 60.0
	var threat: float = 1.0 + balance.time_growth * minutes + balance.level_growth * float(RunState.player_level - 1)
	max_health = balance.enemy_hp_base * enemy_def.hp_multiplier * threat
	current_health = max_health
	contact_damage = balance.contact_damage_base * enemy_def.damage_multiplier * (1.0 + 0.06 * minutes)
	xp_amount = balance.xp_drop_base * enemy_def.xp_multiplier
	_setup_visual()

func _physics_process(delta: float) -> void:
	if RunState.is_level_up_paused:
		return
	_update_status(delta)
	if player == null or stun_time > 0.0:
		velocity = Vector2.ZERO
	else:
		var speed: float = BASE_SPEED * enemy_def.speed_multiplier
		if slow_time > 0.0:
			speed *= 0.55
		velocity = global_position.direction_to(player.global_position) * speed
	move_and_slide()
	_apply_contact_damage(delta)
	queue_redraw()

func take_damage(amount: float) -> void:
	current_health -= amount
	if current_health <= 0.0:
		GameEvents.enemy_died.emit(self, xp_amount, global_position)
		queue_free()

func apply_status(effect_type: StringName, duration: float) -> void:
	match effect_type:
		&"slow":
			slow_time = maxf(slow_time, duration)
		&"stun":
			stun_time = maxf(stun_time, duration)

func _draw() -> void:
	if visual_node == null:
		var fill: Color = enemy_def.placeholder_color if enemy_def != null else Color(0.9, 0.2, 0.24)
		draw_circle(Vector2.ZERO, RADIUS, fill)
	var health_ratio := clampf(current_health / maxf(1.0, max_health), 0.0, 1.0)
	draw_rect(Rect2(Vector2(-RADIUS, -RADIUS - 9.0), Vector2(RADIUS * 2.0, 4.0)), Color(0.16, 0.04, 0.04))
	draw_rect(Rect2(Vector2(-RADIUS, -RADIUS - 9.0), Vector2(RADIUS * 2.0 * health_ratio, 4.0)), Color(0.25, 1.0, 0.35))

func _setup_visual() -> void:
	if visual_node != null:
		visual_node.queue_free()
		visual_node = null
	if enemy_def == null:
		return
	visual_node = VisualAssetScript.create_visual_node(enemy_def.animation_dir, enemy_def.sprite_path, enemy_def.visual_world_size, enemy_def.animation_fps, true)
	if visual_node != null:
		add_child(visual_node)

func _update_status(delta: float) -> void:
	slow_time = maxf(0.0, slow_time - delta)
	stun_time = maxf(0.0, stun_time - delta)
	contact_cooldown = maxf(0.0, contact_cooldown - delta)

func _apply_contact_damage(_delta: float) -> void:
	if player == null or contact_cooldown > 0.0:
		return
	if global_position.distance_to(player.global_position) <= RADIUS + 18.0:
		RunState.damage_player(contact_damage)
		contact_cooldown = 0.65
