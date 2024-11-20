extends Node2D

@onready var subview : SubViewport = $SubViewport

func _input(event: InputEvent) -> void:
	# this is just here to push input events to the subviewport,
	# which doesn't recieve them by default
	subview.push_input(event)
