extends Node2D

enum State { MOVING_TO_BERRY, HARVESTING }

var game: Node
var state: State = State.MOVING_TO_BERRY
var speed: float = 120.0
var harvest_timer: float = 0.0

const HARVEST_TIME: float = 5.0
const DROPPED_BERRY_SCRIPT = preload("res://ant_hill/dropped_berry.gd")


func _process(delta: float) -> void:
	match state:
		State.MOVING_TO_BERRY:
			var target: Vector2 = game.blueberry_position
			position = position.move_toward(target, speed * delta)
			if position.distance_to(target) < 2.0:
				state = State.HARVESTING
				harvest_timer = 0.0
		State.HARVESTING:
			harvest_timer += delta
			if harvest_timer >= HARVEST_TIME:
				_drop_berry()
				harvest_timer = 0.0


func _drop_berry() -> void:
	var berry := Node2D.new()
	berry.set_script(DROPPED_BERRY_SCRIPT)
	berry.position = Vector2(
		game.blueberry_position.x + randf_range(-25, 25),
		game.blueberry_position.y - 5
	)
	game.dropped_berries.add_child(berry)
