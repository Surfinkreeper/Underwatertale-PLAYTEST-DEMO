extends Node3D

@export var camera:Camera3D
@export var fish:Fish
@export var rooms:Array
@export var block_size: float
@export var region_width: float
@export var region_height: float
var adj_Regions:Array
var spawnpoints:Array
var viewport_length
var unseen_length
var camera_height
var camera_z_offset
var min_x:float
var max_x:float
var min_z:float
var max_z:float

func _ready():
	var viewport_size = get_viewport().size
	camera_height = camera.position.y
	var theta = -camera.rotation.x
	camera_z_offset = (camera_height-2) * tan(PI/2 - theta)
	var viewport_width = camera.size * (float(viewport_size.x))/(float(viewport_size.y))
	var viewport_height = camera.size/sin(theta)
	min_x = -region_width*0.5*block_size + viewport_width*0.5
	max_x = region_width*0.5*block_size - viewport_width*0.5
	min_z = -region_height*0.5*block_size + 0.5*viewport_height + camera_z_offset
	max_z = region_height*0.5*block_size -0.5*viewport_height + camera_z_offset

func _process(delta):
	var fish_position = fish.armature.position
	var new_position = Vector3(fish_position.x,camera_height,fish_position.z + camera_z_offset)
	camera.position = Vector3(clampf(new_position.x,min_x,max_x),new_position.y,clampf(new_position.z,min_z,max_z))
