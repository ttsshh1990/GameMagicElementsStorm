extends Node

func _ready() -> void:
	GameEvents.xp_collected.connect(_on_xp_collected)

func _on_xp_collected(amount: float) -> void:
	RunState.add_xp(amount)
