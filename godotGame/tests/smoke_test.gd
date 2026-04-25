extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene := load("res://scenes/main/main.tscn")
	if scene == null:
		push_error("Smoke test failed: main scene did not load.")
		quit(1)
		return
	var main: Node = scene.instantiate()
	root.add_child(main)
	await process_frame
	await create_timer(0.25).timeout
	if main.get_node_or_null("GameWorld") == null:
		push_error("Smoke test failed: GameWorld was not created.")
		quit(1)
		return
	print("Smoke test passed: main scene instantiated.")
	quit(0)
