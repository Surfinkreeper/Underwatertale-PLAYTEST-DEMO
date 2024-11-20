extends CharacterBody2D

# default move dir... is this stinky ?
@onready var move_dir : Vector2 = Vector2.ZERO
@onready var input_dir : Vector2 = Vector2.ZERO
# note: need a look dir too for this to feel smooth
@export var speed : float = 300.0
@export var look_speed : float = 4

# for fish joint adjustment purposes
@onready var fish_line : Line2D = $Line2D
var memo : Array[Vector2]
var fishplacement : Vector2 = Vector2.ZERO
@export var seg_length : int = 30

func _ready() -> void:
	for i in fish_line.get_point_count():
		memo.append(Vector2.ZERO)

func _input(event: InputEvent) -> void:
	pass
	
	
	

func _physics_process(delta: float) -> void:
	input_dir = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", 'down')
	).normalized()
	
	move_dir = Vector2.ZERO if input_dir == Vector2.ZERO else move_dir.move_toward(input_dir, delta * look_speed)
	#move_dir = input_dir
	velocity = move_dir * speed	# todo make this fancier
	
	move_and_slide()
	
	# update fish bones
	fishplacement = get_position_delta()
	adjust()

func adjust():
	if (fishplacement == Vector2.ZERO): return
	
	for point_ind in fish_line.get_point_count():
		if point_ind == 0:
			memo[0] = fishplacement
		else:
			var current_point: Vector2 = fish_line.get_point_position(point_ind)
			var one_ahead: Vector2 = memo[point_ind - 1]
			var direction := (one_ahead - current_point).normalized()
			memo[point_ind] = one_ahead - direction * seg_length
	
	for point_ind in range(1, fish_line.get_point_count()):
		fish_line.set_point_position(point_ind, memo[point_ind] - fishplacement)
