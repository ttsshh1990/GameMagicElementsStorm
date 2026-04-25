extends Node

const BALANCE_PATH := "res://resources/balance/balance_config.tres"
const ELEMENT_PATHS := [
	"res://resources/elements/element_fire.tres",
	"res://resources/elements/element_ice.tres",
	"res://resources/elements/element_lightning.tres",
]
const SKILL_PATHS := [
	"res://resources/skills/skill_fireball.tres",
	"res://resources/skills/skill_ice_nova.tres",
	"res://resources/skills/skill_lightning_chain.tres",
]
const ENEMY_PATHS := [
	"res://resources/enemies/enemy_chaser.tres",
	"res://resources/enemies/enemy_fast.tres",
	"res://resources/enemies/enemy_tank.tres",
]
const REWARD_PATHS := [
	"res://resources/rewards/reward_upgrade_fire.tres",
	"res://resources/rewards/reward_upgrade_ice.tres",
	"res://resources/rewards/reward_upgrade_lightning.tres",
]

var _balance_config
var _elements: Dictionary = {}
var _skills: Dictionary = {}
var _enemies: Dictionary = {}
var _rewards: Dictionary = {}

func _ready() -> void:
	load_definitions()

func load_definitions() -> void:
	_balance_config = load(BALANCE_PATH)
	_elements = _load_by_id(ELEMENT_PATHS)
	_skills = _load_by_id(SKILL_PATHS)
	_enemies = _load_by_id(ENEMY_PATHS)
	_rewards = _load_by_id(REWARD_PATHS)

func get_balance_config():
	return _balance_config

func get_element_def(element_id: StringName):
	return _elements.get(element_id)

func get_skill_def(skill_id: StringName):
	return _skills.get(skill_id)

func get_enemy_def(enemy_id: StringName):
	return _enemies.get(enemy_id)

func get_reward_def(reward_id: StringName):
	return _rewards.get(reward_id)

func get_all_reward_defs() -> Array:
	var result: Array = []
	for reward in _rewards.values():
		result.append(reward)
	return result

func get_default_skill_ids_for_slots(element_slots: Array[StringName]) -> Array[StringName]:
	var result: Array[StringName] = []
	for element_id: StringName in element_slots:
		var element = get_element_def(element_id)
		if element != null:
			result.append(element.default_skill_id)
	return result

func _load_by_id(paths: Array) -> Dictionary:
	var result := {}
	for path: String in paths:
		var resource := load(path)
		if resource == null:
			push_error("ContentRegistry failed to load %s" % path)
			continue
		result[resource.id] = resource
	return result
