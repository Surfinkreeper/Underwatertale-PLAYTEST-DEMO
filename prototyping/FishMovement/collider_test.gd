extends Node3D

@onready var head:RigidBody3D = $Fish/Head
@onready var fish:Node3D = $Fish
var rbs = []
var num_vertices = 7
var vertices = []
var facing = Vector3(0,0,-1)
@export var force = 10
@export var water_resistance = 1
var test = 2
var stretching = true

@export var resistance_coef = 1
@export var swim_force = 80
var max_distance = 1
var moving
# Called when the node enters the scene tree for the first time.
func _ready():
	rbs = fish.get_children()
	for i in range(num_vertices):
		vertices.append(Vector3.ZERO)
	update_vertices()


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
		head.apply_force(facing * swim_force)
	else:
		moving = false
	
	apply_resistance()
	correct_vertices(delta)
	update_vertices()
	if Input.is_action_just_pressed("Test"):
		print(vertices)

func update_vertices():
	vertices[0] = head.position + facing
	for i in range(1,num_vertices):
		vertices[i] = rbs[i-1].position

func apply_resistance():
	for rb in rbs:
		var force = resistance_coef * -rb.linear_velocity.normalized() * pow(rb.linear_velocity.length(),2)
		if not force.is_zero_approx():
			rb.apply_force(force)
		if not moving and rb.linear_velocity.length() < 0.8:
			rb.linear_velocity = Vector3.ZERO

func correct_vertices(delta):
	for i in range(1,rbs.size()): 
		var distance = rbs[i].position.distance_to(rbs[i-1].position)
		if distance > max_distance:
			var dir = rbs[i].position.direction_to(rbs[i-1].position)
			var correction = dir * (distance-max_distance)
			rbs[i].linear_velocity = correction/delta
