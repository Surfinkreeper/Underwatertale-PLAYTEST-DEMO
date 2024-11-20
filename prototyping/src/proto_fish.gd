extends Line2D

# for doing some quickmafs
@export var seg_length : int = 35
@export var starting_pos : Vector2 = Vector2(200, 200)

# debug (?) flags
var draw_spine = false
@export var draw_hitboxes = false
var draw_fin = true

# fin objects
@export var right_fin : Fin
@export var left_fin : Fin 
@export var right_fin_tail : Fin 
@export var left_fin_tail : Fin 
@export var dorsal_fin : Fin

# for movement
@onready var move_dir := Vector2.ZERO
@onready var look_dir := Vector2.ZERO
@export var look_speed : float
@export var speed : float
@onready var dash_multiplier : float = 1.0

# holding collider segment objects
@onready var collider_segments := []

"""
todo: rework collision

idea: use a rigidbody for movement of the fish (or even a characterbody2d ?)
	& just have the shapes all be children ?

essentially, collisions "dont work" right now because the
rigidbody isn't what controls the fish's movement,
its just controlled by manually changing the position of
the line segments

if you wanna see what I mean, trying instantiating TheDude
in fish.tscn and turning draw_hitboxes to true.

this is good enough for some prototyping but needs
to be changed for a final version

or we could just do a 
	
"""

func _ready() -> void:
	begin_cap_mode = 2
	end_cap_mode = 2
			
	for i in range(points.size() - 1):
		# Create the CollisionShape2D
		var new_shape = CollisionShape2D.new()
		$RigidBody2D.add_child(new_shape)

		# Create the rectangle shape
		var rect := RectangleShape2D.new()

		# Calculate the position, rotation, and length between points
		new_shape.position = (points[i] + points[i + 1]) / 2
		new_shape.rotation = points[i].direction_to(points[i + 1]).angle()
		var length = points[i].distance_to(points[i + 1])

		# Set the rectangle's extents
		rect.extents = Vector2(length / 2, 10)
		new_shape.shape = rect

		# Create a Sprite for visual representation
		var sprite := Sprite2D.new()
		new_shape.add_child(sprite)

		# Load a simple texture (you can replace it with any texture you want)
		sprite.texture = PlaceholderTexture2D.new()

		# Set sprite position, rotation, and scale to match the CollisionShape2D
		sprite.scale = Vector2(length / sprite.texture.get_size().x,
			width_curve.sample((float(i) / float(points.size()))) * 10)
			
		#if i == 3:
			#fourth = width_curve.sample((float(i) / float(points.size()))) * 10
		
		# NOTE: change this line if you want to show the colliders for debug !
		sprite.visible = draw_hitboxes
		
		# add this collider to the list
		collider_segments.append(new_shape)


func _input(event : InputEvent):
	# move_dir_prev = move_dir_prev if move_dir.length() == 0 else move_dir
	#print('woah kenny')
	move_dir = Vector2(Input.get_axis("left", "right"),
		Input.get_axis("up", "down")).normalized()
		
	dash_multiplier = 1.0 + Input.get_action_strength("dash")

func _process(delta: float) -> void:
	
	if move_dir == Vector2.ZERO: return
	look_dir = look_dir if move_dir == Vector2.ZERO else look_dir.move_toward(move_dir, delta * look_speed)
	var rb : RigidBody2D = $RigidBody2D
	var point_count = get_point_count()
	var mouse_pos = get_global_mouse_position()
	
	# moves the nodes on the line
	for point_index in point_count:
		if point_index == 0:
			# calculate the direction of the move
			#move_dir = position.direction_to(mouse_pos)
			# move the first node in the chain there
			var head_pos = get_point_position(0)
			set_point_position(0, head_pos + look_dir * delta * dash_multiplier * speed)
			#position = head_pos + look_dir * delta * speed
			#set_point_position(0, position)
			#print(position)
			# move the locatoin of the object there
			pass
		else:
			# correct position of this node
			var current_point: Vector2 = get_point_position(point_index)
			var one_ahead: Vector2 = get_point_position(point_index - 1)
			var direction := (one_ahead - current_point).normalized()
			
			# check if we can check angle constraints
			# get angle between pt - 1 & pt + 1
			# if that angle is less than the minimum angle allowed
				# target_pos = calculated vec of where the joint would lie
			# if that angle is greater than the maximum angle allowed
				# target_pos = calculated vec of where the joint would lie
			
			set_point_position(point_index, one_ahead - direction * seg_length)
			
	for point_index in range(0, point_count - 1):
		# correct the position of the collider
		var current_collider : CollisionShape2D = collider_segments[point_index]
		current_collider.position = points[point_index]
		current_collider.rotation = points[point_index].direction_to(points[point_index + 1]).angle()
	
	# moves the fins into place
	correct_fins()
	
func correct_fins():
	if not (right_fin and left_fin and right_fin_tail and left_fin_tail):
		return
	
	# pectoral
	var fourth_node := get_point_position(4)
	var third_node := get_point_position(3)
	var diff_norm := (fourth_node - third_node).normalized()
	
	# correct right fin
	right_fin.position = fourth_node + (diff_norm.rotated(90) * 35)
	right_fin.rotation = diff_norm.angle() - PI / 3.5
	
	# correct left fin
	left_fin.position = fourth_node + (diff_norm.rotated(-90) * 35)
	left_fin.rotation = diff_norm.angle() + PI / 3.5
	
	dorsal_fin.position = fourth_node
	dorsal_fin.rotation = diff_norm.angle() + PI / 2
	
	# tail fins
	var final_node := get_point_position(get_point_count()-2)
	var second_to_last := get_point_position(get_point_count()-3)
	var difference_norm := (final_node - second_to_last).normalized()
	
	# correct right tail
	right_fin_tail.position = final_node + (difference_norm.rotated(90) * 5)
	right_fin_tail.rotation = difference_norm.angle() - PI / 3
	
	# correct left tail
	left_fin_tail.position = final_node + (difference_norm.rotated(-90) * 5)
	left_fin_tail.rotation = difference_norm.angle() + PI / 3
	
	
			
func _draw() -> void:
	if draw_spine:
		for point_index in get_point_count():
			var point_position = get_point_position(point_index)
			draw_circle(point_position, 20, Color.AQUAMARINE)
	
	draw_set_transform(get_point_position(0), look_dir.angle(), Vector2.ONE)
	
	# draw eyes
	draw_circle(Vector2.UP * 40, 5, Color.AQUAMARINE)
	draw_circle(Vector2.DOWN * 40, 5, Color.AQUAMARINE)
	
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
