extends Area3D

class_name Interactor

@export var cooldown = 1.0
var timer
@onready var on_cooldown = false
@onready var interact_blocked = false	# managed by interactables
@export var my_fish : Fish



# an interactor checks every frame if its 
# in an InteractableArea3D

# if it is & the "interact" bind is pressed, 
# it will call the InteractableArea3D's "interact" method

func _unhandled_input(event: InputEvent) -> void:
	if Input.get_action_raw_strength("interact"):
		if on_cooldown or interact_blocked: return
		start_cooldown()
		var areas = get_interactables(
			get_overlapping_areas())
			
		#for inter in areas:
			#print(inter.name, " is angle ", ((global_position - inter.global_position) as Vector3).angle_to(Vector3.BACK.rotated(Vector3.UP, (my_fish as Fish).angles[0])))
		if not areas: return
		var closest_area = get_closest_interactable(areas)
		(closest_area as Interactable).interact(self)


func get_closest_interactable(areas: Array):
	var dists : Array[float] = []
	for i in range(0, len(areas)):
		dists.append(global_position.distance_to(areas[i].global_position))
	var minimum_dist = 100000
	for dist in dists:
		if dist < minimum_dist:
			minimum_dist = dist
	return areas[dists.find(minimum_dist)]


func get_interactables(areas):
	var interactables = []
	for area in areas:
		if area is Interactable:
			interactables.append(area)
	#if interactables:
		#print(len(interactables), " interactables found")
	return interactables


func start_cooldown():
	on_cooldown = true
	timer = get_tree().create_timer(cooldown)
	timer.timeout.connect(cooldown_end)


func cooldown_end():
	on_cooldown = false


# special interactable object methods
func disallow_input():
	my_fish.can_input = false

func allow_input():
	my_fish.can_input = true
