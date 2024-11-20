extends CharacterBody3D

@onready var skeleton = $Armature/Skeleton3D
@onready var armature = $Armature
var test_box = preload("res://prototyping/resources/3D Models/Test_box.tscn")
var test_boxes = []
var vertices = []
var num_vertices = 0
var velocities = []
var accelerations = []
var colliders = []
var angles = []
var last_moving_dir = Vector3(0,0,-1)
@export var collider_height:float = 2
@export var collider_widths:Array[float] = [2,2.25,2,1.75,1.5,1.25,.75]
var facing: Vector3 = Vector3.FORWARD
@onready var collision_shape = $CollisionShape3D

var min_dist = 0.5
var max_dist = 1
@export var max_speed = 10
@export var head_mass = 1
@export var tail_mass = 0.8
@export var swim_force = 1
@export var water_resistance = 1

var test = false

# Called when the node enters the scene tree for the first time.
func _ready():
	init_vertices()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var x_update = false
	var z_update = false
	if(Input.is_action_pressed("up")):
		facing.z = -1
		z_update = true
		test = true
	elif(Input.is_action_pressed("down")):
		facing.z = 1
		z_update = true
	if(Input.is_action_pressed("left")):
		facing.x = -1
		x_update = true
	elif(Input.is_action_pressed("right")):
		facing.x = 1
		x_update = true
	
	if x_update or z_update: #Input recieved
		if x_update and not z_update:
			facing.z = 0
		if z_update and not x_update:
			facing.x = 0
		facing = facing.normalized()
		apply_force(0,facing*swim_force)
	else:
		for i in range(num_vertices):
			accelerations[i] = Vector3.ZERO
	
	apply_resistance()
	physics_update(delta)
	
	if(Input.is_action_just_pressed("Test")):
		print("positions:",vertices)
		print("velocities:",velocities)
		print("accelerations:",accelerations)
		print()
		
	if(test):
		print("positions:",vertices)
		print("velocities:",velocities)
		print("accelerations:",accelerations)
		print()

func physics_update(delta):
	velocity = velocities[0]
	velocities[0] += accelerations[0] * delta
	move_and_slide()
	vertices[0] = position + last_moving_dir
	for i in range(1,num_vertices):
		vertices[i] += velocities[i] * delta
		velocities[i] += accelerations[i] * delta
		if velocities[i].length() > max_speed:
			velocities[i] = velocities[i].normalized() * max_speed
		if velocities[i].is_zero_approx():
			velocities[i] = Vector3.ZERO
	for i in range(1,num_vertices):
		correct_vertex(i,delta)
	
	
	calculate_angles()
	update_fish_mesh()

func apply_resistance():
	for i in range(num_vertices):
		apply_force(i,-velocities[i].normalized() * water_resistance)

func apply_force(vertex_id:int, force:Vector3):
	accelerations[vertex_id] += force/head_mass

func calculate_angles():
	for i in range(num_vertices-1):
		var bone_dir = vertices[i+1]-vertices[i]
		var angle = Vector3.BACK.angle_to(bone_dir)
		if bone_dir.cross(Vector3.BACK).y < 0:
			angle = -angle
		angles[i] = angle

func correct_vertex(i: int, delta):
	var distance = vertices[i].distance_to(vertices[i-1])
	if distance > max_dist:
		var move_dir = (vertices[i-1] - vertices[i]).normalized()
		vertices[i] = vertices[i-1] + -move_dir * max_dist
		velocities[i] = move_dir*(distance-max_dist/delta)

func update_fish_mesh():
	armature.position = last_moving_dir
	for i in range(num_vertices-1):
		move_bone_tail_to(i,vertices[i+1])

func move_bone_tail_to(bone_id: int, pos: Vector3):
	var head = vertices[bone_id]
	var angle
	if bone_id == 0:
		angle = angles[bone_id]
	else:
		angle = angles[bone_id] - angles[bone_id-1]
	var distance = head.distance_to(pos)
	skeleton.set_bone_pose_rotation(bone_id,Quaternion(Vector3(0,0,1),angle))
	if bone_id != skeleton.get_bone_count()-1:
		skeleton.set_bone_pose_position(bone_id+1,Vector3(0,distance,0))

func init_vertices():
	var prev_coord = armature.position
	num_vertices = skeleton.get_bone_count()+1
	for i in range(num_vertices):
		if i != num_vertices-1:
			var pos = skeleton.get_bone_pose_position(i)
			prev_coord = prev_coord + Vector3(pos.x,pos.z,pos.y)
			vertices.append(prev_coord)
			angles.append(0)
		velocities.append(Vector3.ZERO)
		accelerations.append(Vector3.ZERO)
	vertices.append(prev_coord + Vector3(0,0,1))
