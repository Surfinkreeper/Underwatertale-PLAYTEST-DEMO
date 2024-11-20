extends Node3D

var test_box = load("res://prototyping/resources/3D Models/Test_box.tscn")
var test_boxes = []
var vertices = []
var angles = []
var velocities = []
var accelerations = []
var masses = [2,2.25,2,1.75,1.5,1.25,.75]
var facing = Vector3(0,0,-1)
var moving = false
var num_vertices = 7
var max_distance = 1

@onready var skeleton = $Armature/Skeleton3D
@onready var armature = $Armature

@export var resistance_coef = 1
@export var swim_force = 300
# Called when the node enters the scene tree for the first time.
func _ready():
	var first_coord = Vector3(0,0,-1)
	for i in range(num_vertices):
		vertices.append(first_coord + Vector3(0,0,i))
		angles.append(0)
		velocities.append(Vector3.ZERO)
		accelerations.append(Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var x_update = false
	var z_update = false
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
	
	if x_update or z_update: #Input recieved
		moving = true
		if x_update and not z_update:
			facing.z = 0
		if z_update and not x_update:
			facing.x = 0
		facing = facing.normalized()
		apply_force(0,swim_force * facing)
	else:
		moving = false
	
	#for i in range(num_vertices):
		#apply_force(i,Vector3(120,0,0))
	
	apply_resistance()
	update_physics(delta)
	
	calculate_angles()
	update_fish_mesh()
	#print("positions:",vertices)
	#print("velocities:",velocities)
	#print("accelerations:",accelerations)
	#print()

func update_physics(delta):
	for i in range(num_vertices):
		vertices[i] += velocities[i] * delta
		velocities[i] += accelerations[i] * delta
		if i > 0:
			correct_vertex(i,delta)
		if not moving and velocities[i].length() < 1:
			velocities[i].x = 0
			velocities[i].y = 0
			velocities[i].z = 0
		accelerations[i].x = 0
		accelerations[i].y = 0
		accelerations[i].z = 0

func correct_vertex(i:int,delta):
	var distance = vertices[i].distance_to(vertices[i-1])
	if distance > max_distance:
		var dir = vertices[i].direction_to(vertices[i-1])
		var correction = dir * (distance-max_distance)
		velocities[i] = correction/delta

func apply_force(i:int, force:Vector3):
	accelerations[i] += force/masses[i]

func apply_resistance():
	for i in range(num_vertices):
		var force = resistance_coef * -velocities[i].normalized() * pow(velocities[i].length(),2)
		if not force.is_zero_approx():
			apply_force(i,force)

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
