extends Node2D

var claimed: bool = false


func _draw() -> void:
	draw_circle(Vector2.ZERO, 5.0, Color(0.5, 0.5, 0.6))
