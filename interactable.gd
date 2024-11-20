extends Area3D

class_name Interactable

@onready var can_interact : bool = true
@onready var cur_interactor : Interactor = null

signal dialogue_started
signal dialogue_finished

# an interactable object has a area3d that

func _ready():
	#Dialogic.preload_timeline("res://Dialogue/timelines/placeholder.dtl")
	#Dialogic.preload_timeline("res://Dialogue/timelines/test_timeline.dtl")
	var style: DialogicStyle = load("res://Dialogue/style/dialogue_test.tres")
	style.prepare()


func interact(interactor, _args = null):
	cur_interactor = interactor
	cur_interactor.interact_blocked = true
	cur_interactor.disallow_input()
	
	if !can_interact:
		return
	if Dialogic.current_timeline != null:
		return


# connect this to a signal
func done_interacting():
	dialogue_finished.emit()
	print("OMG WORKED !!")
	if cur_interactor:
		cur_interactor.allow_input()
		cur_interactor.interact_blocked = false
	cur_interactor = null


#func _on_area_entered(area: Area3D) -> void:
	#if area is Interactor:
		#print("READY TO INTERACT !!!")
