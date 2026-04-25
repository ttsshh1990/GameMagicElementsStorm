class_name TargetingSystem
extends RefCounted

static func find_nearest_enemy(origin: Vector2, enemy_layer: Node) -> Node2D:
	var nearest: Node2D = null
	var nearest_distance := INF
	for child: Node in enemy_layer.get_children():
		if not child is Node2D or child.is_queued_for_deletion():
			continue
		var distance := origin.distance_squared_to((child as Node2D).global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = child as Node2D
	return nearest

static func find_chain_targets(origin: Vector2, enemy_layer: Node, max_targets: int, max_range: float) -> Array[Node2D]:
	var result: Array[Node2D] = []
	var current_origin := origin
	for _index in range(max_targets):
		var best: Node2D = null
		var best_distance := max_range * max_range
		for child: Node in enemy_layer.get_children():
			if not child is Node2D or result.has(child) or child.is_queued_for_deletion():
				continue
			var distance := current_origin.distance_squared_to((child as Node2D).global_position)
			if distance <= best_distance:
				best_distance = distance
				best = child as Node2D
		if best == null:
			break
		result.append(best)
		current_origin = best.global_position
	return result
