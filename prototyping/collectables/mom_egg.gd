extends Interactable

var collected_once = false
var able_to_collect = false
@onready var bubble_particles = $GPUParticles3D
@onready var soundfx = $AudioStreamPlayer
@onready var mesh = $MeshInstance3D


func interact(interactor, args=null):
	
	if not Dialogic.VAR.PuffMom.first_time and not collected_once:
		SignalBus.egg_collected.emit()
		Dialogic.VAR.PuffMom.eggs += 1
		mesh.visible = false
		bubble_particles.emitting = true
		soundfx.playing = true
		collected_once = true
