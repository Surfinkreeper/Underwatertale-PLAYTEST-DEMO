extends Interactable

class_name NPC

@export var timelines : Array[DialogicTimeline]
@onready var mesh = $MeshInstance3D
@onready var chara_sprite = $Sprite3D
@onready var button_display = $Sprite3D/Button

func _ready():
	Dialogic.preload_timeline("res://Dialogue/timelines/placeholder.dtl")
	Dialogic.preload_timeline("res://Dialogue/timelines/test_timeline.dtl")
	Dialogic.preload_timeline("res://Dialogue/timelines/mom_egg_timeline.dtl")
	var style: DialogicStyle = load("res://Dialogue/style/dialogue_test.tres")
	style.prepare()
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func interact(interactor, args=null):
	super.interact(interactor, args)
	
	# SCUFFED !!!!!!!!!!!!
	if name == "PuffMom":
		Dialogic.start("mom_egg_timeline")
		SignalBus.dialogue_started.emit()
		Dialogic.connect("timeline_ended", done_interacting)
	elif name == "WiseMaster":
		Dialogic.start("test_timeline")
		SignalBus.dialogue_started.emit()
		Dialogic.connect("timeline_ended", done_interacting)
		#Dialogic.current_timeline
	print("I INTERACTED WITH " + name +  "!!!")
	get_viewport().set_input_as_handled()

	#cur_interactor.interact_blocked = true
	#cur_interactor.disallow_input()
	#if !can_interact: return
	#if Dialogic.current_timeline != null:
		#return
	#Dialogic.start("test_timeline")
	#Dialogic.connect("timeline_ended", done_interacting)
	##Dialogic.current_timeline
	#print("I INTERACTED WITH " + name +  "!!!")
	
func done_interacting():
	print("OMG WORKED !!")
	if name == "PuffMom":
		Dialogic.VAR.PuffMom.first_time = false
	SignalBus.dialogue_ended.emit()

	if cur_interactor:
		cur_interactor.allow_input()
		cur_interactor.interact_blocked = false
	cur_interactor = null
	

func _on_area_entered(area: Area3D) -> void:
	if area is Interactor:
		print("READY TO INTERACT !!!")
		# TODO write code to show the outline here
		mesh.get_surface_override_material(0).set_shader_parameter("glowSize", 15)
		create_tween().tween_property(button_display, "modulate:a", 1, 0.3)

func _on_area_exited(area: Area3D) -> void:
	if area is Interactor:
		print("UNREADY TO INTERACT !!")
		# TODO write code to unshow the outline here
		mesh.get_surface_override_material(0).set_shader_parameter("glowSize", 5)
		create_tween().tween_property(button_display, "modulate:a", 0, 0.3)
		pass
