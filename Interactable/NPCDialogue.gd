extends Node

@export var id : String 

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_on_interact()

func _on_interact() -> void:
	SignalBus.emit_signal("begin_dialogue", id)
