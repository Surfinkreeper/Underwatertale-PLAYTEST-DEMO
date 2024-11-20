extends Node3D

class_name Fish

@onready var head:RigidBody3D = $Colliders/Head
@onready var colliders:Node3D = $Colliders
@onready var skeleton:Skeleton3D = $Armature/Skeleton3D
@onready var armature:Node3D = $Armature
var rbs = []
var num_vertices = 7
var vertices = []
var vertex_map = [0,1,2,3,4,6,8]
var angles = []
var facing = Vector3(0,0,-1)
var test = 2
var stretching = true

var desired_scale:float = 1
var desired_rotation:float = 0

@onready var can_move : bool = true
@onready var can_input : bool = true

@export var resistance_coef = 1
@export var swim_force = 200
@export var dash_modifier = 5
@export var dash_duration = 0.5
var dash_time = 0
var default_swim_force
var max_distances = [1,1,1,1,0.5,0.5,0.5,0.5]
var moving

# Called when the node enters the scene tree for the first time.
func _ready():
	default_swim_force = swim_force
	desired_scale = scale.x
	scale = Vector3.ONE
	desired_rotation = rotation.y
	rotation = Vector3.ZERO
	
	rbs = colliders.get_children()
	for i in range(num_vertices):
		vertices.append(Vector3.ZERO)
		angles.append(0)
	
	if desired_rotation != 0:
		for rb in rbs:
			rb.position = rb.position.rotated(Vector3(0,1,0),desired_rotation)
	
	if desired_scale != 1:
		armature.scale = Vector3.ONE * desired_scale
		for i in range(max_distances.size()):
			max_distances[i] *= desired_scale
		for rb:RigidBody3D in rbs:
			rb.position *= desired_scale
			rb.get_child(0).shape.radius *= desired_scale
			rb.get_child(0).shape.height *= desired_scale
	
		
	update_vertices()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var x_update = false
	var z_update = false

	if can_input:
		if(Input.is_action_pressed("up")):
			facing.z = -1
			z_update = true
		elif(Input.is_action_pressed("down")):
			facing.z = 1
			z_update = true
		if(Input.is_action_pressed("left")):
			facing.x = -1
			x_update = true
		elif(Input.is_action_pressed("right")):
			facing.x = 1
			x_update = true
	
	if(dash_time <= 0 and Input.is_action_just_pressed("Dash")):
		swim_force *= dash_modifier
		dash_time = dash_duration
	elif(dash_time <= 0):
		dash_time = 0
		swim_force = default_swim_force
	elif(dash_time > 0):
		var decrease = (default_swim_force*dash_modifier - default_swim_force)*(delta/dash_duration)
		swim_force -= decrease
		dash_time -= delta
	
	if x_update or z_update: #Input recieved
		moving = true
		if x_update and not z_update:
			facing.z = 0
		if z_update and not x_update:
			facing.x = 0
		facing = facing.normalized()
		# FORCE APPLIED HERE !!!
		if can_move: 
			moving = true
			head.apply_force(facing * swim_force * desired_scale)
	else:
		moving = false
	correct_vertices(delta)
	apply_resistance()
	update_vertices()
	calculate_angles()
	update_fish_mesh()
	#if Input.is_action_just_pressed("Test"):
		#for rb in rbs:
			#print(rb.linear_velocity)
		#print()

func update_vertices():
	for i in range(num_vertices):
		vertices[i] = rbs[vertex_map[i]].position

func apply_resistance():
	for rb in rbs:
		var res_force = resistance_coef * -rb.linear_velocity.normalized() * pow(rb.linear_velocity.length(),2)
		if not res_force.is_zero_approx():
			rb.apply_force(res_force)
		if not moving and rb.linear_velocity.length() < 0.8:
			rb.linear_velocity = Vector3.ZERO

func correct_vertices(delta):
	for i in range(1,rbs.size()): 
		var distance = rbs[i].position.distance_to(rbs[i-1].position)
		if distance > max_distances[i-1]:
			var dir = rbs[i].position.direction_to(rbs[i-1].position)
			var correction = dir * (distance-max_distances[i-1])
			rbs[i].position += correction
			var new_v = correction/delta
			if new_v.is_finite():
				rbs[i].linear_velocity = new_v

func calculate_angles():
	for i in range(num_vertices-1):
		var bone_dir = vertices[i+1]-vertices[i]
		var angle = Vector3.BACK.angle_to(bone_dir)
		if bone_dir.cross(Vector3.BACK).y < 0:
			angle = -angle
		angles[i] = angle

func update_fish_mesh():
	armature.position = vertices[0]
	for i in range(num_vertices-1):
		move_bone_tail_to(i,vertices[i+1])

func move_bone_tail_to(bone_id: int, pos: Vector3):
	var headv = vertices[bone_id]
	var angle
	if bone_id == 0:
		angle = angles[bone_id]
	else:
		angle = angles[bone_id] - angles[bone_id-1]
	var distance = headv.distance_to(pos)
	skeleton.set_bone_pose_rotation(bone_id,Quaternion(Vector3(0,0,1),angle))
	if bone_id != skeleton.get_bone_count()-1:
		skeleton.set_bone_pose_position(bone_id+1,Vector3(0,distance/desired_scale,0))


func _on_dialogue_started() -> void:
	can_input = false

func _on_dialogue_finished() -> void:
	can_input = true
