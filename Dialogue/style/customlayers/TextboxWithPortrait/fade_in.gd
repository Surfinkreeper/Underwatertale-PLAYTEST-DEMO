extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var text_system: Node = DialogicUtil.autoload().get(&'Text')
	text_system.connect(&'animation_textbox_hide', _on_textbox_hide)
	text_system.connect(&'animation_textbox_show', _on_textbox_show)
	
func _on_textbox_show():
	play('RESET')
	play("fades/fade_in")

func _on_textbox_hide():
	play('RESET')
	play("fades/fade_out")
