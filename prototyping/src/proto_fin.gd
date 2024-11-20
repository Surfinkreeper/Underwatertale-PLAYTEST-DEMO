extends Node2D
class_name Fin

# procedure for drawing fins

var center = Vector2.ZERO

func _init() -> void:
	pass

func _draw() -> void:
	draw_set_transform(Vector2.ONE, 0.0, Vector2(0.67, 1))
	draw_circle(Vector2.ZERO, 50, Color("6d6dff"))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	
