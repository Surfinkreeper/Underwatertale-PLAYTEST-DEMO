extends Area3D


var current_force = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body):
	if body is RigidBody3D:
		body.add_constant_force(Vector3(1,0,0) * current_force)


func _on_body_exited(body):
	if body is RigidBody3D:
		body.add_constant_force(-Vector3(1,0,0) * current_force)
