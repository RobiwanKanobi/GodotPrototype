extends Node2D

enum State { SEARCHING, MOVING_TO_BERRY, MOVING_TO_ANTHILL }

var game: Node
var state: State = State.SEARCHING
var speed: float = 120.0
var target_berry: Node2D = null


func _process(delta: float) -> void:
	match state:
		State.SEARCHING:
			_find_berry()
		State.MOVING_TO_BERRY:
			if not is_instance_valid(target_berry):
				state = State.SEARCHING
				return
			position = position.move_toward(target_berry.position, speed * delta)
			if position.distance_to(target_berry.position) < 5.0:
				target_berry.queue_free()
				target_berry = null
				state = State.MOVING_TO_ANTHILL
		State.MOVING_TO_ANTHILL:
			var target: Vector2 = game.anthill_position
			position = position.move_toward(target, speed * delta)
			if position.distance_to(target) < 5.0:
				game.add_sugar(1)
				state = State.SEARCHING


func _find_berry() -> void:
	var nearest: Node2D = null
	var nearest_dist: float = INF
	for berry in game.dropped_berries.get_children():
		if berry.claimed:
			continue
		var dist: float = position.distance_to(berry.position)
		if dist < nearest_dist:
			nearest = berry
			nearest_dist = dist
	if nearest:
		nearest.claimed = true
		target_berry = nearest
		state = State.MOVING_TO_BERRY
