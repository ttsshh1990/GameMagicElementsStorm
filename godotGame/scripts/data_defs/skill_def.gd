class_name SkillDef
extends Resource

@export var id: StringName
@export var display_name: String
@export var element_ids: Array[StringName] = []
@export var quality: StringName = &"basic"
@export var cooldown: float = 1.0
@export var damage_profile: StringName
@export var profile_multiplier: float = 1.0
@export var expected_hit_count: float = 1.0
@export var targeting_mode: StringName
@export var presentation_type: StringName
@export var icon_path: String
@export var cast_intro_frames_dir: String
@export var cast_intro_path: String
@export var cast_intro_fps: float = 12.0
@export var cast_intro_loop: bool = false
@export var cast_intro_world_size: float = 0.0
@export var cast_intro_duration: float = 0.0
@export var cast_intro_start_offset: Vector2 = Vector2.ZERO
@export var vfx_frames_dir: String
@export var vfx_path: String
@export var vfx_fps: float = 12.0
@export var vfx_loop: bool = false
@export var effect_type: StringName = &"none"
@export var effect_duration: float = 0.0
@export var radius: float = 0.0
@export var projectile_speed: float = 420.0
@export var chain_count: int = 0
